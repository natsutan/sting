
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
    output reg 				     ERROR,
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

   // function called clogb2 that returns an integer which has the
   // value of the ceiling of the log base 2

   function integer clogb2 (input integer bit_depth);
      begin
	 for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	   bit_depth = bit_depth >> 1;
      end
   endfunction

   // TRANS_NUM_BITS is the width of the index counter for 
   // number of write or read transaction.
   localparam integer TRANS_NUM_BITS = clogb2(C_M_TRANSACTIONS_NUM-1);

   // Example State machine to initialize counter, initialize write transactions, 
   // initialize read transactions and comparison of read data with the 
   // written data words.
   parameter  [7:0] IDLE_ST = 0;
   parameter  [7:0] WRD_ADR0_ST = 1, WRD_DATA0_ST = 2, WRD_END_ST = 3;
   parameter  [7:0] READY_ST = 30;


   wire 	      reset;
   assign reset = !M_AXI_ARESETN & REG_AXI_RD_WEIGHT_SOFTRESET;
   
   
   reg [7:0] 	      mst_exec_state;

   // AXI4LITE signals
   //write address valid
   reg 		      axi_awvalid;
   //write data valid
   reg 		      axi_wvalid;
   //read address valid
   reg 		      axi_arvalid;
   //write response acceptance
   reg 		      axi_bready;
   //write address
   reg [C_M_AXI_ADDR_WIDTH-1 : 0] axi_awaddr;
   //write data
   reg [C_M_AXI_DATA_WIDTH-1 : 0] axi_wdata;
   //read addresss
   reg [C_M_AXI_ADDR_WIDTH-1 : 0] axi_araddr;
   //Asserts when there is a write response error
   wire 			  write_resp_error;
   //Asserts when there is a read response error
   wire 			  read_resp_error;
   //A pulse to initiate a write transaction
   reg 				  start_single_write;
   //A pulse to initiate a read transaction
   reg 				  start_single_read;
   //Asserts when a single beat write transaction is issued and remains asserted till the completion of write trasaction.
   reg 				  write_issued;
   //Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
   reg 				  read_issued;
   //flag that marks the completion of write trasactions. The number of write transaction is user selected by the parameter C_M_TRANSACTIONS_NUM.
   reg 				  writes_done;
   //flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
   reg 				  reads_done;
   //The error register is asserted when any of the write response error, read response error or the data mismatch flags are asserted.
   reg 				  error_reg;
   //index counter to track the number of write transaction issued
   reg [TRANS_NUM_BITS : 0] 	  write_index;
   //index counter to track the number of read transaction issued
   reg [TRANS_NUM_BITS : 0] 	  read_index;
   //Expected read data used to compare with the read data.
   reg [C_M_AXI_DATA_WIDTH-1 : 0] expected_rdata;
   //Flag marks the completion of comparison of the read data with the expected read data
   reg 				  compare_done;
   //This flag is asserted when there is a mismatch of the read data with the expected read data.
   reg 				  read_mismatch;
   //Flag is asserted when the write index reaches the last write transction number
   reg 				  last_write;
   //Flag is asserted when the read index reaches the last read transction number
   reg 				  last_read;
   reg 				  init_txn_ff;
   reg 				  init_txn_ff2;
   reg 				  init_txn_edge;
   wire 			  init_txn_pulse;


   // I/O Connections assignments

   //Adding the offset address to the base addr of the slave
   assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
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

   assign TXN_DONE	= compare_done;
   assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;


   //Generate a pulse to initiate AXI transaction.
   always @(posedge M_AXI_ACLK)										      
     begin                                                                        
	// Initiates AXI transaction delay    
	if (reset )                                                   
	  begin                                                                    
	     init_txn_ff <= 1'b0;                                                   
	     init_txn_ff2 <= 1'b0;                                                   
	  end                                                                               
	else                                                                       
	  begin  
	     init_txn_ff <= INIT_AXI_TXN;
	     init_txn_ff2 <= init_txn_ff;                                                                 
	  end                                                                      
     end     


   //--------------------
   //Write Address Channel
   //--------------------
   // 不要なので削除
   assign write_resp_error = 0;


   //----------------------------
   //Read Address Channel
   //----------------------------

   // A new axi_arvalid is asserted when there is a valid read address              
   // available by the master. start_single_read triggers a new read                
   // transaction                                                                   
   always @(posedge M_AXI_ACLK)                                                     
     begin                                                                            
	if (reset == 1'b1 || init_txn_pulse == 1'b1)                                                       
	  begin                                                                        
	     axi_arvalid <= 1'b0;                                                       
	  end                                                                          
	//Signal a new read address command is available by user logic                 
	else if (start_single_read)                                                    
	  begin                                                                        
	     axi_arvalid <= 1'b1;                                                       
	  end                                                                          
	//RAddress accepted by interconnect/slave (issue of M_AXI_ARREADY by slave)    
	else if (M_AXI_ARREADY && axi_arvalid)                                         
	  begin                                                                        
	     axi_arvalid <= 1'b0;                                                       
	  end                                                                          
	// retain the previous value                                                   
     end                                                                              


   //--------------------------------
   //Read Data (and Response) Channel
   //--------------------------------

   //The Read Data channel returns the results of the read request 
   //The master will accept the read data by asserting axi_rready
   //when there is a valid read data available.
   //While not necessary per spec, it is advisable to reset READY signals in
   //case of differing reset latencies between master/slave.

   always @(posedge M_AXI_ACLK)                                    
     begin                                                                 
	if (reset == 1'b1 || init_txn_pulse == 1'b1)                                            
	  begin                                                             
	     axi_rready <= 1'b0;                                             
	  end                                                               
	// accept/acknowledge rdata/rresp with axi_rready by the master     
	// when M_AXI_RVALID is asserted by slave                           
	else if (M_AXI_RVALID && ~axi_rready)                               
	  begin                                                             
	     axi_rready <= 1'b1;                                             
	  end                                                               
	// deassert after one clock cycle                                   
	else if (axi_rready)                                                
	  begin                                                             
	     axi_rready <= 1'b0;                                             
	  end                                                               
	// retain the previous value                                        
     end                                                                   
   
   //Flag write errors                                                     
   assign read_resp_error = (axi_rready & M_AXI_RVALID & M_AXI_RRESP[1]);  


   //--------------------------------
   //User Logic
   //--------------------------------

   //Address/Data Stimulus

   //Address/data pairs for this example. The read and write values should
   //match.
   //Modify these as desired for different address patterns.

   
   //Read Addresses                                              
   always @(posedge M_AXI_ACLK)                                  
     begin                                                     
	if (reset == 1'b1  || init_txn_pulse == 1'b1)                                
	  begin                                                 
	     axi_araddr <= 0;                                    
	  end                                                   
	// Signals a new write address/ write data is         
	// available by user logic                            
	else if (M_AXI_ARREADY && axi_arvalid)                  
	  begin                                                 
	     axi_araddr <= axi_araddr + 32'h00000004;            
	  end                                                   
     end                                                       
   
   
   
   always @(posedge M_AXI_ACLK)                                  
     begin                                                     
	if (M_AXI_ARESETN == 0  || init_txn_pulse == 1'b1)                                
	  begin                                                 
	     expected_rdata <= C_M_START_DATA_VALUE;             
	  end                                                   
	// Signals a new write address/ write data is         
	// available by user logic                            
	else if (M_AXI_RVALID && axi_rready)                    
	  begin                                                 
	     expected_rdata <= C_M_START_DATA_VALUE + read_index;
	  end                                                   
     end                                                       

   reg [3:0] rd_cnt;
   reg [31:0] conv_adr;
   reg [31:0] bn_adr;
   reg 	      ready;
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
		if(M_AXI_ARREADY)begin
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
	 if (mst_exec_state == WRD_DATA0_ST)begin
	    if(M_AXI_ARREADY)begin
	       axi_rready <= 1;
	    end else begin
	       axi_rready <= 0;
	    end
	 end else begin
	    axi_rready<= 0;
	 end
      end
   end
   
   

   assign AXI_RD_WEIGHT_READY = weight_ready;

   assign M_AXI_ARADDR = axi_radr;
   assign M_AXI_ARVALID = axi_arvalid;
   assign M_AXI_ARPROT = 3'b001;
   assign M_AXI_RREADY = axi_rready;
   

   // User logic ends

endmodule
