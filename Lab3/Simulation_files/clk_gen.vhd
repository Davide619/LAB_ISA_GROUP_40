library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    CLK     : buffer std_logic);
end clk_gen;

architecture beh of clk_gen is

  constant Ts : time := 10 ns;
  
  
begin  -- beh

  process
  begin  -- process
    if (CLK = 'U') then
      CLK <= '0';
    else
      CLK <= not(CLK);
    end if;
    wait for Ts/2;
  end process;

end beh;
