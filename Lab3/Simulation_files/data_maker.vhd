library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    clk     : in  std_logic;
    DataIN_to_mem    : out unsigned(31 downto 0);
    End_file	: out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;


begin  -- beh


  process (clk)

    file fp_in : text open READ_MODE is "./instruction.hex";
    variable line_in : line;
    variable x : std_logic_vector(31 DOWNTO 0);

  begin  -- process
    if (clk'event and clk = '1') then  -- rising clock edge
		if not endfile(fp_in) then
				readline(fp_in, line_in);
				hread(line_in, x);
				DataIN_to_mem  <= unsigned(x) after tco;
		if endfile(fp_in) then
			END_file <= '1';
		else
			END_file <= '0';
			
      		end if;
    end if;
  end process; 

end beh;
