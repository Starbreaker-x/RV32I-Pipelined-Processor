module PCT_Mux( input logic [4:0] rs1 , input logic [31:0] PC, input logic PCTSrc , output logic [31:0] Result );

//Decides to output rs1 for jalr instruction or PC to be fed in to the PC_Target Adder
assign Result = PCTSrc ?  PC : {27'b0, rs1} ;

endmodule