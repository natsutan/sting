//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
//Date        : Wed Dec 13 14:35:41 2017
//Host        : LAPTOP-NDAAQDUA running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (aclk,
    aresetn,
    init_axi_txn,
    irq);
  input aclk;
  input aresetn;
  input init_axi_txn;
  output irq;

  wire aclk;
  wire aresetn;
  wire init_axi_txn;
  wire irq;

  design_1 design_1_i
       (.aclk(aclk),
        .aresetn(aresetn),
        .init_axi_txn(init_axi_txn),
        .irq(irq));
endmodule
