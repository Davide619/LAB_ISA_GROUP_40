LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux4to1_32b IS
	PORT(
		In00 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In01 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In10 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		In11 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);

END Mux4to1_32b;

ARCHITECTURE mux OF Mux4to1_32b IS
BEGIN

Process (ctrl, In00, In01, In10, In11)
begin
	
	case ctrl is
		when "00" => Out_mux <= In00; 
		when "01" => Out_mux <= In01;
		when "10" => Out_mux <= In10;
		when "11" => Out_mux <= In11;
		when OTHERS => Out_mux <= In00;
	end case;
	
end process;
END mux;