do "compile.do"
vsim -voptargs=“+acc” top

# add wave -noupdate /top/theInterface/clock
# add wave -noupdate -divider In
# add wave -noupdate /top/theInterface/operation
# add wave -noupdate /top/theInterface/data_a
# add wave -noupdate /top/theInterface/data_b
# add wave -noupdate /top/theInterface/flags_in
# add wave -noupdate -divider Out
# add wave -noupdate /top/theInterface/data_z
# add wave -noupdate /top/theInterface/flags_out

# run -a
run 10 us

do "coverage.do"