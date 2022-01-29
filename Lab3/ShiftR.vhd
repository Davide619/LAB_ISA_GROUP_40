LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ShiftR IS
	PORT(
		In_from_immGen : IN UNSIGNED(63 DOWNTO 0);
		
		Out_ShiftR : OUT UNSIGNED(31 DOWNTO 0)
		);

END ShiftR;

ARCHITECTURE shift OF ShiftR IS

BEGIN
	Out_shiftR <= In_from_immGen(30 DOWNTO 0) & '0';

END ARCHITECTURE;
