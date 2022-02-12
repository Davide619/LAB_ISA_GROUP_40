LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ADD_SUB_n_ALU IS
	PORT(
		In_from_Rs : IN SIGNED(63 DOWNTO 0);
		In_from_Imm : IN SIGNED(63 DOWNTO 0);
		ADD_nSUB : IN STD_LOGIC;
		
		Out_AddSub : OUT SIGNED(63 DOWNTO 0)
		);

END ADD_SUB_n_ALU;

ARCHITECTURE Arithmetic_OP OF ADD_SUB_n_ALU IS
BEGIN
process(ADD_nSUB, In_from_Imm, In_from_Rs)
begin
	if(ADD_nSUB = '1') then
		Out_AddSub <= In_from_Rs + In_from_Imm;
	else
		Out_AddSub <= In_from_Rs - In_from_Imm;
	end if;
end process;


END ARCHITECTURE;