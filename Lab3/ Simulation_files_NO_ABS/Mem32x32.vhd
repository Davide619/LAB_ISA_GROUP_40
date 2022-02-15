LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

ENTITY Mem32x32 IS
	PORT(
		  WR, RD        : IN STD_LOGIC;
		  CLK           : IN STD_LOGIC;
		  Address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  WriteData     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  
		  ReadData      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END Mem32x32;

ARCHITECTURE behaviour OF Mem32x32 IS

	TYPE mem_def IS ARRAY(268500992 TO 268501039) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem : mem_def := (  "00000000", "00000000", "00000000", "00001010", -- address: 10010000
										"11111111", "11111111", "11111111", "11010001",
										"00000000", "00000000", "00000000", "00010110",
										"11111111", "11111111", "11111111", "11111101",
										"00000000", "00000000", "00000000", "00001111",
										"00000000", "00000000", "00000000", "00011011",
										"11111111", "11111111", "11111111", "11111100",
										"00000000", "00000000", "00000000", "00000000", -- added
										"00000000", "00000000", "00000000", "00000000",
										"00000000", "00000000", "00000000", "00000000",
										"00000000", "00000000", "00000000", "00000000",
										"00000000", "00000000", "00000000", "00000000");
	--CONSTANT Tc : TIME := 10 ns;

BEGIN
	-- READ/WRITE PROCESS
	memory: PROCESS (CLK)
		VARIABLE int_address : INTEGER := 0;
	BEGIN
		IF (CLK'EVENT AND CLK = '0') THEN
			int_address := TO_INTEGER(UNSIGNED(Address));
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

--	-- INITIALIZATION PROCESS
--	init: PROCESS
--		-- File pointer:
--		FILE fp : TEXT OPEN READ_MODE is "../data_memory_init.hex";
--		-- Read hexadecimal value:
--    	VARIABLE line_in      : LINE;
--		-- Integer address:
--		VARIABLE Address_data : INTEGER RANGE 268500991 TO 268500999 := 268500991;
--		-- Data that has to be written:
--		VARIABLE Data_file    : STD_LOGIC_VECTOR(31 DOWNTO 0);
--	BEGIN
--		IF NOT ENDFILE(fp) THEN
--			Address_data := Address_data + 1;
--			-- Read data from file:
--			READLINE(fp, line_in);
--			hread(line_in, Data_file);
--
--			-- Write operation:
--			Mem(Address_data) <= Data_file(31 DOWNTO 24);
--			Address_data := Address_data + 1;
--			Mem(Address_data) <= Data_file(23 DOWNTO 16);
--			Address_data := Address_data + 1;
--			Mem(Address_data) <= Data_file(15 DOWNTO 8);
--			Address_data := Address_data + 1;
--			Mem(Address_data) <= Data_file(7 DOWNTO 0);
--		END IF;
--	WAIT FOR Tc/100;
--	END PROCESS;
	
END behaviour;
