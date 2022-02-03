LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ADDER IS
     
        GENERIC(N : integer:=64);
	PORT(
		A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		C : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);

END ADDER;


ARCHITECTURE BEH OF ADDER IS

BEGIN

C <= std_logic_vector(unsigned(A) + unsigned(B));


END ARCHITECTURE;
