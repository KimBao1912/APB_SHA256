module padding
  (input logic [31:0] data_in,
   output logic [511:0] M      );
  
  assign M = {data_in, 1'b1, 415'd0, 64'd32};
endmodule