
module compression
  (input logic clk, rst_n,
   input logic compress,
   input logic [31:0] k_val, Wt,
   output logic [31:0] out_a, out_b, out_c, out_d, out_e, out_f, out_g, out_h);
  
  logic [31:0] t1_out;
  logic [31:0] usigma0_out, usigma1_out, major_out, choice_out;
  logic [31:0] a,b,c,d,e,f,g,h;
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      a <= 32'h6a09e667;
      b <= 32'hbb67ae85;
      c <= 32'h3c6ef372;
      d <= 32'ha54ff53a;
      e <= 32'h510e527f;
      f <= 32'h9b05688c;
      g <= 32'h1f83d9ab;
      h <= 32'h5be0cd19;
    end
    else begin
      if(compress) begin
        a <= out_a;
      	b <= a;
      	c <= b;
      	d <= c;
      	e <= out_e;
      	f <= e;
      	g <= f;
      	h <= g;
      end
      else begin
        a <= 32'h6a09e667;
      	b <= 32'hbb67ae85;
      	c <= 32'h3c6ef372;
      	d <= 32'ha54ff53a;
      	e <= 32'h510e527f;
      	f <= 32'h9b05688c;
      	g <= 32'h1f83d9ab;
      	h <= 32'h5be0cd19;
      end
    end
  end
  //---------
  usigma0 u0 (.in(a), .out(usigma0_out));
  usigma1 u1 (.in(e), .out(usigma1_out));
  major maj (.in1(a), .in2(b), .in3(c), .out(major_out));
  choice ch (.in1(e), .in2(f), .in3(g), .out(choice_out));
  //---------
  assign t1_out = k_val + Wt + usigma1_out + choice_out + h;
  //---------
  assign out_a = compress ? t1_out + usigma0_out + major_out : 32'h6a09e667;
  assign out_b = compress ? a : 32'hbb67ae85;
  assign out_c = compress ? b : 32'h3c6ef372;
  assign out_d = compress ? c : 32'ha54ff53a;
  assign out_e = compress ? t1_out + d : 32'h510e527f;
  assign out_f = compress ? e : 32'h9b05688c; 
  assign out_g = compress ? f : 32'h1f83d9ab;
  assign out_h = compress ? g : 32'h5be0cd19;
endmodule