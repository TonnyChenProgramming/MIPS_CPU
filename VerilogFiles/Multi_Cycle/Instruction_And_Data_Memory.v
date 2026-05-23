module Instruction_And_Data_Memory #(
    parameter DEPTH_WORDS = 1024  // 4 KB (1024 x 4 bytes)
)(
    input clk,
    input reset,
    input MemRead,
    input MemWrite,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] memory_data
);
    // Initialize all the instruction to zero and load the instructions from the files
    localparam DEPTH = 256;
    integer i;
    reg [31:0] instruction_mem [0:DEPTH - 1];
    wire [9:2] word_addr = addr[9:2]; // limit word address to map to the depth

    // Memory array: DEPTH_WORDS x 32 bits
    (* ram_style="block" *) reg [31:0] data_mem [0:DEPTH_WORDS-1];
    // Word index: drop low two bits (4-byte alignment)
    wire [$clog2(DEPTH_WORDS)-1:0] widx = addr[31:2];

    initial begin
        for (i = 0; i < DEPTH; i = i + 1) instruction_mem[i] = 32'h00000000; // preset NOP
        $readmemh("prog.mem",instruction_mem);
    end

       

    // Synchronous read (registers the output)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory_data <= 32'b0;
        end else begin
            // write (store word)
            data_mem[widx] <= MemWrite ? write_data : data_mem[widx];
            memory_data <= MemRead ? data_mem[widx] : instruction_mem[word_addr];
            
        end
    end



endmodule