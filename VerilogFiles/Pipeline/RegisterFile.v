module RegisterFile (
    input         clk,
    input         reset,          // async active-high
    input  [4:0]  read_reg1,
    input  [4:0]  read_reg2,
    input  [4:0]  write_reg,
    input  [31:0] write_data,
    input         reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [0:31];
    integer i;

    // synchronous write, asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // clear all registers
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else begin
            // write only when enabled and not x0
            if (reg_write && (write_reg != 5'd0))
                registers[write_reg] <= write_data;

            // keep x0 hard-wired to zero
            registers[5'd0] <= 32'b0;
        end
    end

    // asynchronous reads (combinational)
    assign read_data1 = (read_reg1 == 5'd0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'b0 : registers[read_reg2];

endmodule
