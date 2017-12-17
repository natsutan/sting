// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Wed Dec 13 14:36:46 2017
// Host        : LAPTOP-NDAAQDUA running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/home/myproj/sting/vivado/zybo/sting_ip/sting_ip.srcs/sources_1/bd/design_1/ip/design_1_sting_wrap_0_0/design_1_sting_wrap_0_0_stub.v
// Design      : design_1_sting_wrap_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "sting_wrap_v1_0,Vivado 2017.2" *)
module design_1_sting_wrap_0_0(s_axi_intr_awaddr, s_axi_intr_awprot, 
  s_axi_intr_awvalid, s_axi_intr_awready, s_axi_intr_wdata, s_axi_intr_wstrb, 
  s_axi_intr_wvalid, s_axi_intr_wready, s_axi_intr_bresp, s_axi_intr_bvalid, 
  s_axi_intr_bready, s_axi_intr_araddr, s_axi_intr_arprot, s_axi_intr_arvalid, 
  s_axi_intr_arready, s_axi_intr_rdata, s_axi_intr_rresp, s_axi_intr_rvalid, 
  s_axi_intr_rready, s_axi_intr_aclk, s_axi_intr_aresetn, irq, m00_axi_awid, m00_axi_awaddr, 
  m00_axi_awlen, m00_axi_awsize, m00_axi_awburst, m00_axi_awlock, m00_axi_awcache, 
  m00_axi_awprot, m00_axi_awqos, m00_axi_awuser, m00_axi_awvalid, m00_axi_awready, 
  m00_axi_wdata, m00_axi_wstrb, m00_axi_wlast, m00_axi_wuser, m00_axi_wvalid, m00_axi_wready, 
  m00_axi_bid, m00_axi_bresp, m00_axi_buser, m00_axi_bvalid, m00_axi_bready, m00_axi_arid, 
  m00_axi_araddr, m00_axi_arlen, m00_axi_arsize, m00_axi_arburst, m00_axi_arlock, 
  m00_axi_arcache, m00_axi_arprot, m00_axi_arqos, m00_axi_aruser, m00_axi_arvalid, 
  m00_axi_arready, m00_axi_rid, m00_axi_rdata, m00_axi_rresp, m00_axi_rlast, m00_axi_ruser, 
  m00_axi_rvalid, m00_axi_rready, m00_axi_aclk, m00_axi_aresetn, m00_axi_init_axi_txn, 
  m00_axi_txn_done, m00_axi_error, s00_axi_awaddr, s00_axi_awprot, s00_axi_awvalid, 
  s00_axi_awready, s00_axi_wdata, s00_axi_wstrb, s00_axi_wvalid, s00_axi_wready, 
  s00_axi_bresp, s00_axi_bvalid, s00_axi_bready, s00_axi_araddr, s00_axi_arprot, 
  s00_axi_arvalid, s00_axi_arready, s00_axi_rdata, s00_axi_rresp, s00_axi_rvalid, 
  s00_axi_rready, s00_axi_aclk, s00_axi_aresetn, m02_axi_awid, m02_axi_awaddr, m02_axi_awlen, 
  m02_axi_awsize, m02_axi_awburst, m02_axi_awlock, m02_axi_awcache, m02_axi_awprot, 
  m02_axi_awqos, m02_axi_awuser, m02_axi_awvalid, m02_axi_awready, m02_axi_wdata, 
  m02_axi_wstrb, m02_axi_wlast, m02_axi_wuser, m02_axi_wvalid, m02_axi_wready, m02_axi_bid, 
  m02_axi_bresp, m02_axi_buser, m02_axi_bvalid, m02_axi_bready, m02_axi_arid, m02_axi_araddr, 
  m02_axi_arlen, m02_axi_arsize, m02_axi_arburst, m02_axi_arlock, m02_axi_arcache, 
  m02_axi_arprot, m02_axi_arqos, m02_axi_aruser, m02_axi_arvalid, m02_axi_arready, 
  m02_axi_rid, m02_axi_rdata, m02_axi_rresp, m02_axi_rlast, m02_axi_ruser, m02_axi_rvalid, 
  m02_axi_rready, m02_axi_aclk, m02_axi_aresetn, m02_axi_init_axi_txn, m02_axi_txn_done, 
  m02_axi_error, m01_axi_awaddr, m01_axi_awprot, m01_axi_awvalid, m01_axi_awready, 
  m01_axi_wdata, m01_axi_wstrb, m01_axi_wvalid, m01_axi_wready, m01_axi_bresp, 
  m01_axi_bvalid, m01_axi_bready, m01_axi_araddr, m01_axi_arprot, m01_axi_arvalid, 
  m01_axi_arready, m01_axi_rdata, m01_axi_rresp, m01_axi_rvalid, m01_axi_rready, 
  m01_axi_aclk, m01_axi_aresetn, m01_axi_init_axi_txn, m01_axi_error, m01_axi_txn_done)
