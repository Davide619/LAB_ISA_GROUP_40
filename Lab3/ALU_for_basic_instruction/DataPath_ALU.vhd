LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY DataPath_ALU IS
	PORT(
		--Data IN
		In_from_Rs1 : IN SIGNED(63 DOWNTO 0);
		In_from_Rs2 : IN SIGNED(63 DOWNTO 0);
		
		--Control signals
		Add_Sub_n : IN STD_LOGIC;
		In_Mux6to1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		--Data OUT
		ALU_resul : OUT SIGNED(63 DOWNTO 0);
		Zero_flag : OUT STD_LOGIC
		);

END DataPath_ALU;

ARCHITECTURE DP OF DataPath_ALU IS

COMPONENT ADD_SUB_n_ALU IS
	PORT(
		In_from_Rs : IN SIGNED(63 DOWNTO 0);
		In_from_Imm : IN SIGNED(63 DOWNTO 0);
		ADD_nSUB : IN STD_LOGIC;
		
		Out_AddSub : OUT SIGNED(63 DOWNTO 0)
		);

END COMPONENT;

COMPONENT Mux2to1_64b_ALU IS
	PORT(
		In1 : IN SIGNED(63 DOWNTO 0);
		In2 : IN SIGNED(63 DOWNTO 0);
		
		Ctrl : IN STD_LOGIC;
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END COMPONENT;

COMPONENT Mux32to1_64b_ALU IS
	PORT(
		In_from_rs1 : IN SIGNED(63 DOWNTO 0);
		
		ctrl : IN SIGNED(4 DOWNTO 0);
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END COMPONENT;

COMPONENT Mux6to1_64b_ALU IS
	PORT(
		In1 : IN SIGNED(63 DOWNTO 0);
		In2 : IN SIGNED(63 DOWNTO 0);
		In3 : IN SIGNED(63 DOWNTO 0);
		In5 : IN SIGNED(63 DOWNTO 0);
		In6 : IN SIGNED(63 DOWNTO 0);
		
		ctrl : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		Out_mux : OUT SIGNED(63 DOWNTO 0)
		);

END COMPONENT;

SIGNAL int3, int4, int7, int8, out3, out5, out6 : SIGNED(63 DOWNTO 0);

BEGIN
 

int7 <= "0000000000000000000000000000000000000000000000000000000000000001";
int8 <= "0000000000000000000000000000000000000000000000000000000000000000";


--add/sub
DUT3: ADD_SUB_n_ALU PORT MAP(In_from_Rs1, In_from_Rs2, Add_Sub_n, out3);
--AND
int3 <= In_from_Rs1 AND In_from_Rs2;
--XOR
int4 <= In_from_Rs1 XOR In_from_Rs2;

--mux6to1
DUT5: Mux6to1_64b_ALU PORT MAP(int3, int4, out3, out5, out6, In_Mux6to1, ALU_resul);

--mux2to1
DUT6: Mux2to1_64b_ALU PORT MAP(int7, int8, out3(63), out5);

--mux32to1
DUT7: Mux32to1_64b_ALU PORT MAP(In_from_Rs1, In_from_Rs2(4 DOWNTO 0), out6);

--zero flag
PROCESS(out3)
BEGIN
	if(out3 = "0000000000000000000000000000000000000000000000000000000000000000") THEN
		Zero_flag <= '0';
	else
		Zero_flag <= '1';
	end if;
end process;


END ARCHITECTURE;