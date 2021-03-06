LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE work.type_def.all; non ho questa libreria


ENTITY  Matrix_PP  IS
    PORT(
		  Clk : IN STD_LOGIC;
        IN_PPi    : IN UNSIGNED(22 DOWNTO 0); --Partial product I
		  S	: IN STD_LOGIC; --sign of PP
        Results_FA_HA_Stage1    : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); --store the results of FAs and HAs including their Cout
		  V0 : OUT STD_LOGIC_VECTOR(44 DOWNTO 0);
		  V1 : OUT STD_LOGIC_VECTOR(44 DOWNTO 0);
		  V2 : OUT STD_LOGIC_VECTOR(44 DOWNTO 0);
		  V3 : OUT STD_LOGIC_VECTOR(40 DOWNTO 0);
		  V4 : OUT STD_LOGIC_VECTOR(36 DOWNTO 0);
		  V5 : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
		  V6 : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
		  V7 : OUT STD_LOGIC_VECTOR(24 DOWNTO 0);
		  V8 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		  V9 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
		  V10 : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		  V11 : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		  V12 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		  V13 : OUT STD_LOGIC
    );
END Matrix_PP;

ARCHITECTURE  mat1 OF Matrix_PP IS

SIGNAL IN_tmp: STD_LOGIC_VECTOR (22 DOWNTO 0);
SIGNAL result_tmp: STD_LOGIC_VECTOR (5 DOWNTO 0);

--MATRIX declaration
type MATRIX is array (0 TO 13) of STD_LOGIC_VECTOR (47 DOWNTO 0); --number of rows/columns
SIGNAL MATRIX14X48: MATRIX := (OTHERS => (OTHERS => '0'));


COMPONENT HA  IS
    PORT(
        A    : IN STD_LOGIC;
        B    : IN STD_LOGIC;
        S    : OUT STD_LOGIC;
        Cout    : OUT STD_LOGIC

    );
END COMPONENT;

COMPONENT FA  IS

    PORT(
        A    : IN STD_LOGIC;
        B    : IN STD_LOGIC;
        Cin  : IN STD_LOGIC;
        S    : OUT STD_LOGIC;
        Cout    : OUT STD_LOGIC
         
    );
END COMPONENT;


BEGIN

IN_tmp <= STD_LOGIC_VECTOR(IN_PPi);

-----------------------------incolumn partial products------------------------------------------------------------
PROCESS (Clk)

variable flag : integer := 0;

	BEGIN

