module shift_r #(parameter N = 1)
  (input logic [31:0] in,
   output logic [31:0] out );
  assign out = (in >> N);
endmodule