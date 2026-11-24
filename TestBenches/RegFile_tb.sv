`timescale 1ns/1ps
module Reg_File_tb();




logic clk = 0;
logic [4:0] A1, A2, A3;
logic [31:0] WD3, RD1 , RD2;
logic WE3;
logic [6:0] Op;
logic [2:0] funct3;


Reg_File dut( .A1(A1) , .A2(A2) , .A3(A3) , .WD3(WD3) , .RD1(RD1) , .RD2(RD2) , .WE3(WE3) , .clk(clk) , .Op(Op) , .funct3(funct3) );



always #5 clk = ~clk;

//Task to set Write enable and input write data
task write_set(input logic W, input logic [31:0] WD);

WE3 = W;
WD3 = WD;
if( W == 1'b1) 
$display("Writing Enabled: Write data = %h", WD);
else
$display("Writing Disabled: Write data = %h", WD);


endtask



//Task to check if correct value is read in the second half of the cycle
task read(input logic[31:0] RD1_exp, RD2_exp);

if(RD1 === RD1_exp && RD2 === RD2_exp)
$display(" x%d = %h , x%d = %h , matches expected values ", A1, RD1, A2, RD2);
else begin
$display(" ERROR: x%d = %h , Expected: %h , x%d = %h , Expected: %h", A1, RD1, RD1_exp, A2, RD2, RD2_exp);
$finish;
end
endtask



//Task to select the registers that will be read and the register that will be written to
task Reg_sel( input logic [4:0] rs1, rs2, rd);
A1 = rs1;
A2 = rs2;
A3 = rd;
$display(" rs1 set to: x%d , rs2 set to: x%d  , rd set to: x%d", rs1, rs2, rd);
endtask


//Task to select load instruction


task load_set(input logic [6:0] Op_sel, input logic [2:0] funct3_sel);

if(Op_sel == 7'd3 && funct3_sel == 3'd0) begin
$display("lb selected");
Op = Op_sel;
funct3 = funct3_sel;
end

if(Op_sel == 7'd3 && funct3_sel == 3'd1) begin
$display("lh selected");
Op = Op_sel;
funct3 = funct3_sel;
end

if(Op_sel == 7'd3 && funct3_sel == 3'd2) begin
$display("lw selected");
Op = Op_sel;
funct3 = funct3_sel;
end

if(Op_sel == 7'd3 && funct3_sel == 3'd4) begin
$display("lbu selected");
Op = Op_sel;
funct3 = funct3_sel;
end

if(Op_sel == 7'd3 && funct3_sel == 3'd5) begin
$display("lhu selected");
Op = Op_sel;
funct3 = funct3_sel;
end



endtask





initial begin

/* Task list:
    use before negedge:
    Reg_sel
    write_set
    use after negedge:
    read
 */


 /* Task Shells:
 
 
 Reg_sel( .rs1() , .rs2() , .rd() );
 
 write_set( .W() , .WD() );

 read( .RD1_exp() , .RD2_exp() );

 load_set( .Op_sel() , .funct3_sel() );
 
 */


@(posedge clk);

// Reading from RD1 after a write

 Reg_sel( .rs1(5'd1) , .rs2(5'd2) , .rd(5'd1) );
 write_set( .W(1'b1) , .WD(32'hFFFF_FFFF) );


@(negedge clk);

 #2;
 read( .RD1_exp(32'hFFFF_FFFF) , .RD2_exp(32'hxxxx_xxxx) );


 @(posedge clk);

//Reading from RD2 after a write

 Reg_sel( .rs1(5'd1) , .rs2(5'd2) , .rd(5'd2) );
 write_set( .W(1'b1) , .WD(32'hFAFA_FAFA) );

@(negedge clk);
 #2;
 read( .RD1_exp(32'hFFFF_FFFF) , .RD2_exp(32'hFAFA_FAFA) );


@(posedge clk);
// Writing with Write Enable low


 Reg_sel( .rs1(5'd5) , .rs2(5'd2) , .rd(5'd5) );
 write_set( .W(1'b0) , .WD(32'hAAAA_BBBB) );


@(negedge clk);
 #2;
 read( .RD1_exp(32'hxxxx_xxxx) , .RD2_exp(32'hFAFA_FAFA) );


@(posedge clk);


/*Load instruction tests*/

/* 

Opcode: 3

funct3: 

lw: 2 , lh: 1 , lb: 0 , lhu: 5 , lbu: 4

*/

 

//lw


 Reg_sel( .rs1(5'd5) , .rs2(5'd2) , .rd(5'd5) );
 write_set( .W(1'b1) , .WD(32'hABAC_ADAB) );
 load_set( .Op_sel(7'd3) , .funct3_sel(3'd2) );

@(negedge clk);
  #2;
 read( .RD1_exp(32'hABAC_ADAB) , .RD2_exp(32'hFAFA_FAFA) );


@(posedge clk);
//lh

 Reg_sel( .rs1(5'd6) , .rs2(5'd2) , .rd(5'd6) );
 write_set( .W(1'b1) , .WD(32'hABAC_ADAB) );
 load_set( .Op_sel(7'd3) , .funct3_sel(3'd1) );

@(negedge clk);
 #2;
 read( .RD1_exp(32'hFFFF_ADAB) , .RD2_exp(32'hFAFA_FAFA) );

 
 @(posedge clk);
//lb

Reg_sel( .rs1(5'd7) , .rs2(5'd2) , .rd(5'd7) );
write_set( .W(1'b1) , .WD(32'hABAC_ADAB) );
load_set( .Op_sel(7'd3) , .funct3_sel(3'd0) );

@(negedge clk);
 #2;
 read( .RD1_exp(32'hFFFF_FFAB) , .RD2_exp(32'hFAFA_FAFA) );


@(posedge clk);
//lhu

Reg_sel( .rs1(5'd8) , .rs2(5'd2) , .rd(5'd8) );
write_set( .W(1'b1) , .WD(32'hABAC_ADAB) );
load_set( .Op_sel(7'd3) , .funct3_sel(3'd5) );

@(negedge clk);
 #2;
 read( .RD1_exp(32'h0000_ADAB) , .RD2_exp(32'hFAFA_FAFA) );


@(posedge clk);
//lbu

Reg_sel( .rs1(5'd9) , .rs2(5'd2) , .rd(5'd9) );
write_set( .W(1'b1) , .WD(32'hABAC_ADAB) );
load_set( .Op_sel(7'd3) , .funct3_sel(3'd4) );


@(negedge clk);
 #2;
 read( .RD1_exp(32'h0000_00AB) , .RD2_exp(32'hFAFA_FAFA) );



@(posedge clk);
/* Register x0 Tests*/


//read form x0

Reg_sel( .rs1(5'd0) , .rs2(5'd0) , .rd(5'd0) );
write_set( .W(1'b0) , .WD(32'hFFAA_AAAA) );

@(negedge clk);
 #2;
 read( .RD1_exp(32'd0) , .RD2_exp(32'd0) );


@(posedge clk);
//Writing to x0, no data should be written


Reg_sel( .rs1(5'd0) , .rs2(5'd0) , .rd(5'd0) );
write_set( .W(1'b1) , .WD(32'hFFAA_AAAA) );


@(negedge clk);

 #2;
 read( .RD1_exp(32'd0) , .RD2_exp(32'd0) );


$finish;
end



endmodule