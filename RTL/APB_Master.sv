// Code your design here
module APB_Master
        (input logic pCLK,
         input logic pRSTn,
         input logic TRANS, READ, WRITE,
         input logic [31:0] APB_WADDR,
         input logic [31:0] APB_WDATA,
         input logic [31:0] APB_RADDR,
         input logic [31:0] pRDATA,
         input logic pREADY,
         input logic pSLVERR,
         // OUTPUT
         output logic [31:0] pADDR,
         output logic [31:0] pWDATA,
         output logic [255:0] SHA_DATA,
         output logic pWRITE,
         output logic [1:0] pSEL,
         output logic pENABLE,
	 	 output logic SLV_ERR                    );

  localparam state_length = 2;
  typedef enum logic [state_length-1: 0] {
    IDLE, SETUP, ACCESS
  } state;
  state current_state;
  state next_state;
  logic trans_d;
  //------------------------
  //|    STATE REGISTER    |
  //------------------------
  always_ff @(posedge pCLK or negedge pRSTn) begin
    if(!pRSTn) begin
      current_state <= IDLE;
      trans_d <= 0;
    end
    else begin
      current_state <= next_state;
      trans_d <= TRANS;
    end
  end
  //----------------------------------------
  //|    NEXT STATE COMBINATIONAL LOGIC    |
  //----------------------------------------
  always_comb begin
    case(current_state)
      IDLE: begin
        if (trans_d) next_state = SETUP;
        else next_state = current_state;
      end
      SETUP: next_state = ACCESS;
      ACCESS: begin
        if(!pREADY) next_state = ACCESS;
        else begin
          if (trans_d) next_state = SETUP;
          else next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end
  //------------------------------------
  //|    OUTPUT COMBINATIONAL LOGIC    |
  //------------------------------------
  always_comb begin
    case(current_state)
      IDLE: begin
		pSEL = 2'b00;
		pADDR = 0;
		pWRITE = 0;
		pENABLE = 0;
		pWDATA = 0;
      end
      SETUP: begin
		pENABLE = 0;
		if (WRITE & !READ) begin //WRITE Mode
	  		pWRITE = 1;
	  		pADDR = APB_WADDR;
	  		pWDATA = APB_WDATA;
	  		//Slave Choose
	  		pSEL[0] = (APB_WADDR[31] == 0); // Choose Slave 0
	  		pSEL[1] = (APB_WADDR[31] == 1); // Choose Slave 1
		end
		else if (!WRITE & READ) begin //READ Mode
	  		pWRITE = 0;
	  		pADDR = APB_RADDR;
	  		pWDATA = 0;
	  		//Slave Choose
	  		pSEL[0] = (APB_RADDR[31] == 0); //Choose Slave 0
	  		pSEL[1] = (APB_RADDR[31] == 1); //Choose Slave 1
		end
		else begin
	  		pADDR = 0;
	  		pWRITE = 0;
	  		pSEL = 2'b00;
	  		pWDATA = 0;
		end
      end
      ACCESS: begin
		pENABLE = 1;
      end
      default: begin
		pENABLE = 0;
		pWRITE = 0;
		pSEL = 2'b00;
		pADDR = 0;
		pWDATA = 0;
      end
    endcase
  end
  //---------------------
  //|    SLAVE ERROR    |
  //---------------------
  assign SLV_ERR = pSLVERR;
  //---------------------
  //|    SHA_DATA       |
  //---------------------
  logic [31:0] H0, H1, H2, H3, H4, H5, H6, H7;
  logic [31:0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7;
  always_ff @(posedge pCLK or negedge pRSTn) begin
    if (!pRSTn) begin
      H0 <= 0;
      H1 <= 0;
      H2 <= 0;
      H3 <= 0;
      H4 <= 0;
      H5 <= 0;
      H6 <= 0;
      H7 <= 0;
      
    end
    else begin
      if(pENABLE & ~pWRITE & ~pSLVERR) begin
        H0 <= out_0;
        H1 <= H0;
        H2 <= H1;
        H3 <= H2;
        H4 <= H3;
        H5 <= H4;
        H6 <= H5;
        H7 <= H6;
      end
      else begin
        H0 <= 0;
      	H1 <= 0;
      	H2 <= 0;
      	H3 <= 0;
      	H4 <= 0;
      	H5 <= 0;
      	H6 <= 0;
      	H7 <= 0;
      end
    end
  end
  
  assign out_0 = (pENABLE & READ & ~pSLVERR) ? pRDATA : 0;
  assign out_1 = (pENABLE & READ & ~pSLVERR) ? H0 : 0;
  assign out_2 = (pENABLE & READ & ~pSLVERR) ? H1 : 0;
  assign out_3 = (pENABLE & READ & ~pSLVERR) ? H2 : 0;
  assign out_4 = (pENABLE & READ & ~pSLVERR) ? H3 : 0;
  assign out_5 = (pENABLE & READ & ~pSLVERR) ? H4 : 0;
  assign out_6 = (pENABLE & READ & ~pSLVERR) ? H5 : 0;
  assign out_7 = (pENABLE & READ & ~pSLVERR) ? H6 : 0;
  
  assign SHA_DATA = (pREADY) ? {out_7, out_6, out_5, out_4, out_3, out_2, out_1, out_0} : 0;
  
endmodule
