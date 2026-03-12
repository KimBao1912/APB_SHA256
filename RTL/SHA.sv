`include "padding.sv"
`include "expansion.sv"
`include "compression.sv"
`include "k_value.sv"
`include "controller.sv"
`include "shift_r.sv"
`include "rotate_r.sv"
`include "FSM.sv"
`include "counter.sv"
`include "lsigma0.sv"
`include "lsigma1.sv"
`include "usigma0.sv"
`include "usigma1.sv"
`include "major.sv"
`include "choice.sv"
module SHA 
  (input logic clk, rst_n,
   input logic en,
   input logic [31:0] data_in,
   output logic [255:0] hash_data,
   output logic finish             );
  
  logic [511:0] M;
  logic [31:0] Wt;
  logic [5:0] cnt_val;
  logic sel, process, compress;
  logic [31:0] k_val;
  logic [31:0] out_a, out_b, out_c, out_d, out_e, out_f, out_g, out_h;
  //===== CONTROLLER =====
  controller controll(.clk(clk), .rst_n(rst_n), .en(en), .cnt_val(cnt_val), .sel(sel), .process(process), .compress(compress), .finish(finish));
  //===== PADDING =====
  padding padd(.data_in(data_in), .M(M));
  //===== EXPANSION =====
  expansion ex(.clk(clk), .rst_n(rst_n), .cnt_val(cnt_val), .sel(sel), .process(process), .M(M), .Wt(Wt));
  //===== K_VALUE =====
  k_value k(.addr(cnt_val), .process(process), .k_val(k_val));
  //===== COMPRESSION =====
  compression comp(.clk(clk), .rst_n(rst_n), .compress(compress), .k_val(k_val), .Wt(Wt), .out_a(out_a), .out_b(out_b), .out_c(out_c), .out_d(out_d), .out_e(out_e), .out_f(out_f), .out_g(out_g), .out_h(out_h));
  //===== HASH DATA ====
  logic [31:0] h0, h1, h2, h3, h4, h5, h6, h7;
  assign h0 = out_a + 32'h6a09e667;
  assign h1 = out_b + 32'hbb67ae85;
  assign h2 = out_c + 32'h3c6ef372;
  assign h3 = out_d + 32'ha54ff53a;
  assign h4 = out_e + 32'h510e527f;
  assign h5 = out_f + 32'h9b05688c;
  assign h6 = out_g + 32'h1f83d9ab;
  assign h7 = out_h + 32'h5be0cd19;
  
  assign hash_data = (en) ? {h0, h1, h2, h3, h4, h5, h6, h7} : {32'h6a09e667,32'hbb67ae85,32'h3c6ef372, 32'ha54ff53a,32'h510e527f,32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19};
endmodule