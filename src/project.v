

`default_nettype none

module multiplier-project (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Extract two 4-bit values from ui_in
  wire [3:0] A = ui_in[3:0];
  wire [3:0] B = ui_in[7:4];
  
  // 4-bit multiplier producing an 8-bit result
  wire [7:0] product = A * B;
  
  // Assign the result to uo_out
  assign uo_out = product;
  
  // No output on uio_out, all set to 0
  assign uio_out = 0;
  assign uio_oe  = 0;
  
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in};

endmodule


  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
