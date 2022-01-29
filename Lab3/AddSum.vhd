LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY AddSum IS
	PORT(
		In_from_PC : IN UNSIGNED(31 DOWNTO 0);
		In_from_ShiftR : IN UNSIGNED(31 DOWNTO 0);
		
		Out_AddSum : OUT UNSIGNED(31 DOWNTO 0)
		);

END AddSum;

ARCHITECTURE Add OF AddSum IS
BEGIN

Out_AddSum <= In_from_PC + In_from_ShiftR;


END ARCHITECTURE;
