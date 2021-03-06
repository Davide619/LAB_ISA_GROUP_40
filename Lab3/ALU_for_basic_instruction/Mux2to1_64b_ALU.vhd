LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux2to1_64b_ALU IS
	PORT(
		In1 : IN SIGNED(63 DOWNTO 0);
		In2 : IN SIGNED(63 DOWNTO 0);
		
		Ctrl : IN STD_LOGIC;
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END Mux2to1_64b_ALU;

ARCHITECTURE mux OF Mux2to1_64b_ALU IS
BEGIN
process(Ctrl, In1, In2)
begin
	if(Ctrl = '1') then
		Out_mux <= In1;
	else
		Out_mux <= In2;
	end if;
end process;


END ARCHITECTURE;