## Generated SDC file "MIPSProcessor.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"

## DATE    "Tue Jul 31 14:12:01 2018"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clkIn} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clkIn}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clk} -source [get_ports {clkIn}] -divide_by 6 -master_clock {clkIn} [get_nets {clk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clkIn}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clkIn}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clkIn}] -rise_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clkIn}] -fall_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clkIn}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clkIn}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clkIn}] -rise_to [get_clocks {clkIn}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clkIn}] -fall_to [get_clocks {clkIn}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

