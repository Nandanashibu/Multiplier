`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;    // [7:4]=B, [3:0]=A
  reg [7:0] uio_in;
  wire [7:0] uo_out;  // Product
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the module - CRITICAL FIX: Module name must match exactly
  tt_um_nandanas_multiplier user_project (  // Changed to match your info.yaml
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Clock generation (100MHz) - unchanged
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset sequence - unchanged
  initial begin
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    #20;
    rst_n = 1;
  end

  // Test stimulus - corrected display formatting
  initial begin
    #40;
    // Test case 1: 3 * 4 = 12
    ui_in = 8'h43;  // B=4, A=3
    uio_in = 0;
    #10;
    $display("Test 1: %0d * %0d = %0d", ui_in[3:0], ui_in[7:4], uo_out);
    
    // Test case 2: 15 * 15 = 225
    #20;
    ui_in = 8'hFF;  // B=15, A=15
    uio_in = 0;
    #10;
    $display("Test 2: %0d * %0d = %0d", ui_in[3:0], ui_in[7:4], uo_out);
    
    #20;
    $finish;
  end

endmodule
