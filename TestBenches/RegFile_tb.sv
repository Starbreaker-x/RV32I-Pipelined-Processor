`timescale 1ns/1ps
module Reg_File_tb();



Reg_File dut( .A1(A1) , .A2(A2) , .A3(A3) , .WD3(WD3) , .RD1(RD1) , .RD2(RD2) , .WE3(WE3) , .clk(clk) , .Op(Op) , .funct3(funct3) );

logic clk = 0;
logic [4:0] A1, A2, A3;
logic [31:0] WD3, RD1 , RD2;
logic WE3;
logic [6:0] Op;
logic [2:0] funct3;

always #5 clk = ~clk;

//Task to set Write enable and input write data
task write_set(input logic W, input logic [31:0] WD);

WE3 = W;
WD3 = WD;
if( W == 1'b1) begin
$display("Writing Enabled: Write data = %h", W);
else
$display("Writing Disabled: Write data = %h", W);
end

endtask

//Task that checks if the correct data was written to a register 
task write(input logic[4:0] Regnum, input logic[31:0] WD_exp);

if(dut.Reg_File.Registers[Regnum] == WD_exp)
$display(" x%d = %h , matches expected value" Regnum, dut.Reg_File.Registers[Regnum]);
else
$display(" ERROR: x%d = %h , Expected: %h " Regnum, dut.Reg_File.Registers[Regnum], WD_exp);

endtask


//Task to check if correct value is read in the second half of the cycle
task read(input logic[31:0] RD1_exp, RD2_exp);

if(RD1 == RD1_exp && RD2 == RD2_exp)
$display(" x%d = %h , x%d = %h , matches expected values ", A1, RD1, A2, RD2);
else
$display(" ERROR: x%d = %h , Expected: %h , x%d = %h , Expected: %h", A1, RD1, RD1_exp, A2, RD2, RD2_exp);

endtask



//Task to select the registers that will be read and the register that will be written to
task Reg_Sel( input logic [4:0] rs1, rs2, rd);
A1 = rs1;
A2 = rs2;
A3 = rd;
$display(" rs1 set to: x%d , rs2 set to: x%d  , rd set to: x%d", rs1, rs2, rd);
endtask








initial begin

/* Task list:
    use before negedge:
    Reg_sel
    write_set
    use after negedge:
    read
    write */


@(posedge clk);









end



endmodule