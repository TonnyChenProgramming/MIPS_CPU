`timescale 1ns/1ps

module SingleCycleCPUtb;

  // 50 MHz clock: 20 ns period (toggle every 10 ns)
  reg clk = 0;
  always #100 clk = ~clk;

  // Reset must be reg because we drive it
  reg reset = 1;

  // DUT
  Top_Single_Cycle_CPU dut (
    .clk   (clk),
    .reset (reset)
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

