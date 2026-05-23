// ALU_32bits.v
//arithmetic operation: add, addu, sub, subu, addi, addiu
//logical operation: and, andi, or, ori
//comparison operation: slt, sltu, slti, sltiu
// support 5 operations: AND, OR, ADD, SUB, SLT
module ALU_32bits (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALU_Sel,
    output reg [31:0] Result,
    output        Zero,
    output        Overflow
);
    always@(*) begin
        case(ALU_Sel)
            3'b000: Result = A & B;
            3'b001: Result = A|B;
            3'b010: Result = A + B;
            3'b110: Result = A - B;
            3'b111: Result = ($signed(A) < $signed(B)) ? 1 : 0; 
            default: Result = 32'b0;
        endcase
    end
    assign Zero = (Result == 0) ? 1 : 0;
    wire add_overflow = (A[31] == B[31]) && (Result[31] != A[31]);
    wire sub_overflow = (A[31] ^ B[31]) && (Result[31] != A[31]);

    assign Overflow = (ALU_Sel == 3'b010) ? add_overflow :
                    (ALU_Sel == 3'b110) ? sub_overflow :
                    1'b0;

endmodule
