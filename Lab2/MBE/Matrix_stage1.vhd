LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY  Matrix_stage1  IS
    PORT(
   Results_from_Matrix_PP    : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	
	IN0_from_Matrix_PP	: IN STD_LOGIC_VECTOR(44 DOWNTO 0); 
	IN1_from_Matrix_PP	: IN STD_LOGIC_VECTOR(44 DOWNTO 0); 
	IN2_from_Matrix_PP	: IN STD_LOGIC_VECTOR(44 DOWNTO 0); 
	IN3_from_Matrix_PP	: IN STD_LOGIC_VECTOR(40 DOWNTO 0); 
	IN4_from_Matrix_PP	: IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
	IN5_from_Matrix_PP	: IN STD_LOGIC_VECTOR(32 DOWNTO 0); 
	IN6_from_Matrix_PP	: IN STD_LOGIC_VECTOR(28 DOWNTO 0); 
	IN7_from_Matrix_PP	: IN STD_LOGIC_VECTOR(24 DOWNTO 0); 
	IN8_from_Matrix_PP	: IN STD_LOGIC_VECTOR(20 DOWNTO 0); 
	IN9_from_Matrix_PP	: IN STD_LOGIC_VECTOR(16 DOWNTO 0); 
	IN10_from_Matrix_PP	: IN STD_LOGIC_VECTOR(12 DOWNTO 0); 
	IN11_from_Matrix_PP	: IN STD_LOGIC_VECTOR(8 DOWNTO 0); 
	IN12_from_Matrix_PP	: IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
	IN13_from_Matrix_PP	: IN STD_LOGIC; 


---------Output vectors that contain remaining values

	V0 : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
	V1 : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
	V2 : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
	V3 : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);  
	V4 : OUT STD_LOGIC_VECTOR(21 DOWNTO 0);
	V5 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);			
	V6 : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
	V7 : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
	V8 : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
	V9 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);				
	V10 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	V11 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	V12 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);

   Results_FA_HA_Stage2    : OUT STD_LOGIC_VECTOR(105 DOWNTO 0)   
	
    );
END Matrix_stage1;

ARCHITECTURE  mat1 OF Matrix_stage1 IS

SIGNAL result_tmp: STD_LOGIC_VECTOR (105 DOWNTO 0); 


type MATRIX is array (0 TO 12) of STD_LOGIC_VECTOR (47 DOWNTO 0); --number of rows/columns
SIGNAL MATRIX13X48 : MATRIX := (OTHERS => (OTHERS => '0'));

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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------Assign FAs and HAs results including Cout----------------------------------------------------------
--1st-2d line assignment
MATRIX13X48(0)(24)  <= Results_from_Matrix_PP(0);
MATRIX13X48(0)(25)  <= IN0_from_Matrix_PP(2);
MATRIX13X48(0)(26)  <= IN0_from_Matrix_PP(4);
MATRIX13X48(1)(25)  <= IN0_from_Matrix_PP(1);
MATRIX13X48(1)(26)  <= IN0_from_Matrix_PP(3);
MATRIX13X48(1)(27)  <= IN0_from_Matrix_PP(5);

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------Assign internal part----------------------------------------------------------------------

--colonna 24
MATRIX13X48(1)(24)  <= IN2_from_Matrix_PP(22);
MATRIX13X48(2)(24)  <= IN3_from_Matrix_PP(20);
MATRIX13X48(3)(24)  <= IN4_from_Matrix_PP(18);
MATRIX13X48(4)(24)  <= IN5_from_Matrix_PP(16);
MATRIX13X48(5)(24)  <= IN6_from_Matrix_PP(14);
MATRIX13X48(6)(24)  <= IN7_from_Matrix_PP(12);
MATRIX13X48(7)(24)  <= IN8_from_Matrix_PP(10);
MATRIX13X48(8)(24)  <= IN9_from_Matrix_PP(8);
MATRIX13X48(9)(24)  <= IN10_from_Matrix_PP(6);
MATRIX13X48(10)(24)  <= IN11_from_Matrix_PP(4);
MATRIX13X48(11)(24)  <= IN12_from_Matrix_PP(2);
MATRIX13X48(12)(24)  <= IN13_from_Matrix_PP;

