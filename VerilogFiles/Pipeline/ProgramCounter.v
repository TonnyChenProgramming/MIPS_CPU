module ProgramCounter(
    input wire clk,
    input wire reset, 
    input Branch,
    input Equal,
    input Jump,
    input PC_Write,
    input [31:0] branch_target,
    input [31:0] jump_target,
    output reg [31:0] pc_current,
    output wire [31:0] pc_plus_4

);
    wire PC_Src = Branch & Equal;
    wire [31:0] next_pc = Jump  ? jump_target   :
                        PC_Src ? branch_target :
                                pc_plus_4;

    assign pc_plus_4 = pc_current + 32'd4;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_current <= 32'b0; // Reset PC to 0
        end else if (PC_Write) begin
            pc_current <= next_pc;
        end
    end

endmodule