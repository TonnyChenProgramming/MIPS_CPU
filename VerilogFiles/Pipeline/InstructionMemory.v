module InstructionMemory
(
    input clk,
    input  [31:0] addr,
    output reg [31:0] instruction
);
    localparam DEPTH = 256;
    integer i;
     (* ram_style="block" *)  
    reg [31:0] mem [0:DEPTH - 1];

    initial begin
        for (i = 0; i < DEPTH; i = i + 1) mem[i] = 32'h00000000; // preset NOP
        $readmemh("prog.mem",mem);
    end

    wire [9:2] word_addr = addr[9:2];

    // Synchronous read (registers the output)
    always @(posedge clk) begin
            instruction <= mem[word_addr];
    end
endmodule