if ( CLK'event AND CLK = '1') then
	
	if( flag = 0) then --sono alla riga 0
		
		MATRIX14X48(0)(22 DOWNTO 0) <= IN_tmp;
		MATRIX14X48(1)(0) <= S;
		MATRIX14X48(0)(23) <= S;
		MATRIX14X48(0)(24) <= S;
		MATRIX14X48(0)(25) <= NOT(S);
		
		flag := 1;
			
	elsif ( flag = 1 ) then ---sono alla riga 1
			
		MATRIX14X48(1)(24 DOWNTO 2) <= IN_tmp;
		
		MATRIX14X48(2)(2) <= S;
		MATRIX14X48(1)(25) <= NOT(S);
		MATRIX14X48(0)(26) <= '1';
		 
		flag := 2;
		
		
	elsif (flag = 2) then ---sono alla riga 2
			
		MATRIX14X48(2)(25 DOWNTO 4) <= IN_tmp(21 DOWNTO 0);
		MATRIX14X48(1)(26) <= IN_tmp(22);
			
		MATRIX14X48(3)(4) <= S;
		MATRIX14X48(0)(27) <= NOT(S);
		MATRIX14X48(0)(28) <= '1';
		
		flag := 3;
			
	elsif (flag = 3) then ---sono alla riga 3
		
		MATRIX14X48(3)(25 DOWNTO 6) <= IN_tmp(19 DOWNTO 0);
		MATRIX14X48(2)(26) <= IN_tmp(20);
		MATRIX14X48(1)(27) <= IN_tmp(21);
		MATRIX14X48(1)(28) <= IN_tmp(20);
			
		MATRIX14X48(4)(6) <= S;
		MATRIX14X48(0)(29) <= NOT(S);
		MATRIX14X48(0)(30) <= '1';
		
		flag := 4;
		
	elsif (flag = 4) then ---sono alla riga 4
		
		MATRIX14X48(4)(25 DOWNTO 8) <= IN_tmp(17 DOWNTO 0);
		MATRIX14X48(3)(26) <= IN_tmp(18);
		MATRIX14X48(2)(27) <= IN_tmp(19);
		MATRIX14X48(2)(28) <= IN_tmp(20);
		MATRIX14X48(1)(29) <= IN_tmp(21);
		MATRIX14X48(1)(30) <= IN_tmp(22);
			
		MATRIX14X48(5)(8) <= S;
		MATRIX14X48(0)(31) <= NOT(S);
		MATRIX14X48(0)(32) <= '1';
		
		flag := 5;
		
	elsif (flag = 5) then ---sono alla riga 5
		
		MATRIX14X48(5)(25 DOWNTO 10) <= IN_tmp(15 DOWNTO 0);
		MATRIX14X48(4)(26) <= IN_tmp(16);
		MATRIX14X48(3)(27) <= IN_tmp(17);
		MATRIX14X48(3)(28) <= IN_tmp(18);
		MATRIX14X48(2)(29) <= IN_tmp(19);
		MATRIX14X48(2)(30) <= IN_tmp(20);
		MATRIX14X48(1)(31) <= IN_tmp(21);
		MATRIX14X48(1)(32) <= IN_tmp(22);
			
		MATRIX14X48(6)(10) <= S;
		MATRIX14X48(0)(33) <= NOT(S);
		MATRIX14X48(0)(34) <= '1';
		
		flag := 6;

	elsif (flag = 6) then ---sono alla riga 6
		
		MATRIX14X48(6)(25 DOWNTO 12) <= IN_tmp(13 DOWNTO 0);
		MATRIX14X48(5)(26) <= IN_tmp(14);
		MATRIX14X48(4)(27) <= IN_tmp(15);
		MATRIX14X48(4)(28) <= IN_tmp(16);
		MATRIX14X48(3)(29) <= IN_tmp(17);
		MATRIX14X48(3)(30) <= IN_tmp(18);
		MATRIX14X48(2)(31) <= IN_tmp(19);
		MATRIX14X48(2)(32) <= IN_tmp(20);
		MATRIX14X48(1)(33) <= IN_tmp(21);
		MATRIX14X48(1)(34) <= IN_tmp(22);
			
		MATRIX14X48(7)(12) <= S;
		MATRIX14X48(0)(35) <= NOT(S);
		MATRIX14X48(0)(36) <= '1';
		
		flag := 7;

	elsif (flag = 7) then ---sono alla riga 7
		
		MATRIX14X48(7)(25 DOWNTO 14) <= IN_tmp(11 DOWNTO 0);
		MATRIX14X48(6)(26) <= IN_tmp(12);
		MATRIX14X48(5)(27) <= IN_tmp(13);
		MATRIX14X48(5)(28) <= IN_tmp(14);
		MATRIX14X48(4)(29) <= IN_tmp(15);
		MATRIX14X48(4)(30) <= IN_tmp(16);
		MATRIX14X48(3)(31) <= IN_tmp(17);
		MATRIX14X48(3)(32) <= IN_tmp(18);
		MATRIX14X48(2)(33) <= IN_tmp(19);
		MATRIX14X48(2)(34) <= IN_tmp(20);
		MATRIX14X48(1)(35) <= IN_tmp(21);
		MATRIX14X48(1)(36) <= IN_tmp(22);
			
		MATRIX14X48(8)(14) <= S;
		MATRIX14X48(0)(37) <= NOT(S);
		MATRIX14X48(0)(38) <= '1';
		
		flag := 8;
		
	elsif (flag = 8) then ---sono alla riga 8
		
		MATRIX14X48(8)(25 DOWNTO 16) <= IN_tmp(9 DOWNTO 0);
		MATRIX14X48(7)(26) <= IN_tmp(10);
		MATRIX14X48(6)(27) <= IN_tmp(11);
		MATRIX14X48(6)(28) <= IN_tmp(12);
		MATRIX14X48(5)(29) <= IN_tmp(13);
		MATRIX14X48(5)(30) <= IN_tmp(14);
		MATRIX14X48(4)(31) <= IN_tmp(15);
		MATRIX14X48(4)(32) <= IN_tmp(16);
		MATRIX14X48(3)(33) <= IN_tmp(17);
		MATRIX14X48(3)(34) <= IN_tmp(18);
		MATRIX14X48(2)(35) <= IN_tmp(19);
		MATRIX14X48(2)(36) <= IN_tmp(20);
		MATRIX14X48(1)(37) <= IN_tmp(21);
		MATRIX14X48(1)(38) <= IN_tmp(22);
			
		MATRIX14X48(9)(16) <= S;
		MATRIX14X48(0)(39) <= NOT(S);
		MATRIX14X48(0)(40) <= '1';
		
		flag := 9;

	elsif (flag = 9) then ---sono alla riga 9
		
		MATRIX14X48(9)(25 DOWNTO 18) <= IN_tmp(7 DOWNTO 0);
		MATRIX14X48(8)(26) <= IN_tmp(8);
		MATRIX14X48(7)(27) <= IN_tmp(9);
		MATRIX14X48(7)(28) <= IN_tmp(10);
		MATRIX14X48(6)(29) <= IN_tmp(11);
		MATRIX14X48(6)(30) <= IN_tmp(12);
		MATRIX14X48(5)(31) <= IN_tmp(13);
		MATRIX14X48(5)(32) <= IN_tmp(14);
		MATRIX14X48(4)(33) <= IN_tmp(15);
		MATRIX14X48(4)(34) <= IN_tmp(16);
		MATRIX14X48(3)(35) <= IN_tmp(17);
		MATRIX14X48(3)(36) <= IN_tmp(18);
		MATRIX14X48(2)(37) <= IN_tmp(19);
		MATRIX14X48(2)(38) <= IN_tmp(20);
		MATRIX14X48(1)(39) <= IN_tmp(21);
		MATRIX14X48(1)(40) <= IN_tmp(22);
			
		MATRIX14X48(10)(18) <= S;
		MATRIX14X48(0)(41) <= NOT(S);
		MATRIX14X48(0)(42) <= '1';
		
		flag := 10;

	elsif (flag = 10) then ---sono alla riga 10
		
		MATRIX14X48(10)(25 DOWNTO 20) <= IN_tmp(5 DOWNTO 0);
		MATRIX14X48(9)(26) <= IN_tmp(6);
		MATRIX14X48(8)(27) <= IN_tmp(7);
		MATRIX14X48(8)(28) <= IN_tmp(8);
		MATRIX14X48(7)(29) <= IN_tmp(9);
		MATRIX14X48(7)(30) <= IN_tmp(10);
		MATRIX14X48(6)(31) <= IN_tmp(11);
		MATRIX14X48(6)(32) <= IN_tmp(12);
		MATRIX14X48(5)(33) <= IN_tmp(13);
		MATRIX14X48(5)(34) <= IN_tmp(14);
		MATRIX14X48(4)(35) <= IN_tmp(15);
		MATRIX14X48(4)(36) <= IN_tmp(16);
		MATRIX14X48(3)(37) <= IN_tmp(17);
		MATRIX14X48(3)(38) <= IN_tmp(18);
		MATRIX14X48(2)(39) <= IN_tmp(19);
		MATRIX14X48(2)(40) <= IN_tmp(20);
		MATRIX14X48(1)(41) <= IN_tmp(21);
		MATRIX14X48(1)(42) <= IN_tmp(22);
			
		MATRIX14X48(11)(20) <= S;
		MATRIX14X48(0)(43) <= NOT(S);
		MATRIX14X48(0)(44) <= '1';
		
		flag := 11;
		
	elsif (flag = 11) then ---sono alla riga 11
		
		MATRIX14X48(11)(25 DOWNTO 22) <= IN_tmp(3 DOWNTO 0);
		MATRIX14X48(10)(26) <= IN_tmp(4);
		MATRIX14X48(9)(27) <= IN_tmp(5);
		MATRIX14X48(9)(28) <= IN_tmp(6);
		MATRIX14X48(8)(29) <= IN_tmp(7);
		MATRIX14X48(8)(30) <= IN_tmp(8);
		MATRIX14X48(7)(31) <= IN_tmp(9);
		MATRIX14X48(7)(32) <= IN_tmp(10);
		MATRIX14X48(6)(33) <= IN_tmp(11);
		MATRIX14X48(6)(34) <= IN_tmp(12);
		MATRIX14X48(5)(35) <= IN_tmp(13);
		MATRIX14X48(5)(36) <= IN_tmp(14);
		MATRIX14X48(4)(37) <= IN_tmp(15);
		MATRIX14X48(4)(38) <= IN_tmp(16);
		MATRIX14X48(3)(39) <= IN_tmp(17);
		MATRIX14X48(3)(40) <= IN_tmp(18);
		MATRIX14X48(2)(41) <= IN_tmp(19);
		MATRIX14X48(2)(42) <= IN_tmp(20);
		MATRIX14X48(1)(43) <= IN_tmp(21);
		MATRIX14X48(1)(44) <= IN_tmp(22);
		
		MATRIX14X48(12)(22) <= S;	
		MATRIX14X48(0)(45) <= NOT(S);
		MATRIX14X48(0)(46) <= '1';
		
		flag := 12;

	elsif (flag = 12) then ---sono alla riga 12
		
		MATRIX14X48(12)(25 DOWNTO 24) <= IN_tmp(1 DOWNTO 0);
		MATRIX14X48(11)(26) <= IN_tmp(2);
		MATRIX14X48(10)(27) <= IN_tmp(3);
		MATRIX14X48(10)(28) <= IN_tmp(4);
		MATRIX14X48(9)(29) <= IN_tmp(5);
		MATRIX14X48(9)(30) <= IN_tmp(6);
		MATRIX14X48(8)(31) <= IN_tmp(7);
		MATRIX14X48(8)(32) <= IN_tmp(8);
		MATRIX14X48(7)(33) <= IN_tmp(9);
		MATRIX14X48(7)(34) <= IN_tmp(10);
		MATRIX14X48(6)(35) <= IN_tmp(11);
		MATRIX14X48(6)(36) <= IN_tmp(12);
		MATRIX14X48(5)(37) <= IN_tmp(13);
		MATRIX14X48(5)(38) <= IN_tmp(14);
		MATRIX14X48(4)(39) <= IN_tmp(15);
		MATRIX14X48(4)(40) <= IN_tmp(16);
		MATRIX14X48(3)(41) <= IN_tmp(17);
		MATRIX14X48(3)(42) <= IN_tmp(18);
		MATRIX14X48(2)(43) <= IN_tmp(19);
		MATRIX14X48(2)(44) <= IN_tmp(20);
		MATRIX14X48(1)(45) <= IN_tmp(21);
		MATRIX14X48(1)(46) <= IN_tmp(22);
		
		MATRIX14X48(13)(24) <= S;
		MATRIX14X48(0)(47) <= NOT(S);
		
		------------QUI AGGIUNGO MANUALMENTE L'ULTIMA LINEA DI ZERI  -- sono alla riga 13
		MATRIX14X48(12)(26) <= '0';
		MATRIX14X48(11)(27) <= '0';
		MATRIX14X48(11)(28) <= '0';
		MATRIX14X48(10)(29) <= '0';
		MATRIX14X48(10)(30) <= '0';
		MATRIX14X48(9)(31) <= '0';
		MATRIX14X48(9)(32) <= '0';
		MATRIX14X48(8)(33) <= '0';
		MATRIX14X48(8)(34) <= '0';
		MATRIX14X48(7)(35) <= '0';
		MATRIX14X48(7)(36) <= '0';
		MATRIX14X48(6)(37) <= '0';
		MATRIX14X48(6)(38) <= '0';
		MATRIX14X48(5)(39) <= '0';
		MATRIX14X48(5)(40) <= '0';
		MATRIX14X48(4)(41) <= '0';
		MATRIX14X48(4)(42) <= '0';
		MATRIX14X48(3)(43) <= '0';
		MATRIX14X48(3)(44) <= '0';
		MATRIX14X48(2)(45) <= '0';
		MATRIX14X48(2)(46) <= '0';
		MATRIX14X48(1)(47) <= '0';
		
		flag := 0;
	else
	
		flag := 0;
		
	end if;	

end if;
	
	--------------------------------------------------------------------------------------------------


END PROCESS;


--assignment out vectors
-------------------------------------------------------------------------------------------------------------------------

		  V0(23 DOWNTO 0) <= MATRIX14X48(0)(23 DOWNTO 0);
		  V0(44 DOWNTO 24) <= MATRIX14X48(0)(47 DOWNTO 27);
	
	
		  V1(23 DOWNTO 0) <= MATRIX14X48(1)(23 DOWNTO 0);
		  V1(44 DOWNTO 24) <= MATRIX14X48(1)(47 DOWNTO 27);
		  

		  V2(44 DOWNTO 0) <= MATRIX14X48(2)(46 DOWNTO 2);
	
	
	
		  V3(40 DOWNTO 0) <= MATRIX14X48(3)(44 DOWNTO 4);
	
	
	
		  V4(36 DOWNTO 0) <= MATRIX14X48(4)(42 DOWNTO 6);
	
	
	
		  V5(32 DOWNTO 0) <= MATRIX14X48(5)(40 DOWNTO 8);
	
	
	
		  V6(28 DOWNTO 0) <= MATRIX14X48(6)(38 DOWNTO 10);
	
	

	
		  V7(24 DOWNTO 0) <= MATRIX14X48(7)(36 DOWNTO 12);
	
	
	
		  V8(20 DOWNTO 0) <= MATRIX14X48(8)(34 DOWNTO 14);
	
	
	
	
		  V9(16 DOWNTO 0) <= MATRIX14X48(9)(32 DOWNTO 16);

	

		  V10(12 DOWNTO 0) <= MATRIX14X48(10)(30 DOWNTO 18);

	
		  V11(8 DOWNTO 0) <= MATRIX14X48(11)(28 DOWNTO 20);
	

		  V12(4 DOWNTO 0) <= MATRIX14X48(12)(26 DOWNTO 22);
	
	
		  V13 <= MATRIX14X48(13)(24);
	

-------------------------------------------------------------------------------------------------------------------------	
-------------------------Assign HAs and FAs to the Pyramid---------------------------------------------------------------
	  
HA1 : HA PORT MAP (A => MATRIX14X48(0)(24),B => MATRIX14X48(1)(24),S => result_tmp(0),Cout => result_tmp(1));
HA2 : HA PORT MAP (A => MATRIX14X48(0)(25),B => MATRIX14X48(1)(25),S => result_tmp(2),Cout => result_tmp(3));
HA3 : HA PORT MAP (A => MATRIX14X48(0)(26),B => MATRIX14X48(1)(26),S => result_tmp(4) ,Cout => result_tmp(5));
-------------------------------------------------------------------------------------------------------------------------
--output
Results_FA_HA_Stage1 <= result_tmp;	



END ARCHITECTURE;