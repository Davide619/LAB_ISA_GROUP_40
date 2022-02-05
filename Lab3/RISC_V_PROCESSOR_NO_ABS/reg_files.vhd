LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.NUMERIC_STD.ALL ;

ENTITY reg_files IS

  PORT (
           
           REG_WR           : IN STD_LOGIC;                         -----regwrite 
           REG1             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 1
           REG2             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 2
           WR_REG           : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----write register 
           INP              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);     -----write data
           OUT1             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);    -----read  data
           OUT2             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);    -----read  data
           CLK, RST         : IN std_logic);

END reg_files;


ARCHITECTURE beh OF reg_files IS

    TYPE REG_ARRAY IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL REG : REG_ARRAY;

BEGIN

    REGFILE: PROCESS(CLK, RST)
    BEGIN
		IF (RST = '0') THEN
			FOR i IN 0 TO 31 LOOP
				REG(i) <= (OTHERS => '0');
			END LOOP;
      ELSIF (CLK'EVENT AND CLK = '1') THEN
			-----READ PART
         OUT1 <= REG(TO_INTEGER(UNSIGNED(REG1)));
         OUT2 <= REG(TO_INTEGER(UNSIGNED(REG2)));
			
			----WRITE PART
			IF (REG_WR = '1') THEN
				REG(TO_INTEGER(UNSIGNED(WR_REG))) <= INP;
			END IF;
      END IF;
   END PROCESS;
   
END beh;