onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Testing/clk
add wave -noupdate /Testing/rst
add wave -noupdate /Testing/inp1
add wave -noupdate /Testing/out1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
view wave 
wave clipboard store
wave create -pattern none -portmode input -language vlog /Testing/clk 
wave create -pattern none -portmode input -language vlog /Testing/rst 
wave create -pattern none -portmode input -language vlog /Testing/inp1 
wave create -pattern none -portmode output -language vlog -range 1 0 /Testing/out1 
wave modify -driver freeze -pattern clock -initialvalue (no value) -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps Edit:/Testing/clk 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 100ps Edit:/Testing/rst 
wave modify -driver freeze -pattern constant -value 0 -starttime 100ps -endtime 1000ps Edit:/Testing/rst 
wave modify -driver freeze -pattern constant -value 1 -starttime 200ps -endtime 1000ps Edit:/Testing/rst 
WaveCollapseAll -1
wave clipboard restore
