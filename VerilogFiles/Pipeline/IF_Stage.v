module IF_Stage(
    input wire clk,
    input wire reset,

    // control/ hazard signals
    input wire PC_Write,
    input wire Branch,
    input wire Equal,
    input wire Jump,

    input wire ifid_write,
    input wire ifid_flush,

    // pc signals
    input wire [31:0] branch_target,
    input wire [31:0] jump_target,

    //IF/ID registers
    output reg [31:0] ifid_instruction,
    output reg [31:0] ifid_pc_plus_4
);
    wire [31:0] pc_current;
    wire [31:0] pc_plus_4_F;
    wire [31:0] instruction_F;
    ProgramCounter u_program_counter(
        .clk(clk),
        .reset(reset),
        .Branch(Branch),
        .Equal(Equal),
        .Jump(Jump),
        .PC_Write(PC_Write),
        .branch_target(branch_target),
        .jump_target(jump_target),
        .pc_current(pc_current),
        .pc_plus_4(pc_plus_4_F)
    );
    InstructionMemory u_instruction_memory(
        .clk(clk),
        .addr(pc_current),
        .instruction(instruction_F)
    );

    always@(posedge clk or posedge reset)begin
        if (reset) begin
            ifid_pc_plus_4 <= 32'd4;
            ifid_instruction <= 32'd0;
        end else if(ifid_flush) begin
            ifid_pc_plus_4 <= 32'd4;
            ifid_instruction <= 32'd0;
        end else if(ifid_flush) begin
            ifid_pc_plus_4 <= 32'd4;
            ifid_instruction <= 32'd0;
        end else if (ifid_write) begin
            ifid_pc_plus_4 <= pc_plus_4_F;
            ifid_instruction <= instruction_F;
        end
    end



endmodule