---colonna 25
MATRIX13X48(2)(25)  <= IN2_from_Matrix_PP(23);
MATRIX13X48(3)(25)  <= IN3_from_Matrix_PP(21);                   
MATRIX13X48(4)(25)  <= IN4_from_Matrix_PP(19);
MATRIX13X48(5)(25)  <= IN5_from_Matrix_PP(17);
MATRIX13X48(6)(25)  <= IN6_from_Matrix_PP(15);
MATRIX13X48(7)(25)  <= IN7_from_Matrix_PP(13);
MATRIX13X48(8)(25)  <= IN8_from_Matrix_PP(11);
MATRIX13X48(9)(25)  <= IN9_from_Matrix_PP(9);
MATRIX13X48(10)(25)  <= IN10_from_Matrix_PP(7);
MATRIX13X48(11)(25)  <= IN11_from_Matrix_PP(5);
MATRIX13X48(12)(25)  <= IN12_from_Matrix_PP(3);

--colonna 26
MATRIX13X48(2)(26)  <= IN2_from_Matrix_PP(24);                   
MATRIX13X48(3)(26)  <= IN3_from_Matrix_PP(22);
MATRIX13X48(4)(26)  <= IN4_from_Matrix_PP(20);
MATRIX13X48(5)(26)  <= IN5_from_Matrix_PP(18);
MATRIX13X48(6)(26)  <= IN6_from_Matrix_PP(16);
MATRIX13X48(7)(26)  <= IN7_from_Matrix_PP(14);
MATRIX13X48(8)(26)  <= IN8_from_Matrix_PP(12);
MATRIX13X48(9)(26)  <= IN9_from_Matrix_PP(10);
MATRIX13X48(10)(26)  <= IN10_from_Matrix_PP(8);
MATRIX13X48(11)(26)  <= IN11_from_Matrix_PP(6);
MATRIX13X48(12)(26)  <= IN12_from_Matrix_PP(4);


--colonna 27
MATRIX13X48(0)(27)  <= IN0_from_Matrix_PP(29);
MATRIX13X48(2)(27)  <= IN1_from_Matrix_PP(27);
MATRIX13X48(3)(27)  <= IN2_from_Matrix_PP(25);
MATRIX13X48(4)(27)  <= IN3_from_Matrix_PP(23);
MATRIX13X48(5)(27)  <= IN4_from_Matrix_PP(21);
MATRIX13X48(6)(27)  <= IN5_from_Matrix_PP(19);
MATRIX13X48(7)(27)  <= IN6_from_Matrix_PP(17);
MATRIX13X48(8)(27)  <= IN7_from_Matrix_PP(15);
MATRIX13X48(9)(27)  <= IN8_from_Matrix_PP(13);
MATRIX13X48(10)(27)  <= IN9_from_Matrix_PP(11);
MATRIX13X48(11)(27)  <= IN10_from_Matrix_PP(9);
MATRIX13X48(12)(27)  <= IN11_from_Matrix_PP(7);


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------Assign external part----------------------------------------------------------------------


	MATRIX13X48(0)(23 DOWNTO 0)  <= IN0_from_Matrix_PP(23 DOWNTO 0);
	MATRIX13X48(0)(47 DOWNTO 28)  <= IN0_from_Matrix_PP(44 DOWNTO 25);
-------------------------0-------------------------------

	MATRIX13X48(1)(23 DOWNTO 0)  <= IN1_from_Matrix_PP(23 DOWNTO 0); 
	MATRIX13X48(1)(47 DOWNTO 28)  <= IN1_from_Matrix_PP(44 DOWNTO 25);

---------------------------1-----------------------------

    MATRIX13X48(2)(23 DOWNTO 2) <= IN2_from_Matrix_PP(21 DOWNTO 0);
    MATRIX13X48(2)(46 DOWNTO 28) <= IN2_from_Matrix_PP(44 DOWNTO 26);

