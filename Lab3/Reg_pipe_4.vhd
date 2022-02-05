LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Reg_pipe_4 IS
	PORT(
		In_reg_pipe4 : IN STD_LOGIC_VECTOR(103 DOWNTO 0);
		
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		
		Out_reg_pipe4 : OUT STD_LOGIC_VECTOR(103 DOWNTO 0)
		);

END Reg_pipe_4;

ARCHITECTURE reg OF Reg_pipe_4 IS
BEGIN

Process (clk, rst)
begin
	if (rst = '0') then
		Out_reg_pipe4 <= (others => '0');
	elsif (clk'event AND clk = '1') then
		Out_reg_pipe4 <= In_reg_pipe4;
	end if;
end process;


END ARCHITECTURE;