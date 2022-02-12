LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- 32-bit register (positive edge triggered) used as Program Counter
ENTITY PC IS
	PORT (R            : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- input
			Clock, Reset : IN STD_LOGIC; -- clock, reset, load signals
			Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- output
END PC;

ARCHITECTURE Behavior OF PC IS

BEGIN

	PROCESS (Clock, Reset)
	BEGIN
		IF (Reset = '0') THEN -- asynchronous reset
			Q <= "00000000010000000000000000000000"; -- first instruction address
		ELSIF (Clock'EVENT AND Clock = '1') THEN -- positive edge detection
			Q <= R(31 DOWNTO 0);
		END IF;
	END PROCESS;
	
END Behavior;