echo "creating 'work' lib"
vlib work

echo "compile verification classes"
vlog -sv top.sv
vlog -sv environment.sv
vlog -sv checker.sv
vlog -sv scoreboard.sv
vlog -sv generator.sv
vlog -sv transaction.sv
vlog -sv ALU_monitor.sv
vlog -sv ALU_driver.sv
vlog -sv ALU_iface.sv
vlog -sv test.sv

echo "compile 'DUT'"
vcom ALU.vhdl