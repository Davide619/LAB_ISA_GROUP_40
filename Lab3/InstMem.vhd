LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Instruction memory 32x32 bit

ENTITY InstMem IS
	PORT(
		  WR, RD, Clock : IN STD_LOGIC;
		  Address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  WriteData     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  
		  ReadData      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END InstMem;

ARCHITECTURE behaviour OF InstMem IS

	TYPE mem_def IS ARRAY(0 TO 4294967296) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL Mem : mem_def;

BEGIN
	
	mem: PROCESS(Clock)
	BEGIN
		IF (Clock'EVENT AND Clock = '1') THEN
		
			IF WR = '1' THEN
				Mem(TO_INTEGER(UNSIGNED(Address))) <= WriteData;
			ELSIF RD = '0' THEN
				ReadData <= Mem(TO_INTEGER(UNSIGNED(Address)));
			END IF;
		
		END IF;
	END PROCESS;
	
END behaviour;