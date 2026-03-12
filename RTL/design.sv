`include "APB_Master.sv"
`include "APB_Slave.sv"
module APB_Top
  (input logic pCLK, pRSTn,
   input logic TRANS, READ, WRITE,
   input logic [31:0] APB_RADDR, APB_WADDR, APB_WDATA,
   output logic SLV_ERR,
   output logic [255:0] SHA_DATA                     );
  //---------------------------
  //|     MASTER -> SLAVE     |
  //---------------------------
  logic pWRITE, pENABLE;
  logic [1:0] pSEL;
  logic [31:0] pADDR, pWDATA;
  //------------------------------
  //|     SLAVE 0 & 1 SIGNAL     |
  //------------------------------
  logic [31:0] pRDATA_0, pRDATA_1;
  logic pREADY_0, pREADY_1;
  logic pSLVERR_0, pSLVERR_1;
  //------------------------------------
  //|     DE-MUX SIGNAL FOR MASTER     |
  //------------------------------------
  logic [31:0] pRDATA_bus;
  logic pREADY_bus, pSLVERR_bus;
  //      ----- Assign Value -----
  assign pRDATA_bus = (pSEL[0] == 1) ? pRDATA_0 : (pSEL[1] == 1) ? pRDATA_1 : 32'd0;
  assign pREADY_bus = (pSEL[0] == 1) ? pREADY_0 : (pSEL[1] == 1) ? pREADY_1 : 0;
  assign pSLVERR_bus = (pSEL[0] == 1) ? pSLVERR_0 : (pSEL[1] == 1) ? pSLVERR_1 : 0; 
  //------------------------
  //|     MASTER BLOCK     |
  //------------------------
  APB_Master Master(.pCLK(pCLK), .pRSTn(pRSTn),
                    .TRANS(TRANS), .READ(READ), .WRITE(WRITE),
                    .APB_RADDR(APB_RADDR), .APB_WADDR(APB_WADDR), .APB_WDATA(APB_WDATA),
                    .pRDATA(pRDATA_bus), .pREADY(pREADY_bus), .pSLVERR(pSLVERR_bus),
                    .pADDR(pADDR), .pWRITE(pWRITE), .pSEL(pSEL), .pENABLE(pENABLE),
                    .pWDATA(pWDATA), .SLV_ERR(SLV_ERR), .SHA_DATA(SHA_DATA)  );
  //-----------------------
  //|     SLAVE BLOCK     |
  //-----------------------
  //===== SLAVE 0 =====
  APB_Slave Slave0 (.pCLK(pCLK), .pRSTn(pRSTn),
                    .pADDR(pADDR), .pWDATA(pWDATA),
                    .pWRITE(pWRITE), .pSEL(pSEL[0]), .pENABLE(pENABLE),
                    .pRDATA(pRDATA_0), .pREADY(pREADY_0), .pSLVERR(pSLVERR_0));
  //===== SLAVE 1 =====
  APB_Slave Slave1 (.pCLK(pCLK), .pRSTn(pRSTn),
                    .pADDR(pADDR), .pWDATA(pWDATA),
                    .pWRITE(pWRITE), .pSEL(pSEL[1]), .pENABLE(pENABLE),
                    .pRDATA(pRDATA_1), .pREADY(pREADY_1), .pSLVERR(pSLVERR_1));
endmodule