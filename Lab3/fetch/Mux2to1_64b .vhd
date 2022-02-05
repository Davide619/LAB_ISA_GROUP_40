LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux2to1_32b IS
	PORT(
		In1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		Ctrl : IN STD_LOGIC;
		
		Out_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);

END Mux2to1_64b;

ARCHITECTURE mux OF Mux2to1_64b IS
BEGIN
process(Ctrl)
begin
	if(Ctrl = '1') then
		Out_mux <= In2;
	else
		Out_mux <= In1;
	end if;
end process;


END ARCHITECTURE;