----------------------------2----------------------------

    MATRIX13X48(3)(23 DOWNTO 4) <= IN3_from_Matrix_PP(19 DOWNTO 0);
    MATRIX13X48(3)(44 DOWNTO 28) <= IN3_from_Matrix_PP(40 DOWNTO 24);

------------------------------3--------------------------

    MATRIX13X48(4)(23 DOWNTO 6) <= IN4_from_Matrix_PP(17 DOWNTO 0);
    MATRIX13X48(4)(42 DOWNTO 28) <= IN4_from_Matrix_PP(36 DOWNTO 22);

-------------------------------4-------------------------
   
    MATRIX13X48(5)(23 DOWNTO 8) <= IN5_from_Matrix_PP(15 DOWNTO 0);
    MATRIX13X48(5)(40 DOWNTO 28) <= IN5_from_Matrix_PP(32 DOWNTO 20);

-----------------------------5---------------------------

    MATRIX13X48(6)(23 DOWNTO 10) <= IN6_from_Matrix_PP(13 DOWNTO 0);
    MATRIX13X48(6)(38 DOWNTO 28) <= IN6_from_Matrix_PP(28 DOWNTO 18);

------------------------------6--------------------------

    MATRIX13X48(7)(23 DOWNTO 12) <= IN7_from_Matrix_PP(11 DOWNTO 0);
	 MATRIX13X48(7)(36 DOWNTO 28) <= IN7_from_Matrix_PP(24 DOWNTO 16);


------------------------------7--------------------------

	 MATRIX13X48(8)(23 DOWNTO 14) <= IN8_from_Matrix_PP(9 DOWNTO 0);
	 MATRIX13X48(8)(34 DOWNTO 28) <= IN8_from_Matrix_PP(20 DOWNTO 14);

------------------------------8--------------------------

	 MATRIX13X48(9)(23 DOWNTO 16) <= IN9_from_Matrix_PP(7 DOWNTO 0);
	 MATRIX13X48(9)(32 DOWNTO 28) <= IN9_from_Matrix_PP(16 DOWNTO 12);
	 
-----------------------------9---------------------------

	 MATRIX13X48(10)(23 DOWNTO 18) <= IN10_from_Matrix_PP(5 DOWNTO 0);
	 MATRIX13X48(10)(30 DOWNTO 28) <= IN10_from_Matrix_PP(12 DOWNTO 10);
	 
-----------------------------10--------------------------

	 MATRIX13X48(11)(23 DOWNTO 20) <= IN11_from_Matrix_PP(3 DOWNTO 0);
	 MATRIX13X48(11)(28) <= IN11_from_Matrix_PP(8);
	 
-----------------------------11--------------------------

	 MATRIX13X48(12)(22) <= IN12_from_Matrix_PP(0);
	 
-----------------------------12--------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------Instance FAs HAs--------------------------------------------------------------------------
HA1 : HA PORT MAP (A => MATRIX13X48(0)(16),B => MATRIX13X48(1)(16),S => result_tmp(0),Cout => result_tmp(1));


HA2 : HA PORT MAP (A => MATRIX13X48(0)(17),B => MATRIX13X48(1)(17),S => result_tmp(2),Cout => result_tmp(3));


FA1 : FA PORT MAP (A => MATRIX13X48(0)(18),B => MATRIX13X48(1)(18),Cin => MATRIX13X48(2)(18),S => result_tmp(4),Cout => result_tmp(5));
HA3 : HA PORT MAP (A => MATRIX13X48(3)(18),B => MATRIX13X48(4)(18),S => result_tmp(6),Cout => result_tmp(7));


FA2 : FA PORT MAP (A => MATRIX13X48(0)(19),B => MATRIX13X48(1)(19),Cin => MATRIX13X48(2)(19),S => result_tmp(8),Cout => result_tmp(9));
HA4 : HA PORT MAP (A => MATRIX13X48(3)(19),B => MATRIX13X48(4)(19),S => result_tmp(19),Cout => result_tmp(11));


