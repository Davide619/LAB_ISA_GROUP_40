
//`timescale 1ns

module tb_Risc_V_Lite (); 

   wire CLK_i;
   wire RST_i;
   wire EOF;
   wire mem_read;
   wire mem_write;
   wire [31:0] I_from_file;
   wire [31:0] address;
   wire [31:0] write_data;
   wire [31:0] read_data;
   wire [31:0] PC;
   wire [31:0] instruction;

   clk_gen CG(
	.CLK(CLK_i),
	.rst(RST_i)
	); 

   Mem32x32 DMem(
	.WR(mem_write),
	.RD(mem_read),
	.Clock(CLK_i),
	.Address(address),
	.WriteData(write_data),
	.ReadData(read_data)
	);

   InstructionMem IMem(
	.Clock(CLK_i),
	.Address_from_PC(PC),
	//.WR(EOF),
	//.Instr_from_file(I_from_file),
	.Instruction(instruction)
	); 

  //data_maker DM(
	//.Clk(CLK_i),
	//.DataIN_to_mem(I_from_file),
	//.End_file(EOF)
	//); 

  RISCVlite_processor RP(
	.Clk(CLK_i),
	.Rst(RST_i), 
	.Instruction(instruction),
	.Data(read_data),
	.ProgramCounter(PC),
	.Address(address),
	.WriteData(write_data),
	.MemRead(mem_read),
	.MemWrite(mem_write)
	); 
  

endmodule	   
