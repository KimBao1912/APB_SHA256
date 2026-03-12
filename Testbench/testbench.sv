// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module APB_Top_tb;

    // Input signals (reg)
    logic         pCLK;
    logic         pRSTn;
    logic         TRANS;
    logic         READ;
    logic         WRITE;
    logic [31:0]  APB_WADDR;
    logic [31:0]  APB_WDATA;
    logic [31:0]  APB_RADDR;

    // Output signals (wire)
  logic [255:0] SHA_DATA;
    logic        SLV_ERR;

    // Unit Under Test (UUT)
    APB_Top uut (
      .pCLK(pCLK),
      .pRSTn(pRSTn),
      .TRANS(TRANS),
      .READ(READ),
      .WRITE(WRITE),
      .APB_WADDR(APB_WADDR),
      .APB_WDATA(APB_WDATA),
      .APB_RADDR(APB_RADDR),
      .SHA_DATA(SHA_DATA),
      .SLV_ERR(SLV_ERR)
    );

    // Clock generation (10ns period -> 100MHz)
    initial begin
        pCLK = 0;
        forever #5 pCLK = ~pCLK;
    end

    // Task for APB Write Transaction
    task apb_write(input [31:0] addr, input [31:0] data);
    begin
      @(posedge pCLK);
      TRANS = 1; 
      WRITE = 1;
      READ  = 0;
      APB_WADDR = addr;
      APB_WDATA  = data;  
      @(posedge pCLK); 
      TRANS = 0;         
      wait(uut.Master.current_state == 2'b10); 
      @(posedge pCLK);
      // Vòng lặp chờ PREADY (Xử lý Waiting States)
      while (!uut.pREADY_bus) begin
        $display("  [WAITING] Slave is not ready at Time=%0t", $time);
        @(posedge pCLK);
      end  
      $display("[WRITE] Addr: 0x%h | Data: 0x%h | PSLVERR: %b | Time: %0t", addr, data, SLV_ERR, $time);
      WRITE = 0;
    end
    endtask

    // Task for APB Read Transaction
    task apb_read(input [31:0] addr);
    begin
      @(posedge pCLK);
      TRANS = 1;
      WRITE = 0;
      READ  = 1;
      APB_RADDR = addr;
      @(posedge pCLK);
      TRANS = 0;
      wait(uut.Master.current_state == 2'b10);
      @(posedge pCLK);  
      while (!uut.pREADY_bus) begin
        $display("  [WAITING] Slave is not ready at Time=%0t", $time);
        @(posedge pCLK);
      end
      $display("[READ]  Addr: 0x%h | Data: 0x%h | PSLVERR: %b | Time: %0t", addr, SHA_DATA, SLV_ERR, $time);
        READ = 0;
    end
    endtask

    // Test Scenarios
    initial begin
      $dumpfile("dump.vcd"); $dumpvars(0);
        
        // Initialize signals
        pRSTn = 0;
        TRANS = 0;
        READ = 0;
        WRITE = 0;
        APB_WADDR = 0;
        APB_WDATA = 0;
        APB_RADDR = 0;

        // Release Reset
        #20 pRSTn = 1;
        #10;

        $display("--- Starting Testcase 1: Slave 0 Access (MSB=0) ---");
      apb_write(32'h0000_0008, 32'h24681357); // Addr 8 (Wait=0)
        #20
        apb_read(32'h0000_0008);                

        $display("\n--- Starting Testcase 2: Slave 1 Access (MSB=1) ---");
        #20
      apb_write(32'h8000_0004, 32'h1234abcd); // Addr 4 (Wait=0)
        #20
        apb_read(32'h8000_0004);                

        $display("\n--- Starting Testcase 3: Address Range Error ---");
        #20
      apb_write(32'h0001_0000, 32'h01234567); 
        #20
      apb_read(32'h0001_0000);
      $display("\n--- Starting Testcase 4: Empty Addr ---");
        #20
      apb_read(32'h0000_0001);
        // Test
		#10 pRSTn = 0;
        #10;
        $display("\n--- Simulation Finished ---");
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | State=%b | PSEL=%b | PADDR=%h | PWRITE=%b | PREADY=%b", 
                 $time, uut.Master.current_state, uut.pSEL, uut.pADDR, uut.pWRITE, uut.pREADY_bus);
    end

endmodule