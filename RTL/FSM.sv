module FSM
  (input logic clk, rst_n,
   input logic en, cnt_finish,
   output logic cnt_en, process);
  typedef enum logic {IDLE, COUNT} state;
  state current_state;
  state next_state;
  
  //----- STATE REGISTER -----
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) current_state <= IDLE;
    else current_state <= next_state;
  end
  //----- NEXT STATE LOGIC -----
  always_comb begin
    case(current_state)
      IDLE: begin
        if(en) next_state = COUNT;
        else next_state = current_state;
      end
      COUNT: begin
        if(cnt_finish) next_state = IDLE;
        else next_state = current_state;
      end
    endcase
  end
  //----- OUTPUT LOGIC -----
  assign cnt_en = (current_state == COUNT);
  assign process = (current_state == COUNT);
endmodule