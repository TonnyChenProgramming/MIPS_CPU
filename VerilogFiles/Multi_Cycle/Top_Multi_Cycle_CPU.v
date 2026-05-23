module Top_Multi_Cycle_CPU(
    input clk,
    input reset
);
    // program counter wire and register declaration
    wire [31:0] pc;
    wire [31:0] next_pc;

    
    // Instantiate Program Counter
    ProgramCounter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc) // output
    );

endmodule