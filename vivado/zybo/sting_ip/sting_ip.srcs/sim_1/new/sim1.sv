`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/02 20:39:37
// Design Name: 
// Module Name: sim1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
//import axi_vip_v1_0_2_pkg::*;
//import ex_sim_axi_vip_slv_0_pkg::*;

module sim1_tb();

    localparam int LP_CLK_PERI = 10;
    localparam int LP_RST_PERI = 50;

    // DUT instance
    logic aresetn, aclk;
    wire irq;
   design_1_wrapper design_1_wrapper(
    .aclk(aclk),
    .aresetn(aresetn),
    .irq(irq));
    
    task rst_gen();
        aresetn = '0;
        #(LP_RST_PERI);
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
//    design_1_axi_vip_0_1   agent;

//    task init_agent();
//        agent = new("master vip agent", dut.sys_i.design_1_axi_vip_0_1.inst.IF);
//        agent.start_master();
//    endtask
    // Testscenario
    initial begin

        fork
  //          init_agent();
            clk_gen();
            rst_gen();
        join_none

        clk_dly(100);


        clk_dly(100);


        clk_dly(100);
        $finish(2);
    end
endmodule

