LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- RISC-V-lite processor Control Unit
-- receives the opcode field from the instruction
-- it is structured as a combinational decoder
ENTITY CU IS
	PORT(
			opcode   : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- instruction[6-0]
			
			Branch   : OUT STD_LOGIC; -- allows branching
			MemRead  : OUT STD_LOGIC; -- data memory RD signal
			MemtoReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- selects WriteReg source
			ALUOp    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- controls ALUControlUnit
			MemWrite : OUT STD_LOGIC; -- data memory WR signal
			ALUSrc   : OUT STD_LOGIC; -- selects ALU 2nd operand
			RegWrite : OUT STD_LOGIC); -- register file WR signal
END CU;

ARCHITECTURE behaviour OF CU IS
	
BEGIN

	decoder: PROCESS (opcode)
	BEGIN
		CASE opcode IS
		
			-- LW
			WHEN "0000011" => Branch <= '0';
									MemRead <= '1';
									MemtoReg <= "01";
									ALUOp <= "00";
									MemWrite <= '0';
									ALUSrc <= '1';
									RegWrite <= '1';
									
			-- ADDI, ANDI, SRAI
			WHEN "0010011" => Branch <= '0';
									MemRead <= '0';
									MemtoReg <= "00";
									ALUOp <= "10";
									MemWrite <= '0';
									ALUSrc <= '1';
									RegWrite <= '1';
									
			-- AUIPC
			WHEN "0010111" => Branch <= '0';
									MemRead <= '0';
									MemtoReg <= "10";
									ALUOp <= "11";
									MemWrite <= '0';
									ALUSrc <= '1';
									RegWrite <= '1';
									
			-- SW
			WHEN "0100011" => Branch <= '0';
									MemRead <= '0';
									MemtoReg <= "00";
									ALUOp <= "00";
									MemWrite <= '1';
									ALUSrc <= '0';
									RegWrite <= '0';

			-- ADD, SLT, XOR
			WHEN "0110011" => Branch <= '0';
									MemRead <= '0';
									MemtoReg <= "00";
									ALUOp <= "10";
									MemWrite <= '0';
									ALUSrc <= '0';
									RegWrite <= '1';
			
			-- LUI
			WHEN "0110111" => Branch <= '0';
									MemRead <= '1';
									MemtoReg <= "10";
									ALUOp <= "11";
									MemWrite <= '0';
									ALUSrc <= '1';
									RegWrite <= '1';
									
			-- BEQ
			WHEN "1100011" => Branch <= '1';
									MemRead <= '0';
									MemtoReg <= "00";
									ALUOp <= "01";
									MemWrite <= '0';
									ALUSrc <= '0';
									RegWrite <= '0';
					
			-- JAL
			WHEN "1101111" => Branch <= '1';
									MemRead <= '0';
									MemtoReg <= "10";
									ALUOp <= "11";
									MemWrite <= '0';
									ALUSrc <= '1';
									RegWrite <= '1';
									
			-- default case
			WHEN OTHERS => Branch <= '0';
									MemRead <= '0';
									MemtoReg <= "00";
									ALUOp <= "11";
									MemWrite <= '0';
									ALUSrc <= '0';
									RegWrite <= '0';
			
		END CASE;
				
	END PROCESS;
	
END behaviour;
	
			