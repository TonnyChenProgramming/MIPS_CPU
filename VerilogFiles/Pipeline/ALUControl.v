module ALUControl(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [2:0] ALU_Sel
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALU_Sel = 3'b010; // LW, SW -> ADD
            2'b01: ALU_Sel = 3'b110; // BEQ -> SUB
            2'b10: begin // R-type
                case (funct)
                    6'b100000: ALU_Sel = 3'b010; // ADD
                    6'b100001: ALU_Sel = 3'b010; // ADDU
                    6'b100010: ALU_Sel = 3'b110; // SUB
                    6'b100011: ALU_Sel = 3'b110; // SUBU
                    6'b100100: ALU_Sel = 3'b000; // AND
                    6'b100101: ALU_Sel = 3'b001; // OR
                    6'b101010: ALU_Sel = 3'b111; // SLT
                    default:   ALU_Sel = 3'b000; // Default to AND
                endcase
            end
            default: ALU_Sel = 3'b000; // Default to AND
        endcase
    end
endmodule