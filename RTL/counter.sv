module counter
  (input logic clk, rst_n,
   input logic cnt_en,
   output logic [5:0] cnt_val  );
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cnt_val <= 0;
    end
    else begin
      if(cnt_en) cnt_val <= cnt_val + 1;
      else cnt_val <= cnt_val;
    end
  end
endmodule