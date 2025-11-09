// 2-bit ALUOp encoding used below:
// 00: ADD (lw/sw/addi)
// 01: SUB (beq/bne)
// 10: use funct (R-type)
// 11: use opcode (andi/ori/slti/lui)
module InstructionToControlSignal(
    input  [5:0] instruction,  // opcode = instruction[31:26]
    output reg   RegDst,
    output reg   Jump,
    output reg   Branch,       // asserted for beq and bne (see note)
    output reg   MemRead,
    output reg   MemtoReg,
    output reg   ALUOp0,
    output reg   ALUOp1,
    output reg   MemWrite,
    output reg   ALUSrc,
    output reg   RegWrite
);
    // local wires for readability
    wire [5:0] op = instruction;

    always @* begin
        // safe defaults
        RegDst   = 1'b0;
        Jump     = 1'b0;
        Branch   = 1'b0;
        MemRead  = 1'b0;
        MemtoReg = 1'b0;
        ALUOp1   = 1'b0;
        ALUOp0   = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        RegWrite = 1'b0;

        case (op)
            6'd0: begin
                // R-type (add/sub/and/or/slt/…): write rd, ALU by funct
                RegDst   = 1'b1;
                RegWrite = 1'b1;
                ALUOp1   = 1'b1;  // 10
                ALUOp0   = 1'b0;
                // NOTE: jr (funct=8) needs special handling (see below)
            end

            // Loads / stores
            6'd35: begin // lw
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                {ALUOp1,ALUOp0} = 2'b00; // add base+imm
            end
            6'd43: begin // sw
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                {ALUOp1,ALUOp0} = 2'b00;
            end

            // Branches (PCSrc uses Zero for beq, !Zero for bne)
            6'd4,       // beq
            6'd5: begin // bne
                Branch = 1'b1;
                {ALUOp1,ALUOp0} = 2'b01; // subtract rs-rt to set Zero
            end

            // Arithmetic/logic immediates that are NOT addi
            6'd12,      // andi
            6'd13,      // ori
            6'd10,      // slti
            6'd15: begin// lui
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                {ALUOp1,ALUOp0} = 2'b11; // let ALUControl key off opcode
            end

            6'd8: begin // addi
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                {ALUOp1,ALUOp0} = 2'b00;
            end

            // Jumps
            6'd2: begin // j
                Jump = 1'b1;
            end
            6'd3: begin // jal
                Jump    = 1'b1;
                // NOTE: jal also writes $ra=PC+4.
                // With a 1-bit RegDst you cannot select $ra=31.
                // You’ll need either RegDst[1:0] or a separate 'Link' path.
            end

            default: ; // keep defaults = 0
        endcase
    end
endmodule