FA3 : FA PORT MAP (A => MATRIX13X48(0)(20),B => MATRIX13X48(1)(20),Cin => MATRIX13X48(2)(20),S => result_tmp(12),Cout => result_tmp(13));
FA4 : FA PORT MAP (A => MATRIX13X48(3)(20),B => MATRIX13X48(4)(20),Cin => MATRIX13X48(5)(20),S => result_tmp(14),Cout => result_tmp(15));
HA5 : HA PORT MAP (A => MATRIX13X48(6)(20),B => MATRIX13X48(7)(20),S => result_tmp(16),Cout => result_tmp(17));


FA5 : FA PORT MAP (A => MATRIX13X48(0)(21),B => MATRIX13X48(1)(21),Cin => MATRIX13X48(2)(21),S => result_tmp(18),Cout => result_tmp(19));
FA6 : FA PORT MAP (A => MATRIX13X48(3)(21),B => MATRIX13X48(4)(21),Cin => MATRIX13X48(5)(21),S => result_tmp(20),Cout => result_tmp(21));
HA6 : HA PORT MAP (A => MATRIX13X48(6)(21),B => MATRIX13X48(7)(21),S => result_tmp(22),Cout => result_tmp(23));


FA7 : FA PORT MAP (A => MATRIX13X48(0)(22),B => MATRIX13X48(1)(22),Cin => MATRIX13X48(2)(22),S => result_tmp(24),Cout => result_tmp(25));
FA8 : FA PORT MAP (A => MATRIX13X48(3)(22),B => MATRIX13X48(4)(22),Cin => MATRIX13X48(5)(22),S => result_tmp(26),Cout => result_tmp(27));
FA9 : FA PORT MAP (A => MATRIX13X48(6)(22),B => MATRIX13X48(7)(22),Cin => MATRIX13X48(8)(22),S => result_tmp(28),Cout => result_tmp(29));
HA7 : HA PORT MAP (A => MATRIX13X48(9)(22),B => MATRIX13X48(10)(22),S => result_tmp(30),Cout => result_tmp(31));


FA10 : FA PORT MAP (A => MATRIX13X48(0)(23),B => MATRIX13X48(1)(23),Cin => MATRIX13X48(2)(23),S => result_tmp(32),Cout => result_tmp(33));
FA11 : FA PORT MAP (A => MATRIX13X48(3)(23),B => MATRIX13X48(4)(23),Cin => MATRIX13X48(5)(23),S => result_tmp(34),Cout => result_tmp(35));
FA12 : FA PORT MAP (A => MATRIX13X48(6)(23),B => MATRIX13X48(7)(23),Cin => MATRIX13X48(8)(23),S => result_tmp(36),Cout => result_tmp(37));
HA8 : HA PORT MAP (A => MATRIX13X48(9)(23),B => MATRIX13X48(10)(23),S => result_tmp(38),Cout => result_tmp(39));


FA13 : FA PORT MAP (A => MATRIX13X48(0)(24),B => MATRIX13X48(1)(24),Cin => MATRIX13X48(2)(24),S => result_tmp(40),Cout => result_tmp(41));
FA14 : FA PORT MAP (A => MATRIX13X48(3)(24),B => MATRIX13X48(4)(24),Cin => MATRIX13X48(5)(24),S => result_tmp(42),Cout => result_tmp(43));
FA15 : FA PORT MAP (A => MATRIX13X48(6)(24),B => MATRIX13X48(7)(24),Cin => MATRIX13X48(8)(24),S => result_tmp(44),Cout => result_tmp(45));
FA16 : FA PORT MAP (A => MATRIX13X48(9)(24),B => MATRIX13X48(10)(24),Cin => MATRIX13X48(11)(24),S => result_tmp(46),Cout => result_tmp(47));


FA17 : FA PORT MAP (A => MATRIX13X48(0)(25),B => MATRIX13X48(1)(25),Cin => MATRIX13X48(2)(25),S => result_tmp(48),Cout => result_tmp(49));
FA18 : FA PORT MAP (A => MATRIX13X48(3)(25),B => MATRIX13X48(4)(25),Cin => MATRIX13X48(5)(25),S => result_tmp(50),Cout => result_tmp(51));
FA19 : FA PORT MAP (A => MATRIX13X48(6)(25),B => MATRIX13X48(7)(25),Cin => MATRIX13X48(8)(25),S => result_tmp(52),Cout => result_tmp(53));
FA20 : FA PORT MAP (A => MATRIX13X48(9)(25),B => MATRIX13X48(10)(25),Cin => MATRIX13X48(11)(25),S => result_tmp(54),Cout => result_tmp(55));


