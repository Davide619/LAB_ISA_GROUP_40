LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- RISC-V-lite processor (top level description)
-- inputs and outputs are the connections with Instruction and Data memories

ENTITY RISCVlite_processor IS
	PORT(
			-- clock and reset signals
			Clk, Rst    : IN STD_LOGIC;
			-- from Instruction memory
			Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- from Data memory
			Data        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			-- to Instruction memory
			ProgramCounter : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- to Data memory
			Address        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			WriteData      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			MemRead        : OUT STD_LOGIC;
			MemWrite       : OUT STD_LOGIC);
END RISCVlite_processor;

ARCHITECTURE rtl OF RISCVlite_processor IS
	
	-- OUTPUT
	SIGNAL ProgramCounter_buff : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Address_buff        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- PIPELINE: 1st stage
	SIGNAL Instruction_pipe1    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ProgramCounter_pipe1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Control Unit
	SIGNAL Branch, MemRead_cu           : STD_LOGIC;
	SIGNAL MemtoReg, ALUOp, ALUSrc      : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL MemWrite_cu, RegWrite        : STD_LOGIC;
	
	-- immediate value Generator
	SIGNAL Immediate : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- file register
	SIGNAL rs1, rs2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- PIPELINE: 2nd stage
	SIGNAL PipeReg2       : STD_LOGIC_VECTOR(168 DOWNTO 0);
	SIGNAL PipeReg2_ctrl  : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL PC_plus4_pipe2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- sign-extended file register outputs
	SIGNAL rs1_ext, rs2_ext : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- ALU Control Unit
	SIGNAL ALUCtrl : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- ALU 1ST operand multiplexer
	SIGNAL PC_pipe2_ext : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL ALU_1st_op   : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- ALU 2nd operand multiplexer
	SIGNAL ALU_2nd_op : STD_LOGIC_VECTOR(63 DOWNTO 0);
	
	-- ALU
	SIGNAL ALU_result : SIGNED(63 DOWNTO 0);
	SIGNAL zero_flag : STD_LOGIC;
	
	-- Addresses adder
	SIGNAL JmpAddress : UNSIGNED(31 DOWNTO 0);
	
	-- PIPELINE: 3rd stage
	SIGNAL PipeReg3       : STD_LOGIC_VECTOR(107 DOWNTO 0);
	SIGNAL PC_plus4_pipe3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Immediate_pipe3: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Branching AND
	SIGNAL PCSrc : STD_LOGIC;
	
	-- PIPELINE: 4th stage
	SIGNAL PipeReg4       : STD_LOGIC_VECTOR(103 DOWNTO 0);
	SIGNAL PC_plus4_pipe4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Write Data (File Register) multiplexer
	SIGNAL WriteData_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Program Counter Input
	SIGNAL PC_plus4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_plus4_pipe1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- fetch component
	COMPONENT fetch IS
		GENERIC(N : integer:=64);
		PORT (     -- clock, reset and Program Counter input selector
	   	CLK, RESET, PC_Src    : IN  STD_LOGIC;
      	   	-- jump address
    	   	JMP_ADD               : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      
	   	-- Program Counter input
      	PC_plus4  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
	   	-- Instruction Memory address (PC output)
	   	INS_ADD   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	-- Control Unit
	COMPONENT CU IS
		PORT(
			opcode   : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- instruction[6-0]
			
			Branch   : OUT STD_LOGIC; -- allows branching
			MemRead  : OUT STD_LOGIC; -- data memory RD signal
			MemtoReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- selects WriteReg source
			ALUOp    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- controls ALUControlUnit
			MemWrite : OUT STD_LOGIC; -- data memory WR signal
			ALUSrc   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- selects ALU 2nd operand
			RegWrite : OUT STD_LOGIC); -- register file WR signal
	END COMPONENT;
	
	-- Register File
	COMPONENT reg_files IS
  		PORT (
           	REG_WR           : IN STD_LOGIC;                         -----regwrite 
           	REG1             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 1
           	REG2             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 2
           	WR_REG           : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----write register 
           	INP              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);     -----write data
           	OUT1             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);    -----read  data
           	OUT2             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);    -----read  data
           	CLK, RST         : IN std_logic);
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
			Q            : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)); -- output
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
	
	-- Addresses adder
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
		In_reg : IN STD_LOGIC_VECTOR(107 DOWNTO 0);
		
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		
		Out_reg : OUT STD_LOGIC_VECTOR(107 DOWNTO 0)
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
	
	-- multiplexer 4to1x32 bit
	COMPONENT Mux4to1_32b IS
	PORT(
		In00 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In01 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In10 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In11 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);

	END COMPONENT;
	
