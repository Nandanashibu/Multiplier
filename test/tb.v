`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the 4x4 multiplier module
  tt_um_addon user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end

  // Reset sequence
  initial begin
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    #20;
    rst_n = 1;
  end

  // Test stimulus
  initial begin
    #40;
    ui_in = 8'h03; // 3
    uio_in = 8'h04; // 4
    #10;
    $display("%d * %d = %d", ui_in[3:0], uio_in[3:0], uo_out);
    
    #20;
    ui_in = 8'h0F; // 15
    uio_in = 8'h0F; // 15
    #10;
    $display("%d * %d = %d", ui_in[3:0], uio_in[3:0], uo_out);
    
    #20;
    $finish;
  end

endmodule
