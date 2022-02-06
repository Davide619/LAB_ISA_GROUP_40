LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- 32x32 bit memory

ENTITY Mem32x32 IS
	PORT(
		  WR, RD, Clock : IN STD_LOGIC;
		  Address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  WriteData     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  
		  ReadData      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END Mem32x32;

ARCHITECTURE behaviour OF Mem32x32 IS

	TYPE mem_def IS ARRAY(4194304 TO 4194391) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem : mem_def;

BEGIN
	memory: PROCESS(Clock)
		VARIABLE int_address : INTEGER := 0;
	BEGIN
		int_address := TO_INTEGER(UNSIGNED(Address));
		IF (Clock'EVENT AND Clock = '1') THEN
			IF WR = '1' THEN
				Mem(int_address) <= WriteData(31 DOWNTO 24);
				int_address := int_address + 1;
				Mem(int_address) <= WriteData(23 DOWNTO 16);
				int_address := int_address + 1;
				Mem(int_address) <= WriteData(15 DOWNTO 8);
				int_address := int_address + 1;
				Mem(int_address) <= WriteData(7 DOWNTO 0);
			ELSIF RD = '1' THEN
				ReadData(31 DOWNTO 24) <= Mem(int_address);
				int_address := int_address + 1;
				ReadData(23 DOWNTO 16) <= Mem(int_address);
				int_address := int_address + 1;
				ReadData(15 DOWNTO 8) <= Mem(int_address);
				int_address := int_address + 1;
				ReadData(7 DOWNTO 0) <= Mem(int_address);
			END IF;
		
		END IF;
	END PROCESS;
	
END behaviour;
