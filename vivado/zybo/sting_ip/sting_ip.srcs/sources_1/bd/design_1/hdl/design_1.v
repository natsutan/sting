//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
//Date        : Wed Dec 13 14:35:41 2017
//Host        : LAPTOP-NDAAQDUA running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=2,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (aclk,
    aresetn,
    init_axi_txn,
    irq);
  input aclk;
  input aresetn;
  input init_axi_txn;
  output irq;

  wire aclk_1;
  wire aresetn_1;
  wire [31:0]axi_vip_0_M_AXI_ARADDR;
  wire [2:0]axi_vip_0_M_AXI_ARPROT;
  wire axi_vip_0_M_AXI_ARREADY;
  wire axi_vip_0_M_AXI_ARVALID;
  wire [31:0]axi_vip_0_M_AXI_AWADDR;
  wire [2:0]axi_vip_0_M_AXI_AWPROT;
  wire axi_vip_0_M_AXI_AWREADY;
  wire axi_vip_0_M_AXI_AWVALID;
  wire axi_vip_0_M_AXI_BREADY;
  wire [1:0]axi_vip_0_M_AXI_BRESP;
  wire axi_vip_0_M_AXI_BVALID;
  wire [31:0]axi_vip_0_M_AXI_RDATA;
  wire axi_vip_0_M_AXI_RREADY;
  wire [1:0]axi_vip_0_M_AXI_RRESP;
  wire axi_vip_0_M_AXI_RVALID;
  wire [31:0]axi_vip_0_M_AXI_WDATA;
  wire axi_vip_0_M_AXI_WREADY;
  wire [3:0]axi_vip_0_M_AXI_WSTRB;
  wire axi_vip_0_M_AXI_WVALID;
  wire [31:0]axi_vip_4_M_AXI_ARADDR;
  wire [2:0]axi_vip_4_M_AXI_ARPROT;
  wire axi_vip_4_M_AXI_ARREADY;
  wire axi_vip_4_M_AXI_ARVALID;
  wire [31:0]axi_vip_4_M_AXI_AWADDR;
  wire [2:0]axi_vip_4_M_AXI_AWPROT;
  wire axi_vip_4_M_AXI_AWREADY;
  wire axi_vip_4_M_AXI_AWVALID;
  wire axi_vip_4_M_AXI_BREADY;
  wire [1:0]axi_vip_4_M_AXI_BRESP;
  wire axi_vip_4_M_AXI_BVALID;
  wire [31:0]axi_vip_4_M_AXI_RDATA;
  wire axi_vip_4_M_AXI_RREADY;
  wire [1:0]axi_vip_4_M_AXI_RRESP;
  wire axi_vip_4_M_AXI_RVALID;
  wire [31:0]axi_vip_4_M_AXI_WDATA;
  wire axi_vip_4_M_AXI_WREADY;
  wire [3:0]axi_vip_4_M_AXI_WSTRB;
  wire axi_vip_4_M_AXI_WVALID;
  wire init_axi_txn_1;
  wire [31:0]sting_wrap_0_M00_AXI_ARADDR;
  wire [1:0]sting_wrap_0_M00_AXI_ARBURST;
  wire [3:0]sting_wrap_0_M00_AXI_ARCACHE;
  wire [0:0]sting_wrap_0_M00_AXI_ARID;
  wire [7:0]sting_wrap_0_M00_AXI_ARLEN;
  wire sting_wrap_0_M00_AXI_ARLOCK;
  wire [2:0]sting_wrap_0_M00_AXI_ARPROT;
  wire [3:0]sting_wrap_0_M00_AXI_ARQOS;
  wire sting_wrap_0_M00_AXI_ARREADY;
  wire [0:0]sting_wrap_0_M00_AXI_ARUSER;
  wire sting_wrap_0_M00_AXI_ARVALID;
  wire [31:0]sting_wrap_0_M00_AXI_AWADDR;
  wire [1:0]sting_wrap_0_M00_AXI_AWBURST;
  wire [3:0]sting_wrap_0_M00_AXI_AWCACHE;
  wire [0:0]sting_wrap_0_M00_AXI_AWID;
  wire [7:0]sting_wrap_0_M00_AXI_AWLEN;
  wire sting_wrap_0_M00_AXI_AWLOCK;
  wire [2:0]sting_wrap_0_M00_AXI_AWPROT;
  wire [3:0]sting_wrap_0_M00_AXI_AWQOS;
  wire sting_wrap_0_M00_AXI_AWREADY;
  wire [0:0]sting_wrap_0_M00_AXI_AWUSER;
  wire sting_wrap_0_M00_AXI_AWVALID;
  wire [0:0]sting_wrap_0_M00_AXI_BID;
  wire sting_wrap_0_M00_AXI_BREADY;
  wire [1:0]sting_wrap_0_M00_AXI_BRESP;
  wire [0:0]sting_wrap_0_M00_AXI_BUSER;
  wire sting_wrap_0_M00_AXI_BVALID;
  wire [31:0]sting_wrap_0_M00_AXI_RDATA;
  wire [0:0]sting_wrap_0_M00_AXI_RID;
  wire sting_wrap_0_M00_AXI_RLAST;
  wire sting_wrap_0_M00_AXI_RREADY;
  wire [1:0]sting_wrap_0_M00_AXI_RRESP;
  wire [0:0]sting_wrap_0_M00_AXI_RUSER;
  wire sting_wrap_0_M00_AXI_RVALID;
  wire [31:0]sting_wrap_0_M00_AXI_WDATA;
  wire sting_wrap_0_M00_AXI_WLAST;
  wire sting_wrap_0_M00_AXI_WREADY;
  wire [3:0]sting_wrap_0_M00_AXI_WSTRB;
  wire [0:0]sting_wrap_0_M00_AXI_WUSER;
  wire sting_wrap_0_M00_AXI_WVALID;
  wire [31:0]sting_wrap_0_M01_AXI_ARADDR;
  wire [2:0]sting_wrap_0_M01_AXI_ARPROT;
  wire sting_wrap_0_M01_AXI_ARREADY;
  wire sting_wrap_0_M01_AXI_ARVALID;
  wire [31:0]sting_wrap_0_M01_AXI_AWADDR;
  wire [2:0]sting_wrap_0_M01_AXI_AWPROT;
  wire sting_wrap_0_M01_AXI_AWREADY;
  wire sting_wrap_0_M01_AXI_AWVALID;
  wire sting_wrap_0_M01_AXI_BREADY;
  wire [1:0]sting_wrap_0_M01_AXI_BRESP;
  wire sting_wrap_0_M01_AXI_BVALID;
  wire [31:0]sting_wrap_0_M01_AXI_RDATA;
  wire sting_wrap_0_M01_AXI_RREADY;
  wire [1:0]sting_wrap_0_M01_AXI_RRESP;
  wire sting_wrap_0_M01_AXI_RVALID;
  wire [31:0]sting_wrap_0_M01_AXI_WDATA;
  wire sting_wrap_0_M01_AXI_WREADY;
  wire [3:0]sting_wrap_0_M01_AXI_WSTRB;
  wire sting_wrap_0_M01_AXI_WVALID;
  wire [31:0]sting_wrap_0_M02_AXI_ARADDR;
  wire [1:0]sting_wrap_0_M02_AXI_ARBURST;
  wire [3:0]sting_wrap_0_M02_AXI_ARCACHE;
  wire [0:0]sting_wrap_0_M02_AXI_ARID;
  wire [7:0]sting_wrap_0_M02_AXI_ARLEN;
  wire sting_wrap_0_M02_AXI_ARLOCK;
  wire [2:0]sting_wrap_0_M02_AXI_ARPROT;
  wire [3:0]sting_wrap_0_M02_AXI_ARQOS;
  wire sting_wrap_0_M02_AXI_ARREADY;
  wire [0:0]sting_wrap_0_M02_AXI_ARUSER;
  wire sting_wrap_0_M02_AXI_ARVALID;
  wire [31:0]sting_wrap_0_M02_AXI_AWADDR;
  wire [1:0]sting_wrap_0_M02_AXI_AWBURST;
  wire [3:0]sting_wrap_0_M02_AXI_AWCACHE;
  wire [0:0]sting_wrap_0_M02_AXI_AWID;
  wire [7:0]sting_wrap_0_M02_AXI_AWLEN;
  wire sting_wrap_0_M02_AXI_AWLOCK;
  wire [2:0]sting_wrap_0_M02_AXI_AWPROT;
  wire [3:0]sting_wrap_0_M02_AXI_AWQOS;
  wire sting_wrap_0_M02_AXI_AWREADY;
  wire [0:0]sting_wrap_0_M02_AXI_AWUSER;
  wire sting_wrap_0_M02_AXI_AWVALID;
  wire [0:0]sting_wrap_0_M02_AXI_BID;
  wire sting_wrap_0_M02_AXI_BREADY;
  wire [1:0]sting_wrap_0_M02_AXI_BRESP;
  wire [0:0]sting_wrap_0_M02_AXI_BUSER;
  wire sting_wrap_0_M02_AXI_BVALID;
  wire [31:0]sting_wrap_0_M02_AXI_RDATA;
  wire [0:0]sting_wrap_0_M02_AXI_RID;
  wire sting_wrap_0_M02_AXI_RLAST;
  wire sting_wrap_0_M02_AXI_RREADY;
  wire [1:0]sting_wrap_0_M02_AXI_RRESP;
  wire [0:0]sting_wrap_0_M02_AXI_RUSER;
  wire sting_wrap_0_M02_AXI_RVALID;
  wire [31:0]sting_wrap_0_M02_AXI_WDATA;
  wire sting_wrap_0_M02_AXI_WLAST;
  wire sting_wrap_0_M02_AXI_WREADY;
  wire [3:0]sting_wrap_0_M02_AXI_WSTRB;
  wire [0:0]sting_wrap_0_M02_AXI_WUSER;
  wire sting_wrap_0_M02_AXI_WVALID;
  wire sting_wrap_0_irq;

  assign aclk_1 = aclk;
  assign aresetn_1 = aresetn;
  assign init_axi_txn_1 = init_axi_txn;
  assign irq = sting_wrap_0_irq;
  design_1_axi_vip_0_1 axi_vip_0
       (.aclk(aclk_1),
        .aresetn(aresetn_1),
        .m_axi_araddr(axi_vip_0_M_AXI_ARADDR),
        .m_axi_arprot(axi_vip_0_M_AXI_ARPROT),
        .m_axi_arready(axi_vip_0_M_AXI_ARREADY),
        .m_axi_arvalid(axi_vip_0_M_AXI_ARVALID),
        .m_axi_awaddr(axi_vip_0_M_AXI_AWADDR),
        .m_axi_awprot(axi_vip_0_M_AXI_AWPROT),
        .m_axi_awready(axi_vip_0_M_AXI_AWREADY),
        .m_axi_awvalid(axi_vip_0_M_AXI_AWVALID),
        .m_axi_bready(axi_vip_0_M_AXI_BREADY),
        .m_axi_bresp(axi_vip_0_M_AXI_BRESP),
        .m_axi_bvalid(axi_vip_0_M_AXI_BVALID),
        .m_axi_rdata(axi_vip_0_M_AXI_RDATA),
        .m_axi_rready(axi_vip_0_M_AXI_RREADY),
        .m_axi_rresp(axi_vip_0_M_AXI_RRESP),
        .m_axi_rvalid(axi_vip_0_M_AXI_RVALID),
        .m_axi_wdata(axi_vip_0_M_AXI_WDATA),
        .m_axi_wready(axi_vip_0_M_AXI_WREADY),
        .m_axi_wstrb(axi_vip_0_M_AXI_WSTRB),
        .m_axi_wvalid(axi_vip_0_M_AXI_WVALID));
  design_1_axi_vip_1_1 axi_vip_1
       (.aclk(aclk_1),
        .aresetn(aresetn_1),
        .s_axi_araddr(sting_wrap_0_M00_AXI_ARADDR),
        .s_axi_arburst(sting_wrap_0_M00_AXI_ARBURST),
        .s_axi_arcache(sting_wrap_0_M00_AXI_ARCACHE),
        .s_axi_arid(sting_wrap_0_M00_AXI_ARID),
        .s_axi_arlen(sting_wrap_0_M00_AXI_ARLEN),
        .s_axi_arlock(sting_wrap_0_M00_AXI_ARLOCK),
        .s_axi_arprot(sting_wrap_0_M00_AXI_ARPROT),
        .s_axi_arqos(sting_wrap_0_M00_AXI_ARQOS),
        .s_axi_arready(sting_wrap_0_M00_AXI_ARREADY),
        .s_axi_aruser(sting_wrap_0_M00_AXI_ARUSER),
        .s_axi_arvalid(sting_wrap_0_M00_AXI_ARVALID),
        .s_axi_awaddr(sting_wrap_0_M00_AXI_AWADDR),
        .s_axi_awburst(sting_wrap_0_M00_AXI_AWBURST),
        .s_axi_awcache(sting_wrap_0_M00_AXI_AWCACHE),
        .s_axi_awid(sting_wrap_0_M00_AXI_AWID),
        .s_axi_awlen(sting_wrap_0_M00_AXI_AWLEN),
        .s_axi_awlock(sting_wrap_0_M00_AXI_AWLOCK),
        .s_axi_awprot(sting_wrap_0_M00_AXI_AWPROT),
        .s_axi_awqos(sting_wrap_0_M00_AXI_AWQOS),
        .s_axi_awready(sting_wrap_0_M00_AXI_AWREADY),
        .s_axi_awuser(sting_wrap_0_M00_AXI_AWUSER),
        .s_axi_awvalid(sting_wrap_0_M00_AXI_AWVALID),
        .s_axi_bid(sting_wrap_0_M00_AXI_BID),
        .s_axi_bready(sting_wrap_0_M00_AXI_BREADY),
        .s_axi_bresp(sting_wrap_0_M00_AXI_BRESP),
        .s_axi_buser(sting_wrap_0_M00_AXI_BUSER),
        .s_axi_bvalid(sting_wrap_0_M00_AXI_BVALID),
        .s_axi_rdata(sting_wrap_0_M00_AXI_RDATA),
        .s_axi_rid(sting_wrap_0_M00_AXI_RID),
        .s_axi_rlast(sting_wrap_0_M00_AXI_RLAST),
        .s_axi_rready(sting_wrap_0_M00_AXI_RREADY),
        .s_axi_rresp(sting_wrap_0_M00_AXI_RRESP),
        .s_axi_ruser(sting_wrap_0_M00_AXI_RUSER),
        .s_axi_rvalid(sting_wrap_0_M00_AXI_RVALID),
        .s_axi_wdata(sting_wrap_0_M00_AXI_WDATA),
        .s_axi_wlast(sting_wrap_0_M00_AXI_WLAST),
        .s_axi_wready(sting_wrap_0_M00_AXI_WREADY),
        .s_axi_wstrb(sting_wrap_0_M00_AXI_WSTRB),
        .s_axi_wuser(sting_wrap_0_M00_AXI_WUSER),
        .s_axi_wvalid(sting_wrap_0_M00_AXI_WVALID));
  design_1_axi_vip_2_0 axi_vip_2
       (.aclk(aclk_1),
        .aresetn(aresetn_1),
        .s_axi_araddr(sting_wrap_0_M01_AXI_ARADDR),
        .s_axi_arprot(sting_wrap_0_M01_AXI_ARPROT),
        .s_axi_arready(sting_wrap_0_M01_AXI_ARREADY),
        .s_axi_arvalid(sting_wrap_0_M01_AXI_ARVALID),
        .s_axi_awaddr(sting_wrap_0_M01_AXI_AWADDR),
        .s_axi_awprot(sting_wrap_0_M01_AXI_AWPROT),
        .s_axi_awready(sting_wrap_0_M01_AXI_AWREADY),
        .s_axi_awvalid(sting_wrap_0_M01_AXI_AWVALID),
        .s_axi_bready(sting_wrap_0_M01_AXI_BREADY),
        .s_axi_bresp(sting_wrap_0_M01_AXI_BRESP),
        .s_axi_bvalid(sting_wrap_0_M01_AXI_BVALID),
        .s_axi_rdata(sting_wrap_0_M01_AXI_RDATA),
        .s_axi_rready(sting_wrap_0_M01_AXI_RREADY),
        .s_axi_rresp(sting_wrap_0_M01_AXI_RRESP),
        .s_axi_rvalid(sting_wrap_0_M01_AXI_RVALID),
        .s_axi_wdata(sting_wrap_0_M01_AXI_WDATA),
        .s_axi_wready(sting_wrap_0_M01_AXI_WREADY),
        .s_axi_wstrb(sting_wrap_0_M01_AXI_WSTRB),
        .s_axi_wvalid(sting_wrap_0_M01_AXI_WVALID));
  design_1_axi_vip_3_0 axi_vip_3
       (.aclk(aclk_1),
        .aresetn(aresetn_1),
        .s_axi_araddr(sting_wrap_0_M02_AXI_ARADDR),
        .s_axi_arburst(sting_wrap_0_M02_AXI_ARBURST),
        .s_axi_arcache(sting_wrap_0_M02_AXI_ARCACHE),
        .s_axi_arid(sting_wrap_0_M02_AXI_ARID),
        .s_axi_arlen(sting_wrap_0_M02_AXI_ARLEN),
        .s_axi_arlock(sting_wrap_0_M02_AXI_ARLOCK),
        .s_axi_arprot(sting_wrap_0_M02_AXI_ARPROT),
        .s_axi_arqos(sting_wrap_0_M02_AXI_ARQOS),
        .s_axi_arready(sting_wrap_0_M02_AXI_ARREADY),
        .s_axi_aruser(sting_wrap_0_M02_AXI_ARUSER),
        .s_axi_arvalid(sting_wrap_0_M02_AXI_ARVALID),
        .s_axi_awaddr(sting_wrap_0_M02_AXI_AWADDR),
        .s_axi_awburst(sting_wrap_0_M02_AXI_AWBURST),
        .s_axi_awcache(sting_wrap_0_M02_AXI_AWCACHE),
        .s_axi_awid(sting_wrap_0_M02_AXI_AWID),
        .s_axi_awlen(sting_wrap_0_M02_AXI_AWLEN),
        .s_axi_awlock(sting_wrap_0_M02_AXI_AWLOCK),
        .s_axi_awprot(sting_wrap_0_M02_AXI_AWPROT),
        .s_axi_awqos(sting_wrap_0_M02_AXI_AWQOS),
        .s_axi_awready(sting_wrap_0_M02_AXI_AWREADY),
        .s_axi_awuser(sting_wrap_0_M02_AXI_AWUSER),
        .s_axi_awvalid(sting_wrap_0_M02_AXI_AWVALID),
        .s_axi_bid(sting_wrap_0_M02_AXI_BID),
        .s_axi_bready(sting_wrap_0_M02_AXI_BREADY),
        .s_axi_bresp(sting_wrap_0_M02_AXI_BRESP),
        .s_axi_buser(sting_wrap_0_M02_AXI_BUSER),
        .s_axi_bvalid(sting_wrap_0_M02_AXI_BVALID),
        .s_axi_rdata(sting_wrap_0_M02_AXI_RDATA),
        .s_axi_rid(sting_wrap_0_M02_AXI_RID),
        .s_axi_rlast(sting_wrap_0_M02_AXI_RLAST),
        .s_axi_rready(sting_wrap_0_M02_AXI_RREADY),
        .s_axi_rresp(sting_wrap_0_M02_AXI_RRESP),
        .s_axi_ruser(sting_wrap_0_M02_AXI_RUSER),
        .s_axi_rvalid(sting_wrap_0_M02_AXI_RVALID),
        .s_axi_wdata(sting_wrap_0_M02_AXI_WDATA),
        .s_axi_wlast(sting_wrap_0_M02_AXI_WLAST),
        .s_axi_wready(sting_wrap_0_M02_AXI_WREADY),
        .s_axi_wstrb(sting_wrap_0_M02_AXI_WSTRB),
        .s_axi_wuser(sting_wrap_0_M02_AXI_WUSER),
        .s_axi_wvalid(sting_wrap_0_M02_AXI_WVALID));
  design_1_axi_vip_4_0 axi_vip_4
       (.aclk(aclk_1),
        .aresetn(aresetn_1),
        .m_axi_araddr(axi_vip_4_M_AXI_ARADDR),
        .m_axi_arprot(axi_vip_4_M_AXI_ARPROT),
        .m_axi_arready(axi_vip_4_M_AXI_ARREADY),
        .m_axi_arvalid(axi_vip_4_M_AXI_ARVALID),
        .m_axi_awaddr(axi_vip_4_M_AXI_AWADDR),
        .m_axi_awprot(axi_vip_4_M_AXI_AWPROT),
        .m_axi_awready(axi_vip_4_M_AXI_AWREADY),
        .m_axi_awvalid(axi_vip_4_M_AXI_AWVALID),
        .m_axi_bready(axi_vip_4_M_AXI_BREADY),
        .m_axi_bresp(axi_vip_4_M_AXI_BRESP),
        .m_axi_bvalid(axi_vip_4_M_AXI_BVALID),
        .m_axi_rdata(axi_vip_4_M_AXI_RDATA),
        .m_axi_rready(axi_vip_4_M_AXI_RREADY),
        .m_axi_rresp(axi_vip_4_M_AXI_RRESP),
        .m_axi_rvalid(axi_vip_4_M_AXI_RVALID),
        .m_axi_wdata(axi_vip_4_M_AXI_WDATA),
        .m_axi_wready(axi_vip_4_M_AXI_WREADY),
        .m_axi_wstrb(axi_vip_4_M_AXI_WSTRB),
        .m_axi_wvalid(axi_vip_4_M_AXI_WVALID));
  design_1_sting_wrap_0_0 sting_wrap_0
       (.irq(sting_wrap_0_irq),
        .m00_axi_aclk(aclk_1),
        .m00_axi_araddr(sting_wrap_0_M00_AXI_ARADDR),
        .m00_axi_arburst(sting_wrap_0_M00_AXI_ARBURST),
        .m00_axi_arcache(sting_wrap_0_M00_AXI_ARCACHE),
        .m00_axi_aresetn(aresetn_1),
        .m00_axi_arid(sting_wrap_0_M00_AXI_ARID),
        .m00_axi_arlen(sting_wrap_0_M00_AXI_ARLEN),
        .m00_axi_arlock(sting_wrap_0_M00_AXI_ARLOCK),
        .m00_axi_arprot(sting_wrap_0_M00_AXI_ARPROT),
        .m00_axi_arqos(sting_wrap_0_M00_AXI_ARQOS),
        .m00_axi_arready(sting_wrap_0_M00_AXI_ARREADY),
        .m00_axi_aruser(sting_wrap_0_M00_AXI_ARUSER),
        .m00_axi_arvalid(sting_wrap_0_M00_AXI_ARVALID),
        .m00_axi_awaddr(sting_wrap_0_M00_AXI_AWADDR),
        .m00_axi_awburst(sting_wrap_0_M00_AXI_AWBURST),
        .m00_axi_awcache(sting_wrap_0_M00_AXI_AWCACHE),
        .m00_axi_awid(sting_wrap_0_M00_AXI_AWID),
        .m00_axi_awlen(sting_wrap_0_M00_AXI_AWLEN),
        .m00_axi_awlock(sting_wrap_0_M00_AXI_AWLOCK),
        .m00_axi_awprot(sting_wrap_0_M00_AXI_AWPROT),
        .m00_axi_awqos(sting_wrap_0_M00_AXI_AWQOS),
        .m00_axi_awready(sting_wrap_0_M00_AXI_AWREADY),
        .m00_axi_awuser(sting_wrap_0_M00_AXI_AWUSER),
        .m00_axi_awvalid(sting_wrap_0_M00_AXI_AWVALID),
        .m00_axi_bid(sting_wrap_0_M00_AXI_BID),
        .m00_axi_bready(sting_wrap_0_M00_AXI_BREADY),
        .m00_axi_bresp(sting_wrap_0_M00_AXI_BRESP),
        .m00_axi_buser(sting_wrap_0_M00_AXI_BUSER),
        .m00_axi_bvalid(sting_wrap_0_M00_AXI_BVALID),
        .m00_axi_init_axi_txn(init_axi_txn_1),
        .m00_axi_rdata(sting_wrap_0_M00_AXI_RDATA),
        .m00_axi_rid(sting_wrap_0_M00_AXI_RID),
        .m00_axi_rlast(sting_wrap_0_M00_AXI_RLAST),
        .m00_axi_rready(sting_wrap_0_M00_AXI_RREADY),
        .m00_axi_rresp(sting_wrap_0_M00_AXI_RRESP),
        .m00_axi_ruser(sting_wrap_0_M00_AXI_RUSER),
        .m00_axi_rvalid(sting_wrap_0_M00_AXI_RVALID),
        .m00_axi_wdata(sting_wrap_0_M00_AXI_WDATA),
        .m00_axi_wlast(sting_wrap_0_M00_AXI_WLAST),
        .m00_axi_wready(sting_wrap_0_M00_AXI_WREADY),
        .m00_axi_wstrb(sting_wrap_0_M00_AXI_WSTRB),
        .m00_axi_wuser(sting_wrap_0_M00_AXI_WUSER),
        .m00_axi_wvalid(sting_wrap_0_M00_AXI_WVALID),
        .m01_axi_aclk(aclk_1),
        .m01_axi_araddr(sting_wrap_0_M01_AXI_ARADDR),
        .m01_axi_aresetn(aresetn_1),
        .m01_axi_arprot(sting_wrap_0_M01_AXI_ARPROT),
        .m01_axi_arready(sting_wrap_0_M01_AXI_ARREADY),
        .m01_axi_arvalid(sting_wrap_0_M01_AXI_ARVALID),
        .m01_axi_awaddr(sting_wrap_0_M01_AXI_AWADDR),
        .m01_axi_awprot(sting_wrap_0_M01_AXI_AWPROT),
        .m01_axi_awready(sting_wrap_0_M01_AXI_AWREADY),
        .m01_axi_awvalid(sting_wrap_0_M01_AXI_AWVALID),
        .m01_axi_bready(sting_wrap_0_M01_AXI_BREADY),
        .m01_axi_bresp(sting_wrap_0_M01_AXI_BRESP),
        .m01_axi_bvalid(sting_wrap_0_M01_AXI_BVALID),
        .m01_axi_init_axi_txn(init_axi_txn_1),
        .m01_axi_rdata(sting_wrap_0_M01_AXI_RDATA),
        .m01_axi_rready(sting_wrap_0_M01_AXI_RREADY),
        .m01_axi_rresp(sting_wrap_0_M01_AXI_RRESP),
        .m01_axi_rvalid(sting_wrap_0_M01_AXI_RVALID),
        .m01_axi_wdata(sting_wrap_0_M01_AXI_WDATA),
        .m01_axi_wready(sting_wrap_0_M01_AXI_WREADY),
        .m01_axi_wstrb(sting_wrap_0_M01_AXI_WSTRB),
        .m01_axi_wvalid(sting_wrap_0_M01_AXI_WVALID),
        .m02_axi_aclk(aclk_1),
        .m02_axi_araddr(sting_wrap_0_M02_AXI_ARADDR),
        .m02_axi_arburst(sting_wrap_0_M02_AXI_ARBURST),
        .m02_axi_arcache(sting_wrap_0_M02_AXI_ARCACHE),
        .m02_axi_aresetn(aresetn_1),
        .m02_axi_arid(sting_wrap_0_M02_AXI_ARID),
        .m02_axi_arlen(sting_wrap_0_M02_AXI_ARLEN),
        .m02_axi_arlock(sting_wrap_0_M02_AXI_ARLOCK),
        .m02_axi_arprot(sting_wrap_0_M02_AXI_ARPROT),
        .m02_axi_arqos(sting_wrap_0_M02_AXI_ARQOS),
        .m02_axi_arready(sting_wrap_0_M02_AXI_ARREADY),
        .m02_axi_aruser(sting_wrap_0_M02_AXI_ARUSER),
        .m02_axi_arvalid(sting_wrap_0_M02_AXI_ARVALID),
        .m02_axi_awaddr(sting_wrap_0_M02_AXI_AWADDR),
        .m02_axi_awburst(sting_wrap_0_M02_AXI_AWBURST),
        .m02_axi_awcache(sting_wrap_0_M02_AXI_AWCACHE),
        .m02_axi_awid(sting_wrap_0_M02_AXI_AWID),
        .m02_axi_awlen(sting_wrap_0_M02_AXI_AWLEN),
        .m02_axi_awlock(sting_wrap_0_M02_AXI_AWLOCK),
        .m02_axi_awprot(sting_wrap_0_M02_AXI_AWPROT),
        .m02_axi_awqos(sting_wrap_0_M02_AXI_AWQOS),
        .m02_axi_awready(sting_wrap_0_M02_AXI_AWREADY),
        .m02_axi_awuser(sting_wrap_0_M02_AXI_AWUSER),
        .m02_axi_awvalid(sting_wrap_0_M02_AXI_AWVALID),
        .m02_axi_bid(sting_wrap_0_M02_AXI_BID),
        .m02_axi_bready(sting_wrap_0_M02_AXI_BREADY),
        .m02_axi_bresp(sting_wrap_0_M02_AXI_BRESP),
        .m02_axi_buser(sting_wrap_0_M02_AXI_BUSER),
        .m02_axi_bvalid(sting_wrap_0_M02_AXI_BVALID),
        .m02_axi_init_axi_txn(init_axi_txn_1),
        .m02_axi_rdata(sting_wrap_0_M02_AXI_RDATA),
        .m02_axi_rid(sting_wrap_0_M02_AXI_RID),
        .m02_axi_rlast(sting_wrap_0_M02_AXI_RLAST),
        .m02_axi_rready(sting_wrap_0_M02_AXI_RREADY),
        .m02_axi_rresp(sting_wrap_0_M02_AXI_RRESP),
        .m02_axi_ruser(sting_wrap_0_M02_AXI_RUSER),
        .m02_axi_rvalid(sting_wrap_0_M02_AXI_RVALID),
        .m02_axi_wdata(sting_wrap_0_M02_AXI_WDATA),
        .m02_axi_wlast(sting_wrap_0_M02_AXI_WLAST),
        .m02_axi_wready(sting_wrap_0_M02_AXI_WREADY),
        .m02_axi_wstrb(sting_wrap_0_M02_AXI_WSTRB),
        .m02_axi_wuser(sting_wrap_0_M02_AXI_WUSER),
        .m02_axi_wvalid(sting_wrap_0_M02_AXI_WVALID),
        .s00_axi_aclk(aclk_1),
        .s00_axi_araddr(axi_vip_0_M_AXI_ARADDR[7:0]),
        .s00_axi_aresetn(aresetn_1),
        .s00_axi_arprot(axi_vip_0_M_AXI_ARPROT),
        .s00_axi_arready(axi_vip_0_M_AXI_ARREADY),
        .s00_axi_arvalid(axi_vip_0_M_AXI_ARVALID),
        .s00_axi_awaddr(axi_vip_0_M_AXI_AWADDR[7:0]),
        .s00_axi_awprot(axi_vip_0_M_AXI_AWPROT),
        .s00_axi_awready(axi_vip_0_M_AXI_AWREADY),
        .s00_axi_awvalid(axi_vip_0_M_AXI_AWVALID),
        .s00_axi_bready(axi_vip_0_M_AXI_BREADY),
        .s00_axi_bresp(axi_vip_0_M_AXI_BRESP),
        .s00_axi_bvalid(axi_vip_0_M_AXI_BVALID),
        .s00_axi_rdata(axi_vip_0_M_AXI_RDATA),
        .s00_axi_rready(axi_vip_0_M_AXI_RREADY),
        .s00_axi_rresp(axi_vip_0_M_AXI_RRESP),
        .s00_axi_rvalid(axi_vip_0_M_AXI_RVALID),
        .s00_axi_wdata(axi_vip_0_M_AXI_WDATA),
        .s00_axi_wready(axi_vip_0_M_AXI_WREADY),
        .s00_axi_wstrb(axi_vip_0_M_AXI_WSTRB),
        .s00_axi_wvalid(axi_vip_0_M_AXI_WVALID),
        .s_axi_intr_aclk(aclk_1),
        .s_axi_intr_araddr(axi_vip_4_M_AXI_ARADDR[4:0]),
        .s_axi_intr_aresetn(aresetn_1),
        .s_axi_intr_arprot(axi_vip_4_M_AXI_ARPROT),
        .s_axi_intr_arready(axi_vip_4_M_AXI_ARREADY),
        .s_axi_intr_arvalid(axi_vip_4_M_AXI_ARVALID),
        .s_axi_intr_awaddr(axi_vip_4_M_AXI_AWADDR[4:0]),
        .s_axi_intr_awprot(axi_vip_4_M_AXI_AWPROT),
        .s_axi_intr_awready(axi_vip_4_M_AXI_AWREADY),
        .s_axi_intr_awvalid(axi_vip_4_M_AXI_AWVALID),
        .s_axi_intr_bready(axi_vip_4_M_AXI_BREADY),
        .s_axi_intr_bresp(axi_vip_4_M_AXI_BRESP),
        .s_axi_intr_bvalid(axi_vip_4_M_AXI_BVALID),
        .s_axi_intr_rdata(axi_vip_4_M_AXI_RDATA),
        .s_axi_intr_rready(axi_vip_4_M_AXI_RREADY),
        .s_axi_intr_rresp(axi_vip_4_M_AXI_RRESP),
        .s_axi_intr_rvalid(axi_vip_4_M_AXI_RVALID),
        .s_axi_intr_wdata(axi_vip_4_M_AXI_WDATA),
        .s_axi_intr_wready(axi_vip_4_M_AXI_WREADY),
        .s_axi_intr_wstrb(axi_vip_4_M_AXI_WSTRB),
        .s_axi_intr_wvalid(axi_vip_4_M_AXI_WVALID));
endmodule
