LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.NUMERIC_STD.ALL ;

ENTITY fetch IS
     
     GENERIC(N : integer:=64);
     PORT (     CLK, RESET, PC_Src    : IN  STD_LOGIC;
		MEM_OUT	              : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);			        
		INS_ADD	              : OUT std_logic_vector(N-1 DOWNTO 0));	 
	   
END fetch;


ARCHITECTURE BEH OF fetch IS

	
	
	
     SIGNAL  PC_IN, ADDER_OUT,PC_OUT, ADDER_INP2 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
     COMPONENT ADDER IS
     GENERIC(N : integer:=64);
     PORT(
		A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		C : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	      );
     END COMPONENT;


     COMPONENT Mux2to1_64b IS
     PORT(
		In1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		In2 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		
		Ctrl : IN STD_LOGIC;
		
		Out_mux : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
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
ADDER_INSIDE:    ADDER GENERIC MAP(N => 64) PORT MAP(PC_OUT, ADDER_INP2, ADDER_OUT);
MUX  :    Mux2to1_64b   PORT MAP(ADDER_OUT, MEM_OUT, PC_Src, PC_IN); 
PC   :    Regn  GENERIC MAP(N => 64) PORT MAP(PC_IN, CLK, RESET, PC_OUT);       

INS_ADD <= PC_OUT;

END BEH;   
