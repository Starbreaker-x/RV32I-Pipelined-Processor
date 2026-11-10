module IM( input logic [31:0] A, output logic [31:0] RD);



logic [31:0] mem [0:255];

//initializing our program
initial begin 
    //Will need a new initialization file to fully test the functionality of the 5-stage pipeline
  //  $readmemh("RV32I_Instructions_V2.hex",mem);
end

//Dividing the value provided by PC by 4 to get the correct value from instruction memory
// Might need to find another way to do this if this causes issues in synthesis
assign RD = mem[A/4];


endmodule