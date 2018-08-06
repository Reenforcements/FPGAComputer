onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White -radix hexadecimal /SerialCommandProcessor_TB/clk
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/rst
add wave -noupdate -color {Orange Red} -radix hexadecimal /SerialCommandProcessor_TB/RX
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/RX_ready
add wave -noupdate -color Cyan -radix hexadecimal /SerialCommandProcessor_TB/TX
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/start_TX
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/TX_ready
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/writeToMemory
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/readFromMemory
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/memoryAddress
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/memoryWordOut
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/memoryWordIn
add wave -noupdate -color Magenta /SerialCommandProcessor_TB/scp/SCP_state
add wave -noupdate /SerialCommandProcessor_TB/scp/WordTX_done
add wave -noupdate -radix decimal /SerialCommandProcessor_TB/scp/currentStep
add wave -noupdate /SerialCommandProcessor_TB/scp/waitForTX
add wave -noupdate /SerialCommandProcessor_TB/scp/WordTX_start
add wave -noupdate -color Yellow -radix decimal /SerialCommandProcessor_TB/scp/wordsSent
add wave -noupdate -color Magenta /SerialCommandProcessor_TB/scp/WordTX_state
add wave -noupdate /SerialCommandProcessor_TB/scp/WordTX_nextState
add wave -noupdate /SerialCommandProcessor_TB/scp/WordTX_done
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/scp/WordTX_word
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/scp/WordTX_word_next
add wave -noupdate -radix hexadecimal /SerialCommandProcessor_TB/scp/WordTX_word_reg
add wave -noupdate /SerialCommandProcessor_TB/scp/RXComplete
add wave -noupdate /SerialCommandProcessor_TB/scp/TXComplete
add wave -noupdate /SerialCommandProcessor_TB/scp/command
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14311 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 382
configure wave -valuecolwidth 100
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
WaveRestoreZoom {14030 ps} {14755 ps}
