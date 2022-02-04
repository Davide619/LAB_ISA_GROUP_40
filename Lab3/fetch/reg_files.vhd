LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.NUMERIC_STD.ALL ;

ENTITY reg_files IS

  PORT (
           
           REG_WR           : IN STD_LOGIC;                         -----regwrite 
           REG1             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 1
           REG2             : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----read  register 2
           WR_REG           : IN STD_LOGIC_VECTOR(4 DOWNTO 0);      -----write register 
           DATA_IN          : IN STD_LOGIC_VECTOR(63 DOWNTO 0);     -----write data
           DATA_OUT1        : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);    -----read  data
           DATA_OUT2        : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);    -----read  data
           CLK, RST_n       : IN std_logic);

END reg_files;


ARCHITECTURE beh OF reg_files IS

    TYPE REG_ARRAY IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL REG : REG_ARRAY;

BEGIN

    REGFILE: PROCESS(CLK, RST_n)
    BEGIN 
       IF RISING_EDGE(CLK) THEN
       -----READ PART
         DATA_OUT1 <= REG(TO_INTEGER(UNSIGNED(REG1)));
         DATA_OUT2 <= REG(TO_INTEGER(UNSIGNED(REG2)));
       
       ----WRITE PART
         IF RST_n = '0' then
		REG(0 to 31) <= (others=>(others => '0'));
         ELSIF REG_WR = '1' THEN
                REG(TO_INTEGER(UNSIGNED(WR_REG))) <= DATA_IN;
         END IF;
       END IF;
   END PROCESS;
   
END beh;
  


  
    
       
