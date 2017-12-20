`timescale 1ns/1ps

import axi_vip_v1_0_2_pkg::*;
import design_1_axi_vip_0_1_pkg::*;
import design_1_axi_vip_2_0_pkg::*;

`include "sting_reg.h"
`include "setting.h"
    
module tb_top();

    localparam int LP_CLK_PERI = 10;
    localparam int LP_RST_PERI = 50;

    // DUT instance
   logic 	   aresetn, aclk;
   logic 	   axi_init;
   wire 	   irq;
   integer 	   rd_data;
   
 
   design_1 design_1
     (
      .aclk(aclk),
      .aresetn(aresetn),
      .init_axi_txn(axi_init),
      .irq(irq));
    
   task rst_gen();
      aresetn = '0;
      axi_init = '1;
      #(LP_RST_PERI);
      axi_init = '0;
      aresetn = '1;
   endtask
   
   task clk_gen();
      aclk = '0;
      forever #(LP_CLK_PERI/2) aclk = ~aclk;
   endtask

   task clk_dly(int n);
      repeat(n) @(posedge aclk);
   endtask
   
   // VIP decreation
   design_1_axi_vip_0_1_mst_t cpu;
   design_1_axi_vip_2_0_slv_mem_t dram_w;
   

  /*************************************************************************************************
  * Task user_gen_wready shows how slave VIP agent generates one customerized wready signal. 
  * declare axi_ready_gen  wready_gen
  * call create_ready from agent's write driver to create a new class of axi_ready_gen 
  * set the poicy of ready generation in this example, it select XIL_AXI_READY_GEN_OSC 
  * set low time 
  * set high time
  * agent's write driver send_wready out
  * ready generation policy are listed below:
  *   XIL_AXI_READY_GEN_SINGLE             - Ready stays 0 for low_time clock cycles and then
                                             dirves 1 until one ready/valid handshake occurs,
                                             the policy repeats until the channel is given
                                             different policy.
  *   XIL_AXI_READY_GEN_EVENTS             - Ready stays 0 for low_time clock cycles and then
                                             dirves 1 until event_count ready/valid handshakes
                                             occur,the policy repeats until the channel is given
                                             different policy.
  *   XIL_AXI_READY_GEN_OSC                - Ready stays 0 for low_time and then goes to 1 and      
                                             stays 1 for high_time,the policy repeats until the
                                             channel is given different policy.
  *   XIL_AXI_READY_GEN_RANDOM             - This policy generate random ready policy and uses
                                             min/max pair of low_time, high_time and event_count to
                                             generate low_time, high_time and event_count.
  *   XIL_AXI_READY_GEN_AFTER_VALID_SINGLE - This policy is active when VALID is detected to be
                                             asserted, Ready stays 0 for low_time clock cycles and
                                             then dirves 1 until one ready/valid handshake occurs,
                                             the policy repeats until the channel is given
                                             different policy.
  *   XIL_AXI_READY_GEN_AFTER_VALID_EVENTS - This policy is active when VALID is detected to be
                                             asserted, Ready stays 0 for low_time clock cycles and
                                             then dirves 1 until event_count ready/valid handshake
                                             occurs,the policy repeats until the channel is given
                                             different policy.
  *   XIL_AXI_READY_GEN_AFTER_VALID_OSC    - This policy is active when VALID is detected to be
                                             asserted, Ready stays 0 for low_time and then goes to
                                             1 and  stays 1 for high_time,the policy repeats until
                                             the channel is given different policy.
  *************************************************************************************************/
  task user_gen_wready();
     axi_ready_gen                           wready_gen;
     wready_gen = dram_w.wr_driver.create_ready("wready");
     wready_gen.set_ready_policy(XIL_AXI_READY_GEN_OSC);
     wready_gen.set_low_time(1);
     wready_gen.set_high_time(2);
     dram_w.wr_driver.send_wready(wready_gen);
  endtask

   
  /*************************************************************************************************
  * Task backdoor_mem_write shows how user can do backdoor write to memory model
  * Declare default fill in value  mem_fill_payload according to DATA WIDTH
  * Declare backdoor memory write address
  * Declare backdoor memory write payload according to DATA WIDTH
  * Declare backdoor memory write strobe
  * Delcare Address offset
  * Set default memory fill policy to be fixed
  * Randmoize memory fill value 
  * Set default memory value 
  * Randomize memory write address
  * Randomize memory write payload
  * Randomize memory write strobe
  * Calculate address offset
  * Make lower bytes strobe are off when address is not aligned address
  * Write data to memory model  
  *************************************************************************************************/

  task backdoor_mem_write();
    bit[32-1:0]              mem_fill_payload;
    bit[32-1:0]             mem_wr_addr;
    bit[32-1:0]              write_data;
    bit[(32/8)-1:0]          write_strb;
    xil_axi_ulong                           addr_offset;

    dram_w.mem_model.set_memory_fill_policy(XIL_AXI_MEMORY_FILL_FIXED);
    MEM_FILL_PAYLOAD_FAIL: assert(std::randomize(mem_fill_payload));
    dram_w.mem_model.set_default_memory_value(mem_fill_payload);
    WRITE_ADDR_FAIL: assert(std::randomize(mem_wr_addr));
    WRITE_DATA_FAIL: assert(std::randomize(write_data)); 
    WRITE_STRB_FAIL: assert(std::randomize(write_strb));
    addr_offset = mem_wr_addr & ((1 << ($clog2(32/8)))-1);
    write_strb = (write_strb <<addr_offset);



    dram_w.mem_model.backdoor_memory_write(mem_wr_addr, write_data, write_strb);
  endtask

  task backdoor_mem_write_from_file(input string fname, input bit[31:0] adr);
     integer fd;
     

     bit [32-1:0] write_data;
     integer 	  offset;

     fd = $fopen(fname, "rb");
     if (fd == 0) begin
	$display("Error can't open %s", fname);
     end else begin
	$display("open %s", fname);
     end

     offset = 0;
     while (!$feof(fd)) begin
	$fread(write_data, fd, offset, 4);
	dram_w.mem_model.backdoor_memory_write(adr+offset, write_data, 4'b1111);
	offset += 4;
	
     end

     $fclose(fd);
     
  endtask



   
  /*************************************************************************************************
  * Task backdoor_mem_read shows how user can do backdoor read data from memory model
  * Declare backdoor memory read address
  * Declare backdoor memory read data according to DATA WIDTH
  * Randomize memory read address
  * Read data from memory model 
  *************************************************************************************************/
  task backdoor_mem_read();
    bit[32-1:0]             mem_rd_addr;
    bit[32-1:0]              read_data;
    READ_ADDR_FAIL: assert(std::randomize(mem_rd_addr));
    read_data= dram_w.mem_model.backdoor_memory_read(mem_rd_addr);
  endtask
   
   initial begin 
      cpu = new("design_1_axi_vip_0_1_mst", tb_top.design_1.axi_vip_0.inst.IF);
      cpu.start_master();
      dram_w = new("design_1_axi_vip_2_0_slv_mem", tb_top.design_1.axi_vip_2.inst.IF);
      dram_w.set_verbosity(400);  
      dram_w.start_slave();
      
      //backdoor_mem_write();   // Call task to do back door memory write  
      //backdoor_mem_read();   // Call task to do back door memory read
      user_gen_wready();     // call task to generate wready 

   end
   
   
   task reg_wr(input integer  adr,  input integer data);
      axi_transaction  wr_transaction;
      wr_transaction   = cpu.wr_driver.create_transaction( "register write");
      WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
      wr_transaction.set_addr(adr);
      wr_transaction.set_data_block(data);

      cpu.wr_driver.send(wr_transaction);
   endtask 

 
   
    // Testscenario
    initial begin
       
        fork
           clk_gen();
           rst_gen();
        join_none

       clk_dly(100);

       reg_wr(`REG_CTRL, `REG_CTRL_RESET);

       
       reg_wr(`REG_WSADR1, `ADR_WEIGHT_DATA1);
       reg_wr(`REG_WSADR2, `ADR_WEIGHT_DATA2);


       reg_wr(`REG_CTRL, `REG_CTRL_RUN);
       
       backdoor_mem_write_from_file("../../weight/conv2d_1_kernel_z.bin", `ADR_WEIGHT_DATA1);
       

       reg_wr(`REG_CTRL, `REG_CTRL_RUN);
       
        clk_dly(1000);

        $finish(2);
    end
endmodule

