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
			Data        : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			
			-- to Instruction memory
			ProgramCounter : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- to Data memory
			Address        : BUFFER STD_LOGIC_VECTOR(63 DOWNTO 0);
			WriteData      : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
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

	-- immediate value Generator
	COMPONENT ImmGen IS
		PORT(
			inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			imm  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
	END COMPONENT;
	
	-- N-bit register (positive edge triggered)
	COMPONENT Regn IS
		GENERIC ( N : integer:=16);
		PORT (R         : IN UNSIGNED(N-1 DOWNTO 0); -- input
			Clock, Reset : IN STD_LOGIC; -- clock, reset, load signals
			Q            : OUT UNSIGNED(22 DOWNTO 0)); -- output
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
													
	-- ALU Control Unit
	
END rtl;