FA21 : FA PORT MAP (A => MATRIX13X48(0)(26),B => MATRIX13X48(1)(26),Cin => MATRIX13X48(2)(26),S => result_tmp(56),Cout => result_tmp(57));
FA22 : FA PORT MAP (A => MATRIX13X48(3)(26),B => MATRIX13X48(4)(26),Cin => MATRIX13X48(5)(26),S => result_tmp(58),Cout => result_tmp(59));
FA23 : FA PORT MAP (A => MATRIX13X48(6)(26),B => MATRIX13X48(7)(26),Cin => MATRIX13X48(8)(26),S => result_tmp(62),Cout => result_tmp(63));
FA24 : FA PORT MAP (A => MATRIX13X48(9)(26),B => MATRIX13X48(10)(26),Cin => MATRIX13X48(11)(26),S => result_tmp(64),Cout => result_tmp(65));


FA25 : FA PORT MAP (A => MATRIX13X48(0)(27),B => MATRIX13X48(1)(27),Cin => MATRIX13X48(2)(27),S => result_tmp(66),Cout => result_tmp(67));
FA26 : FA PORT MAP (A => MATRIX13X48(3)(27),B => MATRIX13X48(4)(27),Cin => MATRIX13X48(5)(27),S => result_tmp(68),Cout => result_tmp(69));
FA27 : FA PORT MAP (A => MATRIX13X48(6)(27),B => MATRIX13X48(7)(27),Cin => MATRIX13X48(8)(27),S => result_tmp(70),Cout => result_tmp(71));
FA28 : FA PORT MAP (A => MATRIX13X48(9)(27),B => MATRIX13X48(10)(27),Cin => MATRIX13X48(11)(27),S => result_tmp(72),Cout => result_tmp(73));


FA29 : FA PORT MAP (A => MATRIX13X48(0)(28),B => MATRIX13X48(1)(28),Cin => MATRIX13X48(2)(28),S => result_tmp(74),Cout => result_tmp(75));
FA30 : FA PORT MAP (A => MATRIX13X48(3)(28),B => MATRIX13X48(4)(28),Cin => MATRIX13X48(5)(28),S => result_tmp(76),Cout => result_tmp(77));
FA31 : FA PORT MAP (A => MATRIX13X48(6)(28),B => MATRIX13X48(7)(28),Cin => MATRIX13X48(8)(28),S => result_tmp(78),Cout => result_tmp(79));
HA9 : HA PORT MAP (A => MATRIX13X48(9)(28),B => MATRIX13X48(10)(28),S => result_tmp(80),Cout => result_tmp(81));


FA32 : FA PORT MAP (A => MATRIX13X48(0)(29),B => MATRIX13X48(1)(29),Cin => MATRIX13X48(2)(29),S => result_tmp(82),Cout => result_tmp(83));
FA33 : FA PORT MAP (A => MATRIX13X48(3)(29),B => MATRIX13X48(4)(29),Cin => MATRIX13X48(5)(29),S => result_tmp(84),Cout => result_tmp(85));
FA34 : FA PORT MAP (A => MATRIX13X48(5)(29),B => MATRIX13X48(7)(29),Cin => MATRIX13X48(8)(29),S => result_tmp(86),Cout => result_tmp(87));


FA35 : FA PORT MAP (A => MATRIX13X48(0)(30),B => MATRIX13X48(1)(30),Cin => MATRIX13X48(2)(30),S => result_tmp(88),Cout => result_tmp(89));
FA36 : FA PORT MAP (A => MATRIX13X48(3)(30),B => MATRIX13X48(4)(30),Cin => MATRIX13X48(5)(30),S => result_tmp(90),Cout => result_tmp(91));
HA10 : HA PORT MAP (A => MATRIX13X48(5)(30),B => MATRIX13X48(7)(30),S => result_tmp(92),Cout => result_tmp(93));


