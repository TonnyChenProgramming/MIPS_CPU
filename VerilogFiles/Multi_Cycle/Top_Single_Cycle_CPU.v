module Top_Single_Cycle_CPU
(
    input clk,
    input reset
);
    // Internal wires
    wire [31:0] pc;
    wire [31:0] instruction;
    reg [31:0]  next_pc;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] sign_extended_addr;
    //control signals
    wire RegDst, Jump, Branch, MemRead, MemtoReg,
         ALUOp0, ALUOp1, MemWrite, ALUSrc, RegWrite;
    wire PCsrc = Branch & zero_flag;
    wire [4:0]write_register =  RegDst ? instruction[15:11] : instruction[20:16];
    wire [2:0] ALU_Sel;
    wire [31:0] alu_result;
    wire zero_flag;
    wire Overflow_flag;
    wire [31:0] data_memory_read_data;

    // pc related wires
    wire [31:0] pc_plus_4 = pc + 4;
    wire [31:0] jump_address = {pc_plus_4[31:28], instruction[25:0], 2'b00};
    wire [31:0] branch_target = pc_plus_4 + (sign_extended_addr << 2);
    wire [31:0] pc_next_branch = PCsrc ? branch_target : pc_plus_4;

    always @(*) begin
        next_pc = pc_plus_4;
        if (PCsrc) begin
            next_pc = branch_target;
        end
        if (Jump) begin
            next_pc = jump_address;
        end
    end
    // Instantiate Program Counter
    ProgramCounter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc) // output
    );

    InstructionMemory instruction_memory_inst(
        .clk(clk),
        .reset(reset),
        .addr(pc),
        .instruction(instruction)
    );
    InstructionToControlSignal instruction_to_control_signal_inst (
        .instruction(instruction[31:26]),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp0(ALUOp0),
        .ALUOp1(ALUOp1),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    SignExtend sign_extend_inst(
        .in(instruction[15:0]),
        .out(sign_extended_addr)
    );
    RegisterFile register_file_inst(
        .clk(clk),
        .reset(reset),
        .reg_write(RegWrite),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(write_register),
        .write_data(MemtoReg ? data_memory_read_data : alu_result),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    ALUControl alu_control_inst(
            .ALUOp({ALUOp1, ALUOp0}),
            .funct(instruction[5:0]),
            .ALU_Sel(ALU_Sel)
    );
    ALU_32bits alu_32bits_inst(
        .A(read_data1),
        .B(ALUSrc ? sign_extended_addr : read_data2),
        .ALU_Sel(ALU_Sel),
        .Result(alu_result),
        .Zero(zero_flag),
        .Overflow(Overflow_flag)
    );
    DataMemory data_memory_inst(
        .clk(clk),
        .reset(reset),
        .addr(alu_result),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .write_data(read_data2),
        .read_data(data_memory_read_data)
    );

endmodule
