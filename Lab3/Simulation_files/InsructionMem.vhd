LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

ENTITY InstructionMem IS
	PORT(CLK : IN STD_LOGIC;
		  Address_from_PC       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
		  Instruction      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END InstructionMem;

ARCHITECTURE behaviour OF InstructionMem IS

	TYPE mem_def IS ARRAY(4194304 TO 4194499) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem : mem_def;
	CONSTANT Tc : TIME := 10 ns;

BEGIN

	-- READ PROCESS
	memory: PROCESS (CLK)
		VARIABLE add_from_PC_int : INTEGER RANGE 4194304 TO 4194499 := 4194304;
	BEGIN
		IF (CLK'EVENT AND CLK = '0') THEN
			add_from_PC_int := TO_INTEGER(UNSIGNED(Address_from_PC));
			Instruction(31 DOWNTO 24) <= Mem(add_from_PC_int);
			add_from_PC_int := add_from_PC_int + 1;
			Instruction(23 DOWNTO 16) <= Mem(add_from_PC_int);
			add_from_PC_int := add_from_PC_int + 1;
			Instruction(15 DOWNTO 8) <= Mem(add_from_PC_int);
			add_from_PC_int := add_from_PC_int + 1;
			Instruction(7 DOWNTO 0) <= Mem(add_from_PC_int);
		END IF;
	END PROCESS;

	-- INITIALIZATION PROCESS
	-- The initialization of the memory terminates
	-- after (22/100)Tc seconds
	init: PROCESS
		FILE fp_in : TEXT OPEN READ_MODE is "../instruction_set.hex";
    	VARIABLE line_in : line;
		VARIABLE Address : INTEGER := 4194304; -- 4*16^5 (0x00400000)
		VARIABLE Instr_from_file : STD_LOGIC_VECTOR(31 DOWNTO 0);
	BEGIN
		IF NOT ENDFILE(fp_in) THEN
			readline(fp_in, line_in);
			hread(line_in, Instr_from_file);
			Mem(Address)   <= Instr_from_file(31 DOWNTO 24);
			Address := Address + 1;
			Mem(Address) <= Instr_from_file(23 DOWNTO 16);
			Address := Address + 1;
			Mem(Address) <= Instr_from_file(15 DOWNTO 8);
			Address := Address + 1;
			Mem(Address) <= Instr_from_file(7 DOWNTO 0);
			Address := Address + 1;
		END IF;
		WAIT FOR Tc/100;
	END PROCESS;
	
END behaviour;
