LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux32to1_64b_ALU IS
	PORT(
		In_from_rs1 : IN SIGNED(63 DOWNTO 0);
		
		ctrl : IN SIGNED(4 DOWNTO 0);
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END Mux32to1_64b_ALU;

ARCHITECTURE mux OF Mux32to1_64b_ALU IS
BEGIN

Process (ctrl, In_from_rs1)
begin
	case ctrl is
		when "00000" => Out_mux <= In_from_rs1; 
		when "00001" =>
						Out_mux <= In_from_rs1(63) & In_from_rs1(63 DOWNTO 1);
						
		when "00010" => 
						Out_mux <= In_from_rs1(63) & In_from_rs1(63) & In_from_rs1(63 DOWNTO 2);
		when "00011" => 
						Out_mux <= In_from_rs1(63) & In_from_rs1(63) & In_from_rs1(63) & In_from_rs1(63 DOWNTO 3);
		when "00100" => 
						Out_mux(63 DOWNTO 60) <= (OTHERS => In_from_rs1(63));
						Out_mux(59 DOWNTO 0) <= In_from_rs1(63 DOWNTO 4);
		when "00101" => 
						Out_mux(63 DOWNTO 59) <= (OTHERS => In_from_rs1(63));
						Out_mux(58 DOWNTO 0) <= In_from_rs1(63 DOWNTO 5);
		when "00110" =>
						Out_mux(63 DOWNTO 58) <= (OTHERS => In_from_rs1(63));
						Out_mux(57 DOWNTO 0) <= In_from_rs1(63 DOWNTO 6);
		when "00111" =>
						Out_mux(63 DOWNTO 57) <= (OTHERS => In_from_rs1(63));
						Out_mux(56 DOWNTO 0) <= In_from_rs1(63 DOWNTO 7);
		when "01000" =>
						Out_mux(63 DOWNTO 56) <= (OTHERS => In_from_rs1(63));
						Out_mux(55 DOWNTO 0) <= In_from_rs1(63 DOWNTO 8);
		when "01001" =>
						Out_mux(63 DOWNTO 55) <= (OTHERS => In_from_rs1(63));
						Out_mux(54 DOWNTO 0) <= In_from_rs1(63 DOWNTO 9);
		when "01010" =>
						Out_mux(63 DOWNTO 54) <= (OTHERS => In_from_rs1(63));
						Out_mux(53 DOWNTO 0) <= In_from_rs1(63 DOWNTO 10);
		when "01011" =>
						Out_mux(63 DOWNTO 53) <= (OTHERS => In_from_rs1(63));
						Out_mux(52 DOWNTO 0) <= In_from_rs1(63 DOWNTO 11);
		when "01100" =>
						Out_mux(63 DOWNTO 52) <= (OTHERS => In_from_rs1(63));
						Out_mux(51 DOWNTO 0) <= In_from_rs1(63 DOWNTO 12);
		when "01101" =>
						Out_mux(63 DOWNTO 51) <= (OTHERS => In_from_rs1(63));
						Out_mux(50 DOWNTO 0) <= In_from_rs1(63 DOWNTO 13);
		when "01110" =>
						Out_mux(63 DOWNTO 50) <= (OTHERS => In_from_rs1(63));
						Out_mux(49 DOWNTO 0) <= In_from_rs1(63 DOWNTO 14);
		when "01111" =>
						Out_mux(63 DOWNTO 49) <= (OTHERS => In_from_rs1(63));
						Out_mux(48 DOWNTO 0) <= In_from_rs1(63 DOWNTO 15);
		when "10000" =>
						Out_mux(63 DOWNTO 48) <= (OTHERS => In_from_rs1(63));
						Out_mux(47 DOWNTO 0) <= In_from_rs1(63 DOWNTO 16);
		when "10001" =>
						Out_mux(63 DOWNTO 47) <= (OTHERS => In_from_rs1(63));
						Out_mux(46 DOWNTO 0) <= In_from_rs1(63 DOWNTO 17);
		when "10010" =>
						Out_mux(63 DOWNTO 46) <= (OTHERS => In_from_rs1(63));
						Out_mux(45 DOWNTO 0) <= In_from_rs1(63 DOWNTO 18);
		when "10011" =>
						Out_mux(63 DOWNTO 45) <= (OTHERS => In_from_rs1(63));
						Out_mux(44 DOWNTO 0) <= In_from_rs1(63 DOWNTO 19);
		when "10100" =>
						Out_mux(63 DOWNTO 44) <= (OTHERS => In_from_rs1(63));
						Out_mux(43 DOWNTO 0) <= In_from_rs1(63 DOWNTO 20);
		when "10101" =>
						Out_mux(63 DOWNTO 43) <= (OTHERS => In_from_rs1(63));
						Out_mux(42 DOWNTO 0) <= In_from_rs1(63 DOWNTO 21);
		when "10110" =>
						Out_mux(63 DOWNTO 42) <= (OTHERS => In_from_rs1(63));
						Out_mux(41 DOWNTO 0) <= In_from_rs1(63 DOWNTO 22);
		when "10111" =>
						Out_mux(63 DOWNTO 41) <= (OTHERS => In_from_rs1(63));
						Out_mux(40 DOWNTO 0) <= In_from_rs1(63 DOWNTO 23);
		when "11000" =>
						Out_mux(63 DOWNTO 40) <= (OTHERS => In_from_rs1(63));
						Out_mux(39 DOWNTO 0) <= In_from_rs1(63 DOWNTO 24);
		when "11001" =>
						Out_mux(63 DOWNTO 39) <= (OTHERS => In_from_rs1(63));
						Out_mux(38 DOWNTO 0) <= In_from_rs1(63 DOWNTO 25);
		when "11010" =>
						Out_mux(63 DOWNTO 38) <= (OTHERS => In_from_rs1(63));
						Out_mux(37 DOWNTO 0) <= In_from_rs1(63 DOWNTO 26);
		when "11011" =>
						Out_mux(63 DOWNTO 37) <= (OTHERS => In_from_rs1(63));
						Out_mux(36 DOWNTO 0) <= In_from_rs1(63 DOWNTO 27);
		when "11100" =>
						Out_mux(63 DOWNTO 36) <= (OTHERS => In_from_rs1(63));
						Out_mux(35 DOWNTO 0) <= In_from_rs1(63 DOWNTO 28);
		when "11101" =>
						Out_mux(63 DOWNTO 35) <= (OTHERS => In_from_rs1(63));
						Out_mux(34 DOWNTO 0) <= In_from_rs1(63 DOWNTO 29);
		when "11110" =>
						Out_mux(63 DOWNTO 34) <= (OTHERS => In_from_rs1(63));
						Out_mux(33 DOWNTO 0) <= In_from_rs1(63 DOWNTO 30);
		when "11111" =>
						Out_mux(63 DOWNTO 33) <= (OTHERS => In_from_rs1(63));
						Out_mux(32 DOWNTO 0) <= In_from_rs1(63 DOWNTO 31);
		when OTHERS => Out_mux <= (OTHERS => '0');
	end case;
	
end process;


END ARCHITECTURE;