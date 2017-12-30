`timescale 1 ns / 1 ps

module sting_wrap_v1_0_M01_AXI #
  (
   // Users to add parameters here

   // User parameters ends
   // Do not modify the parameters beyond this line

   // The master will start generating data from the C_M_START_DATA_VALUE value
   parameter  C_M_START_DATA_VALUE	= 32'hAA000000,
   // The master requires a target slave base address.
   // The master will initiate read and write transactions on the slave with base address specified here as a parameter.
   parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
   // Width of M_AXI address bus. 
   // The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
   parameter integer C_M_AXI_ADDR_WIDTH	= 32,
   // Width of M_AXI data bus. 
   // The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
   parameter integer C_M_AXI_DATA_WIDTH	= 32,
   // Transaction number is the number of write 
   // and read transactions the master will perform as a part of this example memory test.
   parameter integer C_M_TRANSACTIONS_NUM	= 4
   )
   (
    // Users to add ports here
    input 				     REG_AXI_RD_WEIGHT_SOFTRESET, // 正論理のソフトリセット
    input [31:0] 			     REG_AXI_RD_WEIGHT_START_ADR1, // 重みデータの先頭アドレス
    input [31:0] 			     REG_AXI_RD_WEIGHT_START_ADR2, // 重みデータの先頭アドレス(BN)
    input 				     REG_BN_EN, //バッチノーマライゼーションのイネーブル。
    input 				     AXI_RD_WEIGHT_START, // 1で動作開始
    input 				     AXI_RD_WEIGHT_NEXT, // 1で動作開始
    output [31:0] 			     AXI_RD_WEIGHT_DATA00, // 重みの出力 weight[0][0], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA01, // 重みの出力 weight[0][1], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA02, // 重みの出力 weight[0][2], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA10, // 重みの出力 weight[1][0], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA11, // 重みの出力 weight[1][1], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA12, // 重みの出力 weight[1][2], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA20, // 重みの出力 weight[2][0], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA21, // 重みの出力 weight[2][1], float32
    output [31:0] 			     AXI_RD_WEIGHT_DATA22, // 重みの出力 weight[2][2], float32
    output [31:0] 			     AXI_RD_WEIGHT_BN0, // BNの重みデータ0, float32
    output [31:0] 			     AXI_RD_WEIGHT_BN1, // BNの重みデータ1, float32
    output 				     AXI_RD_WEIGHT_READY, // 重みの読み出しが終わったことを示す
   
    // User ports ends
    // Do not modify the ports beyond this line

    // Initiate AXI transactions
    input wire 				     INIT_AXI_TXN,
    // Asserts when ERROR is detected
    output  				     ERROR,
    // Asserts when AXI transactions is complete
    output wire 			     TXN_DONE,
    // AXI clock signal
    input wire 				     M_AXI_ACLK,
    // AXI active low reset signal
    input wire 				     M_AXI_ARESETN,
    // Master Interface Write Address Channel ports. Write address (issued by master)
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0]   M_AXI_AWADDR,
    // Write channel Protection type.
    // This signal indicates the privilege and security level of the transaction,
    // and whether the transaction is a data access or an instruction access.
    output wire [2 : 0] 		     M_AXI_AWPROT,
    // Write address valid. 
    // This signal indicates that the master signaling valid write address and control information.
    output wire 			     M_AXI_AWVALID,
    // Write address ready. 
    // This signal indicates that the slave is ready to accept an address and associated control signals.
    input wire 				     M_AXI_AWREADY,
    // Master Interface Write Data Channel ports. Write data (issued by master)
    output wire [C_M_AXI_DATA_WIDTH-1 : 0]   M_AXI_WDATA,
    // Write strobes. 
    // This signal indicates which byte lanes hold valid data.
    // There is one write strobe bit for each eight bits of the write data bus.
    output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
    // Write valid. This signal indicates that valid write data and strobes are available.
    output wire 			     M_AXI_WVALID,
    // Write ready. This signal indicates that the slave can accept the write data.
    input wire 				     M_AXI_WREADY,
    // Master Interface Write Response Channel ports. 
    // This signal indicates the status of the write transaction.
    input wire [1 : 0] 			     M_AXI_BRESP,
    // Write response valid. 
    // This signal indicates that the channel is signaling a valid write response
    input wire 				     M_AXI_BVALID,
    // Response ready. This signal indicates that the master can accept a write response.
    output wire 			     M_AXI_BREADY,
    // Master Interface Read Address Channel ports. Read address (issued by master)
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0]   M_AXI_ARADDR,
    // Protection type. 
    // This signal indicates the privilege and security level of the transaction, 
    // and whether the transaction is a data access or an instruction access.
    output wire [2 : 0] 		     M_AXI_ARPROT,
    // Read address valid. 
    // This signal indicates that the channel is signaling valid read address and control information.
    output wire 			     M_AXI_ARVALID,
    // Read address ready. 
    // This signal indicates that the slave is ready to accept an address and associated control signals.
    input wire 				     M_AXI_ARREADY,
    // Master Interface Read Data Channel ports. Read data (issued by slave)
    input wire [C_M_AXI_DATA_WIDTH-1 : 0]    M_AXI_RDATA,
    // Read response. This signal indicates the status of the read transfer.
    input wire [1 : 0] 			     M_AXI_RRESP,
    // Read valid. This signal indicates that the channel is signaling the required read data.
    input wire 				     M_AXI_RVALID,
    // Read ready. This signal indicates that the master can accept the read data and response information.
    output wire 			     M_AXI_RREADY
    );

   parameter  [7:0] IDLE_ST = 0;
   parameter  [7:0] WRD_ADR0_ST = 1, WRD_DATA0_ST = 2, WRD_END_ST = 3;
   parameter  [7:0] BRD_ADR0_ST = 4, BRD_DATA0_ST = 5, BRD_END_ST = 6, UPDATE_1ST_ST = 7;
   parameter  [7:0] UPDATE_ST = 8, READY_ST = 9, WAIT_NEXT_ST = 10;

   wire 	      reset;
   assign reset = !M_AXI_ARESETN | REG_AXI_RD_WEIGHT_SOFTRESET;
   
   reg [7:0] 	      mst_exec_state;

   // AXI4LITE signals
   reg 				  init_txn_ff;
   reg 				  init_txn_ff2;
   wire 			  init_txn_pulse;

   // I/O Connections assignments

   //Adding the offset address to the base addr of the slave
   assign M_AXI_AWADDR	= 32'h00000000;
   //AXI 4 write data
   assign M_AXI_WDATA	= 32'h00000000;
   assign M_AXI_AWPROT	= 3'b000;
   assign M_AXI_AWVALID	= 1'b0;
   //Write Data(W)
   assign M_AXI_WVALID	= 1'b0;
   //Set all byte strobes in this example
   assign M_AXI_WSTRB	= 4'b1111;
   //Write Response (B)
   assign M_AXI_BREADY	= 1'b0;
   assign ERROR = 0;
   
   assign TXN_DONE	= 0;
   assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;

   //Generate a pulse to initiate AXI transaction.
   always @(posedge M_AXI_ACLK)										      
     begin                                                                        
	// Initiates AXI transaction delay    
	if (reset) begin                                                                    
	   init_txn_ff <= 1'b0;                                                   
	   init_txn_ff2 <= 1'b0;                                                   
	end else begin  
	   init_txn_ff <= INIT_AXI_TXN;
	   init_txn_ff2 <= init_txn_ff;
	end                                                                      
     end     
   
   assign write_resp_error = 0;
   assign read_resp_error = 0;
   
   reg [3:0] rd_cnt;
   reg [31:0] conv_adr;
   reg [31:0] bn_adr;
   reg 	      second_read;
   
   reg [31:0] weight_data00_r;
   reg [31:0] weight_data01_r;
   reg [31:0] weight_data02_r;
   reg [31:0] weight_data10_r;
   reg [31:0] weight_data11_r;
   reg [31:0] weight_data12_r;
   reg [31:0] weight_data20_r;
   reg [31:0] weight_data21_r;
   reg [31:0] weight_data22_r;
   
   reg [31:0] weight_data00_next;
   reg [31:0] weight_data01_next;
   reg [31:0] weight_data02_next;
   reg [31:0] weight_data10_next;
   reg [31:0] weight_data11_next;
   reg [31:0] weight_data12_next;
   reg [31:0] weight_data20_next;
   reg [31:0] weight_data21_next;
   reg [31:0] weight_data22_next;

   reg [31:0] weight_bn0_r;
   reg [31:0] weight_bn1_r;
   reg [31:0] weight_bn0_next;
   reg [31:0] weight_bn1_next;

   reg [31:0] axi_radr;
   reg        axi_ravalid;
   reg        axi_rready;
   reg 	      weight_ready;
   
   //implement master command interface state machine                         
   always @ ( posedge M_AXI_ACLK)
     begin
	if (reset == 1'b1)  begin 
	   mst_exec_state  <= IDLE_ST; 
           rd_cnt <= 0;
	   weight_ready <= 0;
	   second_read <= 0;
	   weight_data00_next <= 0;
	   weight_data01_next <= 0;
	   weight_data02_next <= 0;
	   weight_data10_next <= 0;
	   weight_data11_next <= 0;
	   weight_data12_next <= 0;		     
	   weight_data20_next <= 0;
	   weight_data21_next <= 0;
	   weight_data22_next <= 0;
	   weight_bn0_next <= 0;
	   weight_bn1_next <= 0;
	   
	end else begin
	   case (mst_exec_state)
	     IDLE_ST: begin
		rd_cnt <= 0;
		conv_adr <= REG_AXI_RD_WEIGHT_START_ADR1;
		bn_adr <= REG_AXI_RD_WEIGHT_START_ADR2;
		weight_ready <= 0;
		second_read <= 0;
		if (AXI_RD_WEIGHT_START) begin
		   mst_exec_state <= WRD_ADR0_ST;
		end
	     end
	     WRD_ADR0_ST:begin
		if(M_AXI_ARREADY)begin
		   conv_adr <= conv_adr + 4;
		   mst_exec_state <= WRD_DATA0_ST;
		end
	     end
	     WRD_DATA0_ST:begin
		if(M_AXI_RVALID && axi_rready)begin
		   mst_exec_state <= WRD_END_ST;
		   case(rd_cnt)
		     0:weight_data00_next <= M_AXI_RDATA;
		     1:weight_data01_next <= M_AXI_RDATA;
		     2:weight_data02_next <= M_AXI_RDATA;
		     3:weight_data10_next <= M_AXI_RDATA;
		     4:weight_data11_next <= M_AXI_RDATA;
		     5:weight_data12_next <= M_AXI_RDATA;		     
		     6:weight_data20_next <= M_AXI_RDATA;
		     7:weight_data21_next <= M_AXI_RDATA;
		     default:
		       weight_data22_next <= M_AXI_RDATA;
		   endcase // case (rd_cnt)

		   if(rd_cnt == 8)begin
		      mst_exec_state <= WRD_END_ST;
		   end else begin
		      mst_exec_state <= WRD_ADR0_ST;
		   end
		   
		   rd_cnt <= rd_cnt + 1;		   
		end
	     end
	     WRD_END_ST:begin
		rd_cnt <= 0;
		if(REG_BN_EN == 1)begin
		   mst_exec_state <= BRD_ADR0_ST;
		end else begin
		   if(second_read==1)begin
		      mst_exec_state <= READY_ST;
		   end else begin
		      mst_exec_state <= UPDATE_1ST_ST;
		   end
		end		  
 	     end
	     BRD_ADR0_ST:begin
		if(M_AXI_ARREADY)begin
		   bn_adr <= bn_adr + 4;
		   mst_exec_state <= BRD_DATA0_ST;
		end
	     end
	     BRD_DATA0_ST:begin
		if(M_AXI_RVALID && axi_rready)begin
		   mst_exec_state <= WRD_END_ST;
		   if(rd_cnt == 0)begin
		      weight_bn0_next <= M_AXI_RDATA;
		   end else begin
		      weight_bn1_next <= M_AXI_RDATA;
		   end
		   
		   if(rd_cnt == 1)begin
		      mst_exec_state <= BRD_END_ST;
		   end else begin
		      mst_exec_state <= BRD_ADR0_ST;
		   end
		   rd_cnt <= rd_cnt + 1;		   
		end
	     end // case: WRD_DATA0_ST

	     BRD_END_ST:begin
		rd_cnt <= 0;
		if(second_read==1)begin
		   mst_exec_state <= READY_ST;
		end else begin
		   mst_exec_state <= UPDATE_1ST_ST;
		end
		
	     end

	     UPDATE_1ST_ST:begin
		second_read <= 1;
		mst_exec_state <= WRD_ADR0_ST;
	     end
		

	     READY_ST:begin
		weight_ready <= 1;
		mst_exec_state <= WAIT_NEXT_ST;
	     end

	     WAIT_NEXT_ST:
	       if(AXI_RD_WEIGHT_NEXT == 1)begin
		  weight_ready <= 0;
		  mst_exec_state <= UPDATE_ST;
	       end
	     
	     UPDATE_ST:begin
		mst_exec_state <= WRD_ADR0_ST;
	     end

	     
	     default :
	       begin 
	          mst_exec_state  <= IDLE_ST;                                     
	       end 
	   endcase // case (mst_exec_state)
	   
	end // else: !if(reset == 1'b1)
     end // always @ ( posedge M_AXI_ACLK)
      
   //axiのアドレスとVALID出力
   always @ ( posedge M_AXI_ACLK) begin
      if (reset == 1'b1)  begin 
	 axi_ravalid <= 0;
	 axi_radr <= 0;
      end else begin
	   case (mst_exec_state)
	     WRD_ADR0_ST: begin
		if(M_AXI_ARREADY && axi_ravalid)begin
		   //アドレスが有効なときにREADYがHになれば、validを下げる。
		   axi_ravalid <= 0;
		end else begin
		   //リードリクエスト
		   axi_ravalid <= 1;
		   axi_radr <= conv_adr;
		end
	     end
	     BRD_ADR0_ST:begin
		if(M_AXI_ARREADY && axi_ravalid)begin
		   //アドレスが有効なときにREADYがHになれば、validを下げる。
		   axi_ravalid <= 0;
		end else begin
		   //リードリクエスト
		   axi_ravalid <= 1;
		   axi_radr <= bn_adr;
		end
	     end
	     default: begin
		axi_ravalid <= 0;
	     end
	   endcase // case (mst_exec_state)
      end
   end // always @ ( posedge M_AXI_ACLK)


   //axiのread valid制御
   always @ ( posedge M_AXI_ACLK) begin
      if (reset == 1'b1)  begin 
	 axi_rready <= 0;
      end else begin
	 if ((mst_exec_state == WRD_DATA0_ST) || (mst_exec_state == BRD_DATA0_ST)) begin
	    if((M_AXI_RVALID == 1'b1) && (axi_rready == 0))begin
	       axi_rready <= 1;
	    end else begin
	       axi_rready <= 0;
	    end
	 end else begin
	    axi_rready<= 0;
	 end
      end
   end

   //出力するデータの更新
   always @ ( posedge M_AXI_ACLK) begin
      if (reset == 1'b1)  begin
	 weight_data00_r <= 0;
	 weight_data01_r <= 0;
	 weight_data02_r <= 0;
	 weight_data10_r <= 0;
	 weight_data11_r <= 0;
	 weight_data12_r <= 0;
	 weight_data20_r <= 0;
	 weight_data21_r <= 0;
	 weight_data22_r <= 0;
	 weight_bn0_r <= 0;
	 weight_bn1_r <= 0;
      end else if((mst_exec_state==UPDATE_1ST_ST) || (mst_exec_state == UPDATE_ST))begin // if (reset == 1'b1)
	 weight_data00_r <= weight_data00_next;
	 weight_data01_r <= weight_data01_next;
	 weight_data02_r <= weight_data02_next;
	 weight_data10_r <= weight_data10_next;
	 weight_data11_r <= weight_data11_next;
	 weight_data12_r <= weight_data12_next;
	 weight_data20_r <= weight_data20_next;
	 weight_data21_r <= weight_data21_next;
	 weight_data22_r <= weight_data22_next;
	 weight_bn0_r <= weight_bn0_next;
	 weight_bn1_r <= weight_bn1_next;
      end
   end
   
   assign AXI_RD_WEIGHT_READY = weight_ready;

   assign M_AXI_ARADDR = axi_radr;
   assign M_AXI_ARVALID = axi_ravalid;
   assign M_AXI_ARPROT = 3'b001;
   assign M_AXI_RREADY = axi_rready;
   
   assign AXI_RD_WEIGHT_DATA00 = weight_data00_r;
   assign AXI_RD_WEIGHT_DATA01 = weight_data01_r;
   assign AXI_RD_WEIGHT_DATA02 = weight_data02_r;
   assign AXI_RD_WEIGHT_DATA10 = weight_data10_r;
   assign AXI_RD_WEIGHT_DATA11 = weight_data11_r;
   assign AXI_RD_WEIGHT_DATA12 = weight_data12_r;
   assign AXI_RD_WEIGHT_DATA20 = weight_data20_r;
   assign AXI_RD_WEIGHT_DATA21 = weight_data21_r;
   assign AXI_RD_WEIGHT_DATA22 = weight_data22_r;
   assign AXI_RD_WEIGHT_BN0 = weight_bn0_r;
   assign AXI_RD_WEIGHT_BN1 = weight_bn1_r;
   
   // User logic ends

endmodule
