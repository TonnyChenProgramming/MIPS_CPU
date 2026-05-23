`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2025 15:04:10
// Design Name: 
// Module Name: Top_Pipeline_CPU_tb
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


module Top_Pipeline_CPU_tb;

  wire [31:0] write_back_data;
  // 50 MHz clock: 20 ns period (toggle every 10 ns)
  reg clk = 0;
  always #10 clk = ~clk;

  // Reset must be reg because we drive it
  reg reset = 1;

  // DUT
  Top_Pipeline_CPU dut (
    .clk   (clk),
    .reset (reset),
    .write_back_data(write_back_data)
  );

  // Stimulus
  initial begin
    // hold reset a few cycles
    repeat (5) @(posedge clk);
    reset = 0;                 // release reset

    // run for a while then finish
    repeat (200) @(posedge clk);
    $finish;
  end

endmodule
