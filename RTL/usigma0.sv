
module usigma0
  (input logic [31:0] in,
   output logic [31:0] out );
  
  logic [31:0] net [2:0];
  rotate_r #(2)  r1 (.in(in), .out(net[0]));
  rotate_r #(13) r2 (.in(in), .out(net[1]));
  rotate_r #(22) r3 (.in(in), .out(net[2]));
  
  assign out = net[0] ^ net[1] ^ net[2];
endmodule