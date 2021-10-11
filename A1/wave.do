onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/ALU_interface/clock
add wave -noupdate -divider In
add wave -noupdate -radix hexadecimal /top/ALU_interface/data_a
add wave -noupdate -radix hexadecimal /top/ALU_interface/data_b
add wave -noupdate -radix binary /top/ALU_interface/flags_in
add wave -noupdate -radix binary /top/ALU_interface/operation
add wave -noupdate -divider Out
add wave -noupdate -radix hexadecimal /top/ALU_interface/data_z
add wave -noupdate -radix binary /top/ALU_interface/flags_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68380 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 42
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {457470 ps}
