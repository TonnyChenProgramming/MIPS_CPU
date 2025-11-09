module InstructionToControlSignal(
    input [5:0]instruction,
    output RegDst,
    output Jump,
    output Branch,
    output MemRead,
    output MemtoReg,
    output ALUOp0,
    output ALUOp1,
    output MemWrite,
    output ALUSrc,
    output RegWrite
);
    assign RegDst = (instruction == 6'd0);
    assign Jump = (instruction == 6'd2) | (instruction == 6'd3);
    assign Branch = (instruction == 6'd4);
    assign MemRead = (instruction == 6'd35);
    assign MemtoReg = (instruction == 6'd35);
    assign ALUOp0 = (instruction == 6'd4);
    assign ALUOp1 = (instruction == 6'd0);
    assign MemWrite = (instruction == 6'd43);
    assign ALUSrc = (instruction == 6'd43)|(instruction == 6'd35)| (instruction == 6'd8);
    assign RegWrite = ((instruction == 6'd8)&(instruction != 6'd43))|(instruction == 6'd0);

endmodule