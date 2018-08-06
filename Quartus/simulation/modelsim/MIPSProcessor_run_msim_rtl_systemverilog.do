transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/Quartus {/home/imaustyn/Desktop/FPGAComputer/Quartus/RAM32Bit.v}
vlib ProcessorClockEnabler
vmap ProcessorClockEnabler ProcessorClockEnabler
vlog -sv -work ProcessorClockEnabler +incdir+/home/imaustyn/Desktop/FPGAComputer/Quartus/ProcessorClockEnabler/synthesis {/home/imaustyn/Desktop/FPGAComputer/Quartus/ProcessorClockEnabler/synthesis/ProcessorClockEnabler.v}
vlog -sv -work ProcessorClockEnabler +incdir+/home/imaustyn/Desktop/FPGAComputer/Quartus/ProcessorClockEnabler/synthesis/submodules {/home/imaustyn/Desktop/FPGAComputer/Quartus/ProcessorClockEnabler/synthesis/submodules/ProcessorClockEnabler_altclkctrl_0.v}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/SerialCommandProcessor.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/RS232.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/RegisterFile.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/PC.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Memory.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Branch.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/ALU.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Control.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Main.sv}
vlog -sv -work work +incdir+/home/imaustyn/Desktop/FPGAComputer/HDL {/home/imaustyn/Desktop/FPGAComputer/HDL/Processor.sv}

