module MEM_Stage(
    input wire clk,
    input wire reset,
    // input from EX Stage
    input wire exmem_MemtoReg,
    input wire exmem_RegWrite,
    input wire exmem_MemRead,
    input wire exmem_MemWrite,
    input wire [31:0] exmem_ALU_result,
    input wire [31:0] exmem_write_data,
    input wire [4:0] exmem_RegisterRd,
    // output to WB Stage
    output reg memwb_MemtoReg,
    output reg memwb_RegWrite,
    output reg [31:0] memwb_read_data,
    output reg [31:0] memwb_ALU_result,
    output reg [4:0] memwb_RegisterRd
);
    wire [31:0] read_data;
    DataMemory u_DataMemory(
        .clk(clk),
        .reset(reset),
        .addr(exmem_ALU_result),
        .mem_read(exmem_MemRead),
        .mem_write(exmem_MemWrite),
        .write_data(exmem_write_data),
        .read_data(read_data)
    );
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memwb_MemtoReg <= 1'b0;
            memwb_RegWrite <= 1'b0;
            memwb_read_data <= 32'd0;
            memwb_ALU_result <= 32'd0;
            memwb_RegisterRd <= 5'd0;
        end else begin
            memwb_MemtoReg <= exmem_MemtoReg;
            memwb_RegWrite <= exmem_RegWrite;
            memwb_read_data <= read_data;
            memwb_ALU_result <= exmem_ALU_result;
            memwb_RegisterRd <= exmem_RegisterRd;
        end
    end

endmodule