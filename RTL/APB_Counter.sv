module APB_Counter
  (input logic pCLK, pRSTn,
   input logic en,
   output logic [2:0] cnt_val);
  
  logic [2:0] next_val;
  always_ff @(posedge pCLK or negedge pRSTn) begin
    if(!pRSTn) cnt_val <= 0;
    else cnt_val <= next_val;
  end
  
  assign next_val =(en) ? (cnt_val + 1): cnt_val;
endmodule