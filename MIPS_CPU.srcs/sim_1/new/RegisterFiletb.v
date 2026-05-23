`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 13:26:35
// Design Name: 
// Module Name: RegisterFiletb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFiletb;
  reg clk = 0;
  always #100 clk = ~clk;
  reg reset = 1;
  reg  [4:0]  write_reg = 5'd8;
  reg  [31:0] write_data = 32'h0100;
  reg  reg_write = 1;
  
  RegisterFile dut(
    .clk(clk),
    .reset(reset),
    .write_reg(write_reg),
    .write_data(write_data),
    .reg_write(reg_write)
  );
  
    // Stimulus
  initial begin
    // hold reset a few cycles
    repeat (5) @(posedge clk);
    reset = 0;                 // release reset
    repeat (5) @(posedge clk);
    write_data = 32'h0111;
    // run for a while then finish
    repeat (200) @(posedge clk);
    $finish;
  end
  
  
endmodule
