
module expansion
  (input logic clk, rst_n,
   input logic sel, process,
   input logic [5:0] cnt_val,
   input logic [511:0] M,
   output logic [31:0] Wt    );
  
  logic [31:0] mux_out, add_out, lsigma0_out, lsigma1_out;
  logic [31:0] Mt;
  logic [31:0] mem [0:15];
  logic [31:0] a0, a1, a9, a14;
  logic [31:0] Mt_in;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      for (int i = 0; i < 16; i++) begin
        mem[i] <= 0;
      end
    end
    else begin
      mem[0] <= mem[1];
      mem[1] <= mem[2];
      mem[2] <= mem[3];
      mem[3] <= mem[4];
      mem[4] <= mem[5];
      mem[5] <= mem[6];
      mem[6] <= mem[7];
      mem[7] <= mem[8];
      mem[8] <= mem[9];
      mem[9] <= mem[10];
      mem[10] <= mem[11];
      mem[11] <= mem[12];
      mem[12] <= mem[13];
      mem[13] <= mem[14];
      mem[14] <= mem[15];
      mem[15] <= mux_out;
    end
  end
  assign a0 = mem[0]; // t - 16
  assign a1 = mem[1]; // t - 15
  assign a9 = mem[9]; // t - 7
  assign a14 = mem[14]; // t- 2
  // Mt (0 <= t <= 15)
  always_comb begin
    case (cnt_val)
      6'd0: Mt = M[511:480];
      6'd1: Mt = M[479:448];
      6'd2: Mt = M[447:416];
      6'd3: Mt = M[415:384];
      6'd4: Mt = M[383:352];
      6'd5: Mt = M[351:320];
      6'd6: Mt = M[319:288];
      6'd7: Mt = M[287:256];
      6'd8: Mt = M[255:224];
      6'd9: Mt = M[223:192];
      6'd10: Mt = M[191:160];
      6'd11: Mt = M[159:128];
      6'd12: Mt = M[127:96];
      6'd13: Mt = M[95:64];
      6'd14: Mt = M[63:32];
      6'd15: Mt = M[31:0];
    endcase
  end
  assign Mt_in = (process) ? Mt : 0;
  assign mux_out = (sel) ? add_out : Mt_in;
  //16 <= t <= 63
  lsigma0 l0 (.in(a1), .out(lsigma0_out));
  lsigma1 l1 (.in(a14), .out(lsigma1_out));
  assign add_out = a0 + lsigma0_out + a9 + lsigma1_out;
  //OUTPUT
  assign Wt = mux_out;
  
endmodule
