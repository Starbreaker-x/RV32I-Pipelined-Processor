module Reg_File_tb();



Reg_File dut( .A1(A1) , .A2(A2) , .A3(A3) , .WD3(WD3) , .RD1(RD1) , .RD2(RD2) , .WE3(WE3) , .clk(clk) , .Op(Op) , .funct3(funct3) );


logic [4:0] A1, A2, A3;
logic [31:0] WD3, RD1 , RD2;
logic WE3, clk;
logic [6:0] Op;
logic [2:0] funct3;


//Task to check if writes occur on the falling edge
task write();






endtask



//Task to check if correct value is read in the second half of the cycle
task read();





endtask



initial begin




end



endmodule