LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- RISC-V-lite processor ALU Control Unit
-- receives: instruction[30,14-12]; Control Init commands
-- it is structured as a combinational decoder

ENTITY ALU_CU IS
	PORT(
			from_inst : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ALUOp     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			
			ALUCtrl   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ALU_CU;

ARCHITECTURE behaviour OF ALU_CU IS

BEGIN
	decoder: PROCESS (from_inst, ALUOp)
	BEGIN
		CASE ALUOp IS
		
			-- LW, SW
			WHEN "00" => ALUCtrl <= "0010";
			
			-- ADDI, ANDI, SRAI, ADD, SLT, XOR
			WHEN "10" =>
			
				-- ADDI
				IF (from_inst = "1000") THEN
					ALUCtrl <= "0010";
					
				-- ANDI
				ELSIF (from_inst = "0111") THEN
					ALUCtrl <= "0000";
					
				-- SRAI
				ELSIF (from_inst = "0110") THEN
					ALUCtrl <= "0100";
					
				-- ADD
				ELSIF (from_inst = "0000") THEN
					ALUCtrl <= "0010";
					
				-- SLT
				ELSIF (from_inst = "0010") THEN
					ALUCtrl <= "0110";
					
				-- XOR
				ELSIF (from_inst = "0100") THEN
					ALUCtrl <= "0100";
					
				-- default case:
				ELSE
					ALUCtrl <= "1111";
				END IF;
				
			-- BEQ
			WHEN "01" => ALUCtrl <= "0110";
			
			-- AUIPC, LUI, JAL, default case
			WHEN OTHERS => ALUCtrl <= "1111";
		
		END CASE;
	END PROCESS;
END behaviour;