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

  // Instantiate the module (corrected name to match your design)
  tt_um_Nandanashibu_multiplier-project (
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

  // Clock generation (100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
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

  // Test stimulus (corrected inputs)
  initial begin
    #40;
    // Test case 1: 3 * 4 = 12 (A in lower bits, B in upper bits)
    ui_in = 8'h43;  // B=4 (0x4), A=3 (0x3)
    uio_in = 0;     // Must be 0 (unused)
    #10;
    $display("Test 1: %d * %d = %d", ui_in[3:0], ui_in[7:4], uo_out);
    
    // Test case 2: 15 * 15 = 225
    #20;
    ui_in = 8'hFF;  // B=15 (0xF), A=15 (0xF)
    uio_in = 0;
    #10;
    $display("Test 2: %d * %d = %d", ui_in[3:0], ui_in[7:4], uo_out);
    
    #20;
    $finish;
  end

endmodule
