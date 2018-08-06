onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /Main_TB/clk
add wave -noupdate -radix hexadecimal /Main_TB/RS232_RX
add wave -noupdate -radix hexadecimal /Main_TB/Main_LED1
add wave -noupdate -radix hexadecimal /Main_TB/Main_LED2
add wave -noupdate -color {Yellow Green} -radix hexadecimal /Main_TB/Main_LED3
add wave -noupdate /Main_TB/main/rst
add wave -noupdate /Main_TB/main/rstIn
add wave -noupdate -color {Orange Red} -radix hexadecimal /Main_TB/RS232_TX
add wave -noupdate -color {Orange Red} /Main_TB/RS232_start_TX
add wave -noupdate -color {Orange Red} /Main_TB/RS232_TX_ready
add wave -noupdate -color Cyan -radix hexadecimal /Main_TB/main/RX
add wave -noupdate -color Cyan -radix hexadecimal /Main_TB/main/hasRX
add wave -noupdate -radix decimal -childformat {{{/Main_TB/main/rs/RX_counter[31]} -radix decimal} {{/Main_TB/main/rs/RX_counter[30]} -radix decimal} {{/Main_TB/main/rs/RX_counter[29]} -radix decimal} {{/Main_TB/main/rs/RX_counter[28]} -radix decimal} {{/Main_TB/main/rs/RX_counter[27]} -radix decimal} {{/Main_TB/main/rs/RX_counter[26]} -radix decimal} {{/Main_TB/main/rs/RX_counter[25]} -radix decimal} {{/Main_TB/main/rs/RX_counter[24]} -radix decimal} {{/Main_TB/main/rs/RX_counter[23]} -radix decimal} {{/Main_TB/main/rs/RX_counter[22]} -radix decimal} {{/Main_TB/main/rs/RX_counter[21]} -radix decimal} {{/Main_TB/main/rs/RX_counter[20]} -radix decimal} {{/Main_TB/main/rs/RX_counter[19]} -radix decimal} {{/Main_TB/main/rs/RX_counter[18]} -radix decimal} {{/Main_TB/main/rs/RX_counter[17]} -radix decimal} {{/Main_TB/main/rs/RX_counter[16]} -radix decimal} {{/Main_TB/main/rs/RX_counter[15]} -radix decimal} {{/Main_TB/main/rs/RX_counter[14]} -radix decimal} {{/Main_TB/main/rs/RX_counter[13]} -radix decimal} {{/Main_TB/main/rs/RX_counter[12]} -radix decimal} {{/Main_TB/main/rs/RX_counter[11]} -radix decimal} {{/Main_TB/main/rs/RX_counter[10]} -radix decimal} {{/Main_TB/main/rs/RX_counter[9]} -radix decimal} {{/Main_TB/main/rs/RX_counter[8]} -radix decimal} {{/Main_TB/main/rs/RX_counter[7]} -radix decimal} {{/Main_TB/main/rs/RX_counter[6]} -radix decimal} {{/Main_TB/main/rs/RX_counter[5]} -radix decimal} {{/Main_TB/main/rs/RX_counter[4]} -radix decimal} {{/Main_TB/main/rs/RX_counter[3]} -radix decimal} {{/Main_TB/main/rs/RX_counter[2]} -radix decimal} {{/Main_TB/main/rs/RX_counter[1]} -radix decimal} {{/Main_TB/main/rs/RX_counter[0]} -radix decimal}} -subitemconfig {{/Main_TB/main/rs/RX_counter[31]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[30]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[29]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[28]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[27]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[26]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[25]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[24]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[23]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[22]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[21]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[20]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[19]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[18]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[17]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[16]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[15]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[14]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[13]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[12]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[11]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[10]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[9]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[8]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[7]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[6]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[5]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[4]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[3]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[2]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[1]} {-height 16 -radix decimal} {/Main_TB/main/rs/RX_counter[0]} {-height 16 -radix decimal}} /Main_TB/main/rs/RX_counter
add wave -noupdate -radix decimal /Main_TB/n
add wave -noupdate -radix decimal /Main_TB/g
add wave -noupdate /Main_TB/main/serialCP/SCP_state
add wave -noupdate -radix decimal /Main_TB/main/serialCP/currentStep
add wave -noupdate -radix symbolic /Main_TB/main/serialCP/command
add wave -noupdate -radix hexadecimal /Main_TB/main/serialCP/memoryWordIn
add wave -noupdate -radix hexadecimal /Main_TB/main/serialCP/memoryAddress
add wave -noupdate -radix decimal /Main_TB/main/serialCP/memory_startAddress
add wave -noupdate -radix hexadecimal /Main_TB/main/externalData
add wave -noupdate -radix hexadecimal /Main_TB/main/externalDataOut
add wave -noupdate /Main_TB/main/serialCP_writeToMemory
add wave -noupdate /Main_TB/main/serialCP_readFromMemory
add wave -noupdate -radix hexadecimal /Main_TB/main/processor/mem/data
add wave -noupdate -radix hexadecimal /Main_TB/main/processor/mem/q_a
add wave -noupdate -radix hexadecimal /Main_TB/main/processor/mem/address_d0
add wave -noupdate -radix symbolic /Main_TB/main/processor/mem/readMode_d0
add wave -noupdate /Main_TB/main/processor/mem/unsignedLoad_d0
add wave -noupdate -radix hexadecimal /Main_TB/main/processor/mem/rden_a_d0
add wave -noupdate /Main_TB/main/processor/mem/writeMode
add wave -noupdate /Main_TB/main/processor/mem/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {72972 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 351
configure wave -valuecolwidth 158
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {79945 ps} {80003 ps}