FA37 : FA PORT MAP (A => MATRIX13X48(0)(31),B => MATRIX13X48(1)(31),Cin => MATRIX13X48(2)(31),S => result_tmp(94),Cout => result_tmp(95));
FA38 : FA PORT MAP (A => MATRIX13X48(3)(31),B => MATRIX13X48(4)(31),Cin => MATRIX13X48(5)(31),S => result_tmp(96),Cout => result_tmp(97));


FA39 : FA PORT MAP (A => MATRIX13X48(0)(32),B => MATRIX13X48(1)(32),Cin => MATRIX13X48(2)(32),S => result_tmp(98),Cout => result_tmp(99));
HA11 : HA PORT MAP (A => MATRIX13X48(3)(32),B => MATRIX13X48(4)(32),S => result_tmp(100),Cout => result_tmp(101));


FA45 : FA PORT MAP (A => MATRIX13X48(0)(33),B => MATRIX13X48(1)(33),Cin => MATRIX13X48(2)(33),S => result_tmp(102),Cout => result_tmp(103));


HA46 : HA PORT MAP (A => MATRIX13X48(0)(34),B => MATRIX13X48(1)(34),S => result_tmp(104),Cout => result_tmp(105));


Results_FA_HA_Stage2 <= result_tmp;

---------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------Assignment output vectors--------------------------------------------------------------------------------------------------------


	V0(15 DOWNTO 0) <= MATRIX13X48(0)(15 DOWNTO 0);
	V0(28 DOWNTO 16) <= MATRIX13X48(0)(47 DOWNTO 35);
	
	
	
	V1(15 DOWNTO 0) <= MATRIX13X48(1)(15 DOWNTO 0);
	V1(28 DOWNTO 16) <= MATRIX13X48(1)(47 DOWNTO 35);
	
	

	V2(15 DOWNTO 0) <= MATRIX13X48(2)(17 DOWNTO 2);
	V2(28 DOWNTO 16) <= MATRIX13X48(2)(46 DOWNTO 34);
	
	
	
	V3(13 DOWNTO 0) <= MATRIX13X48(3)(17 DOWNTO 4);
	V3(25 DOWNTO 14) <= MATRIX13X48(3)(44 DOWNTO 33);
	
	

	V4(11 DOWNTO 0) <= MATRIX13X48(4)(17 DOWNTO 6);
	V4(21 DOWNTO 12) <= MATRIX13X48(4)(42 DOWNTO 33);
	
	

	V5(11 DOWNTO 0) <= MATRIX13X48(5)(19 DOWNTO 8);
	V5(20 DOWNTO 12) <= MATRIX13X48(5)(40 DOWNTO 32);
	
	

	V6(9 DOWNTO 0) <= MATRIX13X48(6)(19 DOWNTO 10);
	V6(17 DOWNTO 10) <= MATRIX13X48(6)(38 DOWNTO 31);
	
	
  	V7(7 DOWNTO 0) <= MATRIX13X48(7)(19 DOWNTO 12);
	V7(13 DOWNTO 8) <= MATRIX13X48(7)(36 DOWNTO 31);
	
	
  	V8(7 DOWNTO 0) <= MATRIX13X48(8)(21 DOWNTO 14);
	V8(12 DOWNTO 8) <= MATRIX13X48(8)(34 DOWNTO 30);
	
	
	V9(5 DOWNTO 0) <= MATRIX13X48(9)(21 DOWNTO 16);
	V9(9 DOWNTO 6) <= MATRIX13X48(9)(32 DOWNTO 29);
	
	
	V10(3 DOWNTO 0) <= MATRIX13X48(10)(21 DOWNTO 18);
	V10(5 DOWNTO 4) <= MATRIX13X48(10)(30 DOWNTO 29);
	
	
	V11(3 DOWNTO 0) <= MATRIX13X48(11)(23 DOWNTO 20);
	V11(4) <= MATRIX13X48(11)(28);
	
	
	V12(5 DOWNTO 0) <= MATRIX13X48(12)(27 DOWNTO 22);



END ARCHITECTURE;