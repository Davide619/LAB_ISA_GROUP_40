LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ALU IS
	PORT(
		--Data IN
		In_Rs1 : IN SIGNED(63 DOWNTO 0);
		In_Rs2_Imm : IN SIGNED(63 DOWNTO 0);
		
		--Data Control
		In_from_ALU_CU : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		--Data OUT
		Out_ALU_resul : OUT SIGNED(63 DOWNTO 0);
		Out_Zero_flag : OUT STD_LOGIC
		);

END ALU;

ARCHITECTURE CU_ALU OF ALU IS

COMPONENT DataPath_ALU IS
	PORT(
		--Data IN
		In_from_Rs1 : IN SIGNED(63 DOWNTO 0);
		In_from_Rs2 : IN SIGNED(63 DOWNTO 0);
		
		--Control signals
		Mod_Norm_n : IN STD_LOGIC;
		Add_Sub_n : IN STD_LOGIC;
		In_Mux6to1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		--Data OUT
		ALU_resul : OUT SIGNED(63 DOWNTO 0);
		Zero_flag : OUT STD_LOGIC
		);

END COMPONENT;

SIGNAL Out_tmp : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN
 

PROCESS(In_from_ALU_CU)
BEGIN
	CASE In_from_ALU_CU IS
		WHEN "0010" =>
			Out_tmp <= "01010"; --ADD
		WHEN "0011" =>
			Out_tmp <= "00001"; --XOR
		WHEN "0000" =>
			Out_tmp <= "00000"; --AND
		WHEN "0110" =>
			Out_tmp <= "00100"; --CMP
		WHEN "0100" =>
			Out_tmp <= "00110"; --SHIFT
		WHEN "0101" =>
			Out_tmp <= "10011"; --ABS
		WHEN OTHERS =>
			Out_tmp <= "01000"; --ADD
	END CASE;
	
end process;


DUT: DataPath_ALU PORT MAP(In_Rs1, In_Rs2_Imm, Out_tmp(4), Out_tmp(3), Out_tmp(2 DOWNTO 0), Out_ALU_resul, Out_Zero_flag);

END ARCHITECTURE;


