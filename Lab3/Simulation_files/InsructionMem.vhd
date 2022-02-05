LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- 32x32 bit memory

ENTITY InstructionMem IS
	PORT(
		  Clock : IN STD_LOGIC;
		  Address_from_PC       : IN UNSIGNED(31 DOWNTO 0);
		  WR 		: IN STD_LOGIC;
		  Instr_from_file      : IN UNSIGNED(31 DOWNTO 0);
		  
		  Instruction      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END InstructionMem

ARCHITECTURE behaviour OF InstructionMem IS

	TYPE mem_def IS ARRAY(0 TO 4294967296) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Mem : mem_def;

BEGIN
	
	mem: PROCESS(Clock)
	BEGIN
		IF (Clock'EVENT AND Clock = '1') THEN
		
			IF WR = '1' THEN
				Mem(TO_INTEGER(UNSIGNED(Address))) <= Instr_from_file;
			ELSIF RD = '0' THEN
				Instruction <= Mem(TO_INTEGER(UNSIGNED(Address)));
			END IF;
		
		END IF;
	END PROCESS;
	
END behaviour;
