@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim reg_rw_tb_behav -key {Behavioral:register_rw:Functional:reg_rw_tb} -tclbatch reg_rw_tb.tcl -view C:/home/myproj/sting/vivado/zybo/sting_ip/reg_rw_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
