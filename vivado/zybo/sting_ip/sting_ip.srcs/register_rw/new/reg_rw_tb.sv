`timescale 1ns/1ps

import axi_vip_v1_0_2_pkg::*;
import design_1_axi_vip_0_1_pkg::*;

`inlucde "sting_reg.h"
    
module reg_rw_tb();

    localparam int LP_CLK_PERI = 10;
    localparam int LP_RST_PERI = 50;

    // DUT instance
    logic aresetn, aclk;
    logic axi_init;
    wire irq;
    
   design_1 design_1(
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
   design_1_axi_vip_0_1_mst_t  design_1_axi_vip_0_1_mst;
   
   initial begin 
      design_1_axi_vip_0_1_mst = new("design_1_axi_vip_0_1_mst", reg_rw_tb.design_1.axi_vip_0.inst.IF);
      design_1_axi_vip_0_1_mst.start_master();
   end
   
   task reg_wr(input integer  adr,  input integer data);
      axi_transaction  wr_transaction;
      wr_transaction   = design_1_axi_vip_0_1_mst.wr_driver.create_transaction( "register write");
      WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
      wr_transaction.set_addr(adr);
      wr_transaction.set_data_block(data);

      design_1_axi_vip_0_1_mst.wr_driver.send(wr_transaction);
   endtask 
   
    // Testscenario
    initial begin

        fork
           clk_gen();
           rst_gen();
        join_none

       clk_dly(100);

       reg_wr(`REG_CTRL, `REG_CTRL_RESET);
       reg_wr(`REG_CTRL, `REG_CTRL_RUN);
       
       reg_wr(`REG_MODE, `REG_MODE_DIVMODE);
       reg_wr(`REG_MODE, `REG_MODE_BNEN);
       reg_wr(`REG_MODE, `REG_MODE_LRELUEN);

       reg_wr(`REG_IXSIZE, 128);
       reg_wr(`REG_IYSIZE, 1024);
       reg_wr(`REG_ISADR,  32'h80000000);
       reg_wr(`REG_IFSIZE, 32'h80010000);
       reg_wr(`REG_WSADR1, 32'h80020000);

       reg_wr(`REG_WSADR2, 32'h80030000);
       reg_wr(`REG_OXSIZE, 64);
       
       reg_wr(`REG_OSADR, 32'h90000000);
       reg_wr(`REG_OFSIZE,  500);

       reg_wr(`REG_LRELU, 32h'12345678);
       reg_wr(`REG_FNSIZE, 32'h02000300);
       

        clk_dly(1000);
        $finish(2);
    end
endmodule

