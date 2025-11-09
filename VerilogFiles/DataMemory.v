// 32-bit word data memory, LW/SW only
module DataMemory #(
    parameter DEPTH_WORDS = 1024  // 4 KB (1024 x 4 bytes)
) (
    input         clk,
    input         reset,
    input  [31:0] addr,          // byte address from ALU
    input         mem_read,      // assert to read
    input         mem_write,     // assert to write
    input  [31:0] write_data,    // store data
    output reg [31:0] read_data  // load data (1-cycle latency)
);
    // Memory array: DEPTH_WORDS x 32 bits
    (* ram_style="block" *) reg [31:0] mem [0:DEPTH_WORDS-1];

    // Optional preload for sim or ROM-like init
    // initial $readmemh("data.hex", mem);

    // Word index: drop low two bits (4-byte alignment)
    wire [$clog2(DEPTH_WORDS)-1:0] widx = addr[31:2];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset memory or output
            read_data <= 32'b0;
        end else begin
            // write (store word)
            if (mem_write)
                mem[widx] <= write_data;
            // read (load word): 1-cycle latency
            if (mem_read)
                read_data <= mem[widx];
        end
    end
endmodule