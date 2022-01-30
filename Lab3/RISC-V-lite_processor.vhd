LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- RISC-V-lite processor (top level description)
-- inputs and outputs are the connections with Instruction and Data memories

ENTITY RISC-V-lite_processor IS
	PORT(
			-- clock and reset signals
			Clk, Rst    : IN STD_LOGIC;
			-- from Instruction memory
			Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- from Data memory
			Data        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			-- to Instruction memory
			ProgramCounter : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- to Data memory
			Address        : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
			WriteData      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			MemRead        : OUT STD_LOGIC;
			MemWrite       : OUT STD_LOGIC);
END RISC-V-lite_processor;

ARCHITECTURE rtl OF RISC-V-lite_processor IS
	-- PIPELINE: 1st stage
	SIGNAL Instruction_pipe1    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ProgramCounter_pipe1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Control Unit
	SIGNAL Branch, MemRead            : STD_LOGIC;
	SIGNAL MemtoReg, ALUOp            : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL MemWrite, ALUSrc, RegWrite : STD_LOGIC;
	
	-- immediate value Generator
	SIGNAL Immediate : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- file register
	SIGNAL rs1, rs2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- PIPELINE: 2nd stage
	SIGNAL PipeReg2 : STD_LOGIC_VECTOR(168 DOWNTO 0);
	SIGNAL PipeReg2_ctrl : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	-- sign-extended file register outputs
	SIGNAL rs1_ext, rs2_ext : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- ALU Control Unit
	SIGNAL ALUCtrl : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- ALU 2nd operand multiplexer
	SIGNAL ALU_2nd_op : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- ALU
	SIGNAL ALU_result : SIGNED(63 DOWNTO 0);
	SIGNAL zero_flag : STD_LOGIC;
	
	-- AddSub
	SIGNAL JmpAddress : UNSIGNED(31 DOWNTO 0);
	SIGNAL ImmShifted : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- PIPELINE: 3rd stage
	SIGNAL PipeReg3 : STD_LOGIC_VECTOR(107 DOWNTO 0);
	
	-- Write Data (File Register) multiplexer
	SIGNAL WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Program Counter Input
	SIGNAL InProgramCounter : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Control Unit
	COMPONENT CU IS
		PORT(
			opcode   : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- instruction[6-0]
			
			Branch   : OUT STD_LOGIC; -- allows branching
			MemRead  : OUT STD_LOGIC; -- data memory RD signal
			MemtoReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- selects WriteReg source
			ALUOp    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- controls ALUControlUnit
			MemWrite : OUT STD_LOGIC; -- data memory WR signal
			ALUSrc   : OUT STD_LOGIC; -- selects ALU 2nd operand
			RegWrite : OUT STD_LOGIC); -- register file WR signal
	END COMPONENT;
	
	-- ALU Control Unit
	COMPONENT ALU_CU IS
		PORT(
			from_inst : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ALUOp     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			
			ALUCtrl   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	-- N-bit 2to1 multiplexer
	COMPONENT mux2to1xN IS
	GENERIC (N : INTEGER := 32);
	PORT(
			IN0 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			IN1 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			s : IN STD_LOGIC; -- control signal
			
			M : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;

	-- immediate value Generator
	COMPONENT ImmGen IS
		PORT(
			inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			imm  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
	END COMPONENT;
	
	-- N-bit register (positive edge triggered)
	COMPONENT Regn IS
		GENERIC ( N : integer:=16);
		PORT (R         : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0); -- input
			Clock, Reset : IN STD_LOGIC; -- clock, reset, load signals
			Q            : OUT STD_LOGIC_VECTOR(22 DOWNTO 0)); -- output
	END COMPONENT;
	
	-- ALU
	COMPONENT ALU IS
	PORT(
		--Data IN
		In_Rs1 : IN SIGNED(63 DOWNTO 0);
		In_Rs2_Imm : IN SIGNED(63 DOWNTO 0);
		
		--Data Control
		In_from_ALU_CU : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		--Data OUT
		Out_ALU_resul : OUT SIGNED(63 DOWNTO 0);
		Out_Zero_flag : OUT STD_LOGIC
		);

	END COMPONENT;
	
	-- Adder/subtractor
	COMPONENT AddSum IS
	PORT(
		In_from_PC : IN UNSIGNED(31 DOWNTO 0);
		In_from_ShiftR : IN UNSIGNED(31 DOWNTO 0);
		
		Out_AddSum : OUT UNSIGNED(31 DOWNTO 0)
		);

	END COMPONENT;
	
	-- RegStage3
	COMPONENT Reg_pipe_3 IS
	PORT(
		In_reg : IN SIGNED(139 DOWNTO 0);
		
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		
		Out_reg : OUT SIGNED(139 DOWNTO 0)
		);

	END COMPONENT;
	
	-- RegStage4
	COMPONENT Reg_pipe_4 IS
	PORT(
		In_reg_pipe4 : IN STD_LOGIC_VECTOR(103 DOWNTO 0);
		
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		
		Out_reg_pipe4 : OUT STD_LOGIC_VECTOR(103 DOWNTO 0)
		);
	END COMPONENT;
	
	-- multiplexer 3to1x32 bit
	COMPONENT Mux3to1_32b IS
	PORT(
		In00 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In01 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In10 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);

	END COMPONENT;
	
BEGIN
	-- PIPELINE: 1st stage
	pipe1_1: Regn GENERIC MAP (N => 32)
					PORT MAP (R => Instruction, Clock => Clk,
									Reset => Rst, Q => Instruction_pipe1);
	pipe1_2: Regn GENERIC MAP (N => 32)
					PORT MAP (R => ProgramCounter, Clock => Clk,
									Reset => Rst, Q => ProgramCounter_pipe1);
	
	-- Control Unit
	ControlUnit: CU PORT MAP (opcode => Instruction(6 DOWNTO 0),
						Branch => Branch, MemRead => MemRead,
						MemtoReg => MemtoReg, ALUOp => ALUOp,
						MemWrite => MemWrite, ALUSrc => ALUSrc,
						RegWrite => RegWrite);
	
	-- immediate value Generator
	ImmediateGenerator: ImmGen PORT MAP (inst => Instruction_pipe1,
													imm => Immediate);
	
	-- PIPELINE: 2nd stage
	pipe2: Regn GENERIC MAP (N => 169)
					PORT MAP (Clock => Clk, Reset => Rst,
						R(168 DOWNTO 164) => Instruction_pipe1(11 DOWNTO 7),
						R(163 DOWNTO 160) => Instruction_pipe1(30) & Instruction_pipe1(14 DOWNTO 12),
						R(159 DOWNTO 96) => Immediate,
						R(95 DOWNTO 64) => rs2,
						R(63 DOWNTO 32) => rs1,
						R(31 DOWNTO 0) => ProgramCounter_pipe1,
						D => PipeReg2);
						
	pipe2_controls: Regn GENERIC MAP (N => 9)
								PORT MAP (Clock => Clk, Reset => Rst,
									R(8 DOWNTO 6) => ALUSrc & ALUOp,
									R(5 DOWNTO 3) => MemWrite & MemRead & Branch,
									R(2 DOWNTO 0) => MemtoReg & RegWrite,
									D => PipeReg2_ctrl);
					
	-- ALU Control Unit
	ALUControlUnit: ALU_CU PORT MAP (from_inst => PipeReg2(163 DOWNTO 160),
											ALUOp => PipeReg2_ctrl(7 DOWNTO 6),
											ALUCtrl => ALUCtrl);
											
	-- ALU 2nd operand multiplexer
	rs2_ext(63 DOWNTO 32) <= (OTHERS => PipeReg2(95));
	rs2_ext(31 DOWNTO 0) <= PipeReg2(95 DOWNTO 64);
	ALUmux: mux2to1xN GENERIC MAP (N => 64)
							PORT MAP (IN0 => rs2_ext,
								IN1 => PipeReg2(159 DOWNTO 96),
								s => PipeReg2_ctrl(8),
								M => ALU_2nd_op);
								
	-- ALU
	rs1_ext(63 DOWNTO 32) <= (OTHERS => PipeReg2(63));
	rs1_ext(31 DOWNTO 0) <= PipeReg2(63 DOWNTO 32);
	ALU: ALU PORT MAP (SIGNED(rs1_ext), SIGNED(ALU_2nd_op), ALUCtrl, ALU_result, zero_flag);
	
	-- Adder/subtractor
	ImmShifted <= PipeReg2(126 DOWNTO 96) & '0';
	addsub: AddSub PORT MAP (UNSIGNED(PipeReg2(31 DOWNTO 0)), UNSIGNED(ImmShifted), JmpAddress);
	
	-- PIPELINE: 3rd stage
	pipe3: Reg_pipe_3 PORT MAP (In_reg(107 DOWNTO 103) => PipeReg2(168 DOWNTO 164),
								In_reg(102 DOWNTO 71) => PipeReg2(95 DOWNTO 64),
								In_reg(70 DOWNTO 39) => ALU_result(31 DOWNTO 0),
								In_reg(38) => zero_flag, In_reg(37 DOWNTO 6) => JmpAddress,
								In_reg(5 DOWNTO 0) => PipeReg2_ctrl(5 DOWNTO 0),
								clk => Clk, rst => Rst, OutReg => PipeReg3);
	
	-- Branching AND
	PCSrc <= PipeReg3(3) AND PipeReg3(38);
	
	-- PIPELINE: 4th stage
	pipe4: Reg_pipe_4 PORT MAP (In_reg_pipe4(103 DOWNTO 72) => InProgramCounter,
								In_reg_pipe4(71 DOWNTO 67) => PipeReg3(107 DOWNTO 103),
								In_reg_pipe4(66 DOWNTO 35) => PipeReg3(102 DOWNTO 71),
								In_reg_pipe4(34 DOWNTO 3) => Data,
								In_reg_pipe4(2 DOWNTO 0) => PipeReg3(2 DOWNTO 0),
								clk => Clk, rst => Rst, Out_reg_pipe4 => PipeReg4);
	
	-- Write Data (File Register) Multiplexer
	WriteDataMux: Mux3to1_32b PORT MAP(PipeReg4(66 DOWNTO 35), PipeReg4(34 DOWNTO 3),
								InProgramCounter, PipeReg4(2 DOWNTO 1), WriteData);
	
END rtl;