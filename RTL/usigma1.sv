
module usigma1
  (input logic [31:0] in,
   output logic [31:0] out );
  
  logic [31:0] net [2:0];
  rotate_r #(6)  r1 (.in(in), .out(net[0]));
  rotate_r #(11) r2 (.in(in), .out(net[1]));
  rotate_r #(25) r3 (.in(in), .out(net[2]));
  
  assign out = net[0] ^ net[1] ^ net[2];
endmodule