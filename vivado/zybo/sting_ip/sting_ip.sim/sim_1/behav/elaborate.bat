@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto e114580bb8f94c17800037a6e5f74a91 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L axi_infrastructure_v1_1_0 -L xil_common_vip_v1_0_0 -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_14 -L axi_vip_v1_0_2 -L work -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot sim1_tb_behav work.sim1_tb work.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
