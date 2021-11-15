echo "creating 'work' lib"
vlib work

echo "compile verification classes"
vlog -sv top.sv
vlog -sv environment.sv
vlog -sv checker.sv
vlog -sv scoreboard.sv
vlog -sv generator.sv
vlog -sv opcode.sv
vlog -sv probe.sv
vlog -sv gbp_monitor.sv
vlog -sv gbp_iface.sv
vlog -sv model.sv
vlog -sv test.sv

echo "compile 'DUT'"
vcom ALU.vhdl
vcom gbprocessor.vhdl