/* synthesis syn_black_box black_box_pad_pin="s_axi_intr_awaddr[4:0],s_axi_intr_awprot[2:0],s_axi_intr_awvalid,s_axi_intr_awready,s_axi_intr_wdata[31:0],s_axi_intr_wstrb[3:0],s_axi_intr_wvalid,s_axi_intr_wready,s_axi_intr_bresp[1:0],s_axi_intr_bvalid,s_axi_intr_bready,s_axi_intr_araddr[4:0],s_axi_intr_arprot[2:0],s_axi_intr_arvalid,s_axi_intr_arready,s_axi_intr_rdata[31:0],s_axi_intr_rresp[1:0],s_axi_intr_rvalid,s_axi_intr_rready,s_axi_intr_aclk,s_axi_intr_aresetn,irq,m00_axi_awid[0:0],m00_axi_awaddr[31:0],m00_axi_awlen[7:0],m00_axi_awsize[2:0],m00_axi_awburst[1:0],m00_axi_awlock,m00_axi_awcache[3:0],m00_axi_awprot[2:0],m00_axi_awqos[3:0],m00_axi_awuser[0:0],m00_axi_awvalid,m00_axi_awready,m00_axi_wdata[31:0],m00_axi_wstrb[3:0],m00_axi_wlast,m00_axi_wuser[0:0],m00_axi_wvalid,m00_axi_wready,m00_axi_bid[0:0],m00_axi_bresp[1:0],m00_axi_buser[0:0],m00_axi_bvalid,m00_axi_bready,m00_axi_arid[0:0],m00_axi_araddr[31:0],m00_axi_arlen[7:0],m00_axi_arsize[2:0],m00_axi_arburst[1:0],m00_axi_arlock,m00_axi_arcache[3:0],m00_axi_arprot[2:0],m00_axi_arqos[3:0],m00_axi_aruser[0:0],m00_axi_arvalid,m00_axi_arready,m00_axi_rid[0:0],m00_axi_rdata[31:0],m00_axi_rresp[1:0],m00_axi_rlast,m00_axi_ruser[0:0],m00_axi_rvalid,m00_axi_rready,m00_axi_aclk,m00_axi_aresetn,m00_axi_init_axi_txn,m00_axi_txn_done,m00_axi_error,s00_axi_awaddr[7:0],s00_axi_awprot[2:0],s00_axi_awvalid,s00_axi_awready,s00_axi_wdata[31:0],s00_axi_wstrb[3:0],s00_axi_wvalid,s00_axi_wready,s00_axi_bresp[1:0],s00_axi_bvalid,s00_axi_bready,s00_axi_araddr[7:0],s00_axi_arprot[2:0],s00_axi_arvalid,s00_axi_arready,s00_axi_rdata[31:0],s00_axi_rresp[1:0],s00_axi_rvalid,s00_axi_rready,s00_axi_aclk,s00_axi_aresetn,m02_axi_awid[0:0],m02_axi_awaddr[31:0],m02_axi_awlen[7:0],m02_axi_awsize[2:0],m02_axi_awburst[1:0],m02_axi_awlock,m02_axi_awcache[3:0],m02_axi_awprot[2:0],m02_axi_awqos[3:0],m02_axi_awuser[0:0],m02_axi_awvalid,m02_axi_awready,m02_axi_wdata[31:0],m02_axi_wstrb[3:0],m02_axi_wlast,m02_axi_wuser[0:0],m02_axi_wvalid,m02_axi_wready,m02_axi_bid[0:0],m02_axi_bresp[1:0],m02_axi_buser[0:0],m02_axi_bvalid,m02_axi_bready,m02_axi_arid[0:0],m02_axi_araddr[31:0],m02_axi_arlen[7:0],m02_axi_arsize[2:0],m02_axi_arburst[1:0],m02_axi_arlock,m02_axi_arcache[3:0],m02_axi_arprot[2:0],m02_axi_arqos[3:0],m02_axi_aruser[0:0],m02_axi_arvalid,m02_axi_arready,m02_axi_rid[0:0],m02_axi_rdata[31:0],m02_axi_rresp[1:0],m02_axi_rlast,m02_axi_ruser[0:0],m02_axi_rvalid,m02_axi_rready,m02_axi_aclk,m02_axi_aresetn,m02_axi_init_axi_txn,m02_axi_txn_done,m02_axi_error,m01_axi_awaddr[31:0],m01_axi_awprot[2:0],m01_axi_awvalid,m01_axi_awready,m01_axi_wdata[31:0],m01_axi_wstrb[3:0],m01_axi_wvalid,m01_axi_wready,m01_axi_bresp[1:0],m01_axi_bvalid,m01_axi_bready,m01_axi_araddr[31:0],m01_axi_arprot[2:0],m01_axi_arvalid,m01_axi_arready,m01_axi_rdata[31:0],m01_axi_rresp[1:0],m01_axi_rvalid,m01_axi_rready,m01_axi_aclk,m01_axi_aresetn,m01_axi_init_axi_txn,m01_axi_error,m01_axi_txn_done" */;
  input [4:0]s_axi_intr_awaddr;
  input [2:0]s_axi_intr_awprot;
  input s_axi_intr_awvalid;
  output s_axi_intr_awready;
  input [31:0]s_axi_intr_wdata;
  input [3:0]s_axi_intr_wstrb;
  input s_axi_intr_wvalid;
  output s_axi_intr_wready;
  output [1:0]s_axi_intr_bresp;
  output s_axi_intr_bvalid;
  input s_axi_intr_bready;
  input [4:0]s_axi_intr_araddr;
  input [2:0]s_axi_intr_arprot;
  input s_axi_intr_arvalid;
  output s_axi_intr_arready;
  output [31:0]s_axi_intr_rdata;
  output [1:0]s_axi_intr_rresp;
  output s_axi_intr_rvalid;
  input s_axi_intr_rready;
  input s_axi_intr_aclk;
  input s_axi_intr_aresetn;
  output irq;
  output [0:0]m00_axi_awid;
  output [31:0]m00_axi_awaddr;
  output [7:0]m00_axi_awlen;
  output [2:0]m00_axi_awsize;
  output [1:0]m00_axi_awburst;
  output m00_axi_awlock;
  output [3:0]m00_axi_awcache;
  output [2:0]m00_axi_awprot;
  output [3:0]m00_axi_awqos;
  output [0:0]m00_axi_awuser;
  output m00_axi_awvalid;
  input m00_axi_awready;
  output [31:0]m00_axi_wdata;
  output [3:0]m00_axi_wstrb;
  output m00_axi_wlast;
  output [0:0]m00_axi_wuser;
  output m00_axi_wvalid;
  input m00_axi_wready;
  input [0:0]m00_axi_bid;
  input [1:0]m00_axi_bresp;
  input [0:0]m00_axi_buser;
  input m00_axi_bvalid;
  output m00_axi_bready;
  output [0:0]m00_axi_arid;
  output [31:0]m00_axi_araddr;
  output [7:0]m00_axi_arlen;
  output [2:0]m00_axi_arsize;
  output [1:0]m00_axi_arburst;
  output m00_axi_arlock;
  output [3:0]m00_axi_arcache;
  output [2:0]m00_axi_arprot;
  output [3:0]m00_axi_arqos;
  output [0:0]m00_axi_aruser;
  output m00_axi_arvalid;
  input m00_axi_arready;
  input [0:0]m00_axi_rid;
  input [31:0]m00_axi_rdata;
  input [1:0]m00_axi_rresp;
  input m00_axi_rlast;
  input [0:0]m00_axi_ruser;
  input m00_axi_rvalid;
  output m00_axi_rready;
  input m00_axi_aclk;
  input m00_axi_aresetn;
  input m00_axi_init_axi_txn;
  output m00_axi_txn_done;
  output m00_axi_error;
  input [7:0]s00_axi_awaddr;
  input [2:0]s00_axi_awprot;
  input s00_axi_awvalid;
  output s00_axi_awready;
  input [31:0]s00_axi_wdata;
  input [3:0]s00_axi_wstrb;
  input s00_axi_wvalid;
  output s00_axi_wready;
  output [1:0]s00_axi_bresp;
  output s00_axi_bvalid;
  input s00_axi_bready;
  input [7:0]s00_axi_araddr;
  input [2:0]s00_axi_arprot;
  input s00_axi_arvalid;
  output s00_axi_arready;
  output [31:0]s00_axi_rdata;
  output [1:0]s00_axi_rresp;
  output s00_axi_rvalid;
  input s00_axi_rready;
  input s00_axi_aclk;
  input s00_axi_aresetn;
  output [0:0]m02_axi_awid;
  output [31:0]m02_axi_awaddr;
  output [7:0]m02_axi_awlen;
  output [2:0]m02_axi_awsize;
  output [1:0]m02_axi_awburst;
  output m02_axi_awlock;
  output [3:0]m02_axi_awcache;
  output [2:0]m02_axi_awprot;
  output [3:0]m02_axi_awqos;
  output [0:0]m02_axi_awuser;
  output m02_axi_awvalid;
  input m02_axi_awready;
  output [31:0]m02_axi_wdata;
  output [3:0]m02_axi_wstrb;
  output m02_axi_wlast;
  output [0:0]m02_axi_wuser;
  output m02_axi_wvalid;
  input m02_axi_wready;
  input [0:0]m02_axi_bid;
  input [1:0]m02_axi_bresp;
  input [0:0]m02_axi_buser;
  input m02_axi_bvalid;
  output m02_axi_bready;
  output [0:0]m02_axi_arid;
  output [31:0]m02_axi_araddr;
  output [7:0]m02_axi_arlen;
  output [2:0]m02_axi_arsize;
  output [1:0]m02_axi_arburst;
  output m02_axi_arlock;
  output [3:0]m02_axi_arcache;
  output [2:0]m02_axi_arprot;
  output [3:0]m02_axi_arqos;
  output [0:0]m02_axi_aruser;
  output m02_axi_arvalid;
  input m02_axi_arready;
  input [0:0]m02_axi_rid;
  input [31:0]m02_axi_rdata;
  input [1:0]m02_axi_rresp;
  input m02_axi_rlast;
  input [0:0]m02_axi_ruser;
  input m02_axi_rvalid;
  output m02_axi_rready;
  input m02_axi_aclk;
  input m02_axi_aresetn;
  input m02_axi_init_axi_txn;
  output m02_axi_txn_done;
  output m02_axi_error;
  output [31:0]m01_axi_awaddr;
  output [2:0]m01_axi_awprot;
  output m01_axi_awvalid;
  input m01_axi_awready;
  output [31:0]m01_axi_wdata;
  output [3:0]m01_axi_wstrb;
  output m01_axi_wvalid;
  input m01_axi_wready;
  input [1:0]m01_axi_bresp;
  input m01_axi_bvalid;
  output m01_axi_bready;
  output [31:0]m01_axi_araddr;
  output [2:0]m01_axi_arprot;
  output m01_axi_arvalid;
  input m01_axi_arready;
  input [31:0]m01_axi_rdata;
  input [1:0]m01_axi_rresp;
  input m01_axi_rvalid;
  output m01_axi_rready;
  input m01_axi_aclk;
  input m01_axi_aresetn;
  input m01_axi_init_axi_txn;
  output m01_axi_error;
  output m01_axi_txn_done;
endmodule
