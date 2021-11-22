echo "creating 'work' lib"
vlib work

echo "compile verification classes"
vlog -sv top.sv -cover bcestf
vlog -sv environment.sv -cover bcestf
vlog -sv checker.sv -cover bcestf
vlog -sv scoreboard.sv -cover bcestf
vlog -sv generator.sv -cover bcestf
vlog -sv opcode.sv -cover bcestf
vlog -sv probe.sv -cover bcestf
vlog -sv gbp_monitor.sv -cover bcestf
vlog -sv gbp_iface.sv -cover bcestf
vlog -sv model.sv -cover bcestf
vlog -sv test.sv -cover bcestf

echo "compile 'DUT'"
vcom ALU.vhd
vcom gbprocessor.vhd