BEGIN

	-- fetch component (contains Program Counter)
	fetch_cmp: fetch GENERIC MAP (N => 32)
			PORT MAP (CLK => Clk, RESET => Rst, PC_Src => PCSrc,
				  JMP_ADD => PipeReg3(37 DOWNTO 6),
				  PC_plus4 => PC_plus4,
				  INS_ADD => ProgramCounter_buff);
	
	-- PIPELINE: 1st stage
	pipe1_0: Regn GENERIC MAP (N => 32)
					PORT MAP (R => PC_plus4, Clock => Clk,
									Reset => Rst, Q => PC_plus4_pipe1);
									
	pipe1_1: Regn GENERIC MAP (N => 32)
					PORT MAP (R => Instruction, Clock => Clk,
									Reset => Rst, Q => Instruction_pipe1);
									
	pipe1_2: Regn GENERIC MAP (N => 32)
					PORT MAP (R => ProgramCounter_buff, Clock => Clk,
									Reset => Rst, Q => ProgramCounter_pipe1);
	
	-- Control Unit
	ControlUnit: CU PORT MAP (opcode => Instruction_pipe1(6 DOWNTO 0),
						Branch => Branch, MemRead => MemRead_cu,
						MemtoReg => MemtoReg, ALUOp => ALUOp,
						MemWrite => MemWrite_cu, ALUSrc => ALUSrc,
						RegWrite => RegWrite);
	
	-- Register File
	RF: reg_files PORT MAP (
			REG_WR => PipeReg4(0),
			REG1 => Instruction_pipe1(19 DOWNTO 15), REG2 => Instruction_pipe1(24 DOWNTO 20),
			WR_REG => PipeReg4(71 DOWNTO 67), INP => WriteData_reg,
			OUT1 => rs1, OUT2 => rs2,
			CLK => Clk, RST => Rst);

	-- immediate value Generator
	ImmediateGenerator: ImmGen PORT MAP (inst => Instruction_pipe1,
													imm => Immediate);
	
	-- PIPELINE: 2nd stage
	pipe2_0: Regn GENERIC MAP (N => 32)
						PORT MAP (Clock => Clk, Reset => Rst,
							R => PC_plus4_pipe1, Q => PC_plus4_pipe2);
						
	pipe2_1: Regn GENERIC MAP (N => 169)
					PORT MAP (Clock => Clk, Reset => Rst,
						R(168 DOWNTO 164) => Instruction_pipe1(11 DOWNTO 7),
						R(163) => Instruction_pipe1(30),
						R(162 DOWNTO 160) => Instruction_pipe1(14 DOWNTO 12),
						R(159 DOWNTO 96) => Immediate,
						R(95 DOWNTO 64) => rs2,
						R(63 DOWNTO 32) => rs1,
						R(31 DOWNTO 0) => ProgramCounter_pipe1,
						Q => PipeReg2);
	
	pipe2_controls: Regn GENERIC MAP (N => 10)
								PORT MAP (Clock => Clk, Reset => Rst,
									R(9 DOWNTO 8) => ALUSrc,
									R(7 DOWNTO 6) => ALUOp,
									R(5) => MemWrite_cu,
									R(4) => MemRead_cu,
									R(3) => Branch,
									R(2 DOWNTO 1) => MemtoReg,
									R(0) => RegWrite,
									Q => PipeReg2_ctrl);
	
	-- ALU Control Unit
	ALUControlUnit: ALU_CU PORT MAP (from_inst => PipeReg2(163 DOWNTO 160),
											ALUOp => PipeReg2_ctrl(7 DOWNTO 6),
											ALUCtrl => ALUCtrl);
	
	-- ALU 1st operand multiplexer
	rs1_ext(63 DOWNTO 32) <= (OTHERS => PipeReg2(63));
	rs1_ext(31 DOWNTO 0) <= PipeReg2(63 DOWNTO 32);
	
	PC_pipe2_ext(63 DOWNTO 32) <= (OTHERS => '0');
	PC_pipe2_ext(31 DOWNTO 0) <= PipeReg2(31 DOWNTO 0);
	
	ALU1mux: mux2to1xN GENERIC MAP (N => 64)
							PORT MAP (IN0 => rs1_ext,
								IN1 => PC_pipe2_ext,
								s => PipeReg2_ctrl(9),
								M => ALU_1st_op);
	
	-- ALU 2nd operand multiplexer
	rs2_ext(63 DOWNTO 32) <= (OTHERS => PipeReg2(95));
	rs2_ext(31 DOWNTO 0) <= PipeReg2(95 DOWNTO 64);
	ALU2mux: mux2to1xN GENERIC MAP (N => 64)
							PORT MAP (IN0 => rs2_ext,
								IN1 => PipeReg2(159 DOWNTO 96),
								s => PipeReg2_ctrl(8),
								M => ALU_2nd_op);
	
	-- ALU
	ALU_cmp: ALU PORT MAP (SIGNED(ALU_1st_op), SIGNED(ALU_2nd_op), ALUCtrl, ALU_result, zero_flag);
	
	-- Addresses adder
	add_sum: AddSum PORT MAP (UNSIGNED(PipeReg2(31 DOWNTO 0)), UNSIGNED(PipeReg2(127 DOWNTO 96)), JmpAddress);
	
	-- PIPELINE: 3rd stage
	pipe3_0: Regn GENERIC MAP (N => 32)
						PORT MAP (Clock => Clk, Reset => Rst,
							R => PC_plus4_pipe2, Q => PC_plus4_pipe3);
							
	pipe3_1: Reg_pipe_3 PORT MAP (In_reg(107 DOWNTO 103) => PipeReg2(168 DOWNTO 164),
								In_reg(102 DOWNTO 71) => PipeReg2(95 DOWNTO 64),
								In_reg(70 DOWNTO 39) => STD_LOGIC_VECTOR(ALU_result(31 DOWNTO 0)),
								In_reg(38) => zero_flag, In_reg(37 DOWNTO 6) => STD_LOGIC_VECTOR(JmpAddress),
								In_reg(5 DOWNTO 0) => PipeReg2_ctrl(5 DOWNTO 0),
								clk => Clk, rst => Rst, Out_reg => PipeReg3);
								
	pipe3_2: Regn GENERIC MAP (N => 32)
						PORT MAP (Clock => Clk, Reset => Rst,
							R => PipeReg2(127 DOWNTO 96), Q => Immediate_pipe3);
	
	-- Branching AND
	branch_AND: PCSrc <= PipeReg3(3) AND PipeReg3(38);
	
	-- PIPELINE: 4th stage
	pipe4_0: Regn GENERIC MAP (N => 32)
						PORT MAP (Clock => Clk, Reset => Rst,
							R => PC_plus4_pipe3, Q => PC_plus4_pipe4);
	
	pipe4_1: Reg_pipe_4 PORT MAP (In_reg_pipe4(103 DOWNTO 72) => Immediate_pipe3,
								In_reg_pipe4(71 DOWNTO 67) => PipeReg3(107 DOWNTO 103),
								In_reg_pipe4(66 DOWNTO 35) => PipeReg3(70 DOWNTO 39),
								In_reg_pipe4(34 DOWNTO 3) => Data,
								In_reg_pipe4(2 DOWNTO 0) => PipeReg3(2 DOWNTO 0),
								clk => Clk, rst => Rst, Out_reg_pipe4 => PipeReg4);
	
	-- Write Data (File Register) Multiplexer
	WriteDataMux: Mux4to1_32b PORT MAP(PipeReg4(66 DOWNTO 35), PipeReg4(34 DOWNTO 3),
								PC_plus4_pipe4, PipeReg4(103 DOWNTO 72), PipeReg4(2 DOWNTO 1), WriteData_reg);
								
	-- Outputs declaration
	-- to Instruction memory
	ProgramCounter <= ProgramCounter_buff;
	-- to Data memory
	Address <= PipeReg3(70 DOWNTO 39);
	WriteData <= PipeReg3(102 DOWNTO 71);
	MemRead <= PipeReg3(4);
	MemWrite <= PipeReg3(5);
	
END rtl;