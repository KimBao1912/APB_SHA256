module major
  (input logic [31:0] in1, in2, in3,
   output logic [31:0] out         );
  assign out = (in1&in2) ^ (in1&in3) ^ (in2&in3);
endmodule