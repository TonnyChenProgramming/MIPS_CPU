module WB_Stage(
    input wire clk,
    input wire reset,
    // input from MEM/WB registers
    input wire memwb_MemtoReg,
    input wire [31:0] memwb_ReadData,
    input wire [31:0] memwb_ALU_result,
    output reg [31:0] write_back_data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_back_data <= 32'd0;
        end else begin
            if (memwb_MemtoReg) begin
                write_back_data <= memwb_ReadData;
            end else begin
                write_back_data <= memwb_ALU_result;
            end
        end
    end
endmodule