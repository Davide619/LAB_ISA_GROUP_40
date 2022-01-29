LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux6to1_64b_ALU IS
	PORT(
		In1 : IN SIGNED(63 DOWNTO 0);
		In2 : IN SIGNED(63 DOWNTO 0);
		In3 : IN SIGNED(63 DOWNTO 0);
		In5 : IN SIGNED(63 DOWNTO 0);
		In6 : IN SIGNED(63 DOWNTO 0);
		
		ctrl : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END Mux6to1_64b_ALU;

ARCHITECTURE mux OF Mux6to1_64b_ALU IS
BEGIN

Process (ctrl, In1, In2, In3, In5, In6)
begin
	case ctrl is
		when "000" => Out_mux <= In1; 
		when "001" => Out_mux <= In2;
		when "010" => Out_mux <= In3;
		when "100" => Out_mux <= In5;
		when "110" => Out_mux <= In6;
		when OTHERS => Out_mux <= (OTHERS => '0');
	end case;
	
end process;


END ARCHITECTURE;