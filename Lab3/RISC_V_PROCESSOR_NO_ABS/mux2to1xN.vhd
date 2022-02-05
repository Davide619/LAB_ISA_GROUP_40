LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 2xN bit multiplexer

ENTITY mux2to1xN IS
	GENERIC (N : INTEGER := 32);
	PORT(
			IN0 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			IN1 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			s : IN STD_LOGIC; -- control signal
			
			M : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END mux2to1xN;

ARCHITECTURE behaviour OF mux2to1xN IS

BEGIN
	
	mux: PROCESS(IN0, IN1, s)
	BEGIN
		CASE s IS
			WHEN '0' => M <= IN0;
			WHEN '1' => M <= IN1;
		END CASE;
	END PROCESS;
	
END behaviour;