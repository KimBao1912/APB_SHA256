`include "APB_Counter.sv"
`include "APB_RegFile"
`include "SHA.sv"
module APB_Slave
  (input logic pCLK, pRSTn,
   input logic [31:0] pADDR, pWDATA,
   input logic pWRITE, pSEL, pENABLE,
   output logic [31:0] pRDATA,
   output logic pREADY, pSLVERR      );
  logic slave_access;
  logic hash_en;
  logic cnt_en;
  logic READ_en;
  logic WRITE_en;
  logic hash_finish;
  logic [255:0] hash_data;
  logic [255:0] dataOut;
  logic [31:0] Hn;
  logic [2:0] cnt_val;
  assign slave_access = pSEL & (pADDR[30:0] < 65536);
  assign hash_en = slave_access & pWRITE & pENABLE;
  assign WRITE_en = slave_access & pWRITE & hash_finish;
  assign READ_en = slave_access & ~pWRITE;
  assign cnt_en = ~pWRITE & pENABLE;
  
//   always_ff @(posedge pCLK) begin
//     cnt_en <= READ_en;
//   end
  //-----------------------
  //|        SHA          |
  //-----------------------
  SHA sha (.clk(pCLK), .rst_n(pRSTn), .data_in(pWDATA), .en(hash_en), .hash_data(hash_data), .finish(hash_finish));
  //-----------------------
  //       REG_FILE       |
  //-----------------------
  APB_RegFile regfile(.pCLK(pCLK), .pRSTn(pRSTn), .ADDR(pADDR[30:0]), .pWDATA(hash_data), .READ_en(READ_en), .WRITE_en(WRITE_en), .pRDATA(dataOut));
  always_comb begin
    case (cnt_val)
      3'd0: Hn = dataOut[255:224];
      3'd1: Hn = dataOut[223:192];
      3'd2: Hn = dataOut[191:160];
      3'd3: Hn = dataOut[159:128];
      3'd4: Hn = dataOut[127:96];
      3'd5: Hn = dataOut[95:64];
      3'd6: Hn = dataOut[63:32];
      3'd7: Hn = dataOut[31:0];
      default: Hn = 0;
    endcase
  end
  assign pRDATA = READ_en ? Hn : 0;
  //-----------------------
  //|     COUNTER         |
  //-----------------------
  APB_Counter count(.pCLK(pCLK), .pRSTn(pRSTn), .en(cnt_en), .cnt_val(cnt_val));
  //-----------------------
  //|     SLAVE ERROR     |
  //-----------------------
  always_ff @(posedge pCLK or negedge pRSTn) begin
    if(!pRSTn) pSLVERR <= 0;
    else pSLVERR <= ~(pADDR[30:0] < 65536);
  end
  //----------------------
  //|     pREADY         |
  //----------------------
  assign pREADY = hash_finish | (cnt_val == 3'd7) | pSLVERR;
endmodule