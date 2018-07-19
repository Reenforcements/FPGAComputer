transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/Quartus {/home/imaustyn/Desktop/FPGAComputer/Quartus/RAM32Bit.v}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/RegisterFile.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/PC.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Memory.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Branch.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/ALU.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Control.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Processor.sv}

