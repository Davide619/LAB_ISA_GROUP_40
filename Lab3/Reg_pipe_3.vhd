LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Reg_pipe_3 IS
	PORT(
		In_reg : IN SIGNED(137 DOWNTO 0);
		
		clk : IN STD_LOGIC;
		load : IN STD_LOGIC;
		
		Out_reg : OUT SIGNED(137 DOWNTO 0)
		);

END Reg_pipe_3;

ARCHITECTURE reg OF Reg_pipe_3 IS
BEGIN

Process (clk)
begin
	if (clk'event AND clk = '1') then
		if load = '1' then
			Out_reg <= In_reg;
		end if;
	end if;
end process;


END ARCHITECTURE;