
module controller
  (input logic clk, rst_n,
   input logic en,
   output logic [5:0] cnt_val,
   output logic sel, finish, process, compress);
  logic cnt_en;
  logic fsm_en;
  logic cnt_finish;
  FSM fsm (.clk(clk), .rst_n(rst_n), .en(fsm_en), .cnt_finish(cnt_finish), .cnt_en(cnt_en), .process(process));
  counter count(.clk(clk), .rst_n(rst_n), .cnt_en(cnt_en), .cnt_val(cnt_val));
  
  assign sel = (cnt_val > 15);
  assign cnt_finish = &(cnt_val);
  always_ff @(posedge clk) begin
    fsm_en <= en;
  end
  assign compress = (process);
  assign finish = cnt_finish;
endmodule