
module lsigma0
  (input logic [31:0] in,
   output logic [31:0] out );
  logic [31:0] net [2:0];
  rotate_r #(7) r1 (.in(in), .out(net[0]));
  rotate_r #(18) r2 (.in(in), .out(net[1]));
  shift_r  #(3) r3 (.in(in), .out(net[2]));
  
  assign out = net[0] ^ net[1] ^ net[2];
endmodule