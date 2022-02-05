LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.NUMERIC_STD.ALL ;

ENTITY fetch IS
     
GENERIC(N : integer:=64);
PORT (     -- clock, reset and Program Counter input selector
	   CLK, RESET, PC_Src    : IN  STD_LOGIC;
      	   -- jump address
    	   JMP_ADD               : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      
	   -- Program Counter input
      	   PC_IN   : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0);	
	   -- Instruction Memory address (PC output)
	   INS_ADD : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));	 
	   
END fetch;


ARCHITECTURE BEH OF fetch IS

	
	
	
SIGNAL  ADDER_OUT,PC_OUT, ADDER_INP2 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

COMPONENT ADDER IS
GENERIC(N : integer:=64);
PORT(
       A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
       C : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END COMPONENT;


COMPONENT Mux2to1_32b IS
PORT(
	In1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	In2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
	Ctrl : IN STD_LOGIC;
		
	Out_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);

END  COMPONENT;

     
COMPONENT Regn IS

GENERIC ( N            : integer:=64);
PORT    ( R            : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0); -- input
	  Clock, Reset : IN STD_LOGIC; -- clock, reset, load signals
	  Q            : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)); -- output
END COMPONENT;  


BEGIN

ADDER_INP2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(4,N));

---MAP
---INSIDE ADDER
ADDER_INSIDE:    ADDER GENERIC MAP(N => 32) PORT MAP(PC_OUT, ADDER_INP2, ADDER_OUT);

---INSIDE MUX(32BIT)
MUX  :    Mux2to1_32b   PORT MAP(ADDER_OUT, JMP_ADD, PC_Src, PC_IN); 
	
---INSIDE PROGRAM COUNTER
PC   :    Regn  GENERIC MAP(N => 32) PORT MAP(PC_IN, CLK, RESET, PC_OUT);       


INS_ADD <= PC_OUT;

END BEH;  