`default_nettype none

module tt_um_multiplier (  // Fixed: Hyphen -> underscore (recommended for Verilog)
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Enable (unused)
    input  wire       clk,      // Clock (unused)
    input  wire       rst_n     // Reset (unused)
);

  // Extract two 4-bit values from ui_in
  wire [3:0] A = ui_in[3:0];
  wire [3:0] B = ui_in[7:4];
  
  // 4-bit multiplier producing an 8-bit result
  wire [7:0] product = A * B;
  
  // Assign outputs
  assign uo_out   = product;  // 8-bit result
  assign uio_out  = 0;        // Unused
  assign uio_oe   = 0;        // All IO as inputs
  
  // Combine unused signals to avoid warnings
  wire _unused = &{ena, clk, rst_n, uio_in};

endmodule
