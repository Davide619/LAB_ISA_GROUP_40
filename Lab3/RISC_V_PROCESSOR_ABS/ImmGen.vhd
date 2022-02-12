LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- RISC-V-lite processor Immediate Generator
-- receives instruction from InstMem
-- provides sign-extended Immediate field

ENTITY ImmGen IS
	PORT(
			inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			imm  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
END ImmGen;

ARCHITECTURE behaviour OF ImmGen IS
	
BEGIN
	
	decoder: PROCESS (inst)
	BEGIN
	
		CASE inst(6 DOWNTO 0) IS
		
			-- I-type instruction (LW, ADDI, ANDI, SRAI)
			WHEN "0000011"|"0010011" =>
				imm(63 DOWNTO 12) <= (OTHERS => inst(31)); -- sign ext
				imm(11 DOWNTO 0)  <= inst(31 DOWNTO 20);
			
			-- S-type instruction (SW)
			WHEN "0100011" =>
				imm(63 DOWNTO 12) <= (OTHERS => inst(31)); -- sign ext
				imm(11 DOWNTO 5)  <= inst(31 DOWNTO 25);
				imm(4 DOWNTO 0)   <= inst(11 DOWNTO 7);
				
			-- B-type instruction (BEQ)
			WHEN "1100011" =>
				imm(63 DOWNTO 13) <= (OTHERS => inst(31)); -- sign ext
				imm(12)           <= inst(31);
				imm(11)           <= inst(7);
				imm(10 DOWNTO 5)  <= inst(30 DOWNTO 25);
				imm(4 DOWNTO 1)   <= inst(11 DOWNTO 8);
				imm(0)            <= '0'; -- due to 1-bit left shift
			
			-- U-type instruction (LUI, AUIPC)
			WHEN "0110111"|"0010111" =>
				imm(63 DOWNTO 32) <= (OTHERS => inst(31)); -- sign ext
				imm(31 DOWNTO 12) <= inst(31 DOWNTO 12);
				imm(11 DOWNTO 0)  <= (OTHERS => '0');
				
			-- J-type instruction (JAL)
			WHEN "1101111" =>
				imm(63 DOWNTO 21) <= (OTHERS => inst(31)); -- sign ext
				imm(20)           <= inst(31);
				imm(19 DOWNTO 12) <= inst(19 DOWNTO 12);
				imm(11)           <= inst(20);
				imm(10 DOWNTO 1)  <= inst(30 DOWNTO 21);
				imm(0)            <= '0'; -- due to 1-bit left shift
			
			-- default case
			WHEN OTHERS =>
				imm(63 DOWNTO 0) <= (OTHERS => '0');
			
		END CASE;
		
	END PROCESS;
	
END behaviour;