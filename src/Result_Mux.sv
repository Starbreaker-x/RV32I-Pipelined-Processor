module Result_Mux(input logic [31:0] ALUResult, RD , ImmExt , PCPlus4 , PCTarget, input logic [2:0] ResultSrc, output logic [31:0] Result);



/*
ResultSrc Encodings

000: ALU Result : For R-type and some I-type instructions

001: ReadData : For load instructions

010: PCPlus4 : for jal and jalr

011: ImmExt : For lui

100: PCTarget : For auipc since (uipmm, 12'b0) + PC is the same as the calculated PCTarget


*/

 assign Result = ResultSrc[2] ? PCTarget : (ResultSrc[1] ? ( ResultSrc[0] ? ImmExt : PCPlus4 ) : ( ResultSrc[0] ? RD : ALUResult ));

endmodule