do compile.do

vlib work

vsim -voptargs="+acc" -msgmode both ahb_arbiter_tb

add wave sim:/ahb_arbiter_tb/HRESETn
add wave sim:/ahb_arbiter_tb/HCLK

add wave -divider DEBUG
add wave sim:/ahb_arbiter_tb/HMASTER
add wave sim:/ahb_arbiter_tb/HGRANTx

add wave -divider SHARED
add wave sim:/ahb_arbiter_tb/HREADY
add wave sim:/ahb_arbiter_tb/HMASTLOCK

add wave -divider MASTER_0
add wave sim:/ahb_arbiter_tb/HBUSREQx(0)
add wave sim:/ahb_arbiter_tb/HLOCKx(0)
add wave sim:/ahb_arbiter_tb/HGRANTx(0)
add wave sim:/ahb_arbiter_tb/ready_indiv(0)

add wave -divider MASTER_1
add wave sim:/ahb_arbiter_tb/HBUSREQx(1)
add wave sim:/ahb_arbiter_tb/HLOCKx(1)
add wave sim:/ahb_arbiter_tb/HGRANTx(1)
add wave sim:/ahb_arbiter_tb/ready_indiv(1)

add wave -divider MASTER_2
add wave sim:/ahb_arbiter_tb/HBUSREQx(2)
add wave sim:/ahb_arbiter_tb/HLOCKx(2)
add wave sim:/ahb_arbiter_tb/HGRANTx(2)
add wave sim:/ahb_arbiter_tb/ready_indiv(2)

add wave -divider MASTER_3
add wave sim:/ahb_arbiter_tb/HBUSREQx(3)
add wave sim:/ahb_arbiter_tb/HLOCKx(3)
add wave sim:/ahb_arbiter_tb/HGRANTx(3)
add wave sim:/ahb_arbiter_tb/ready_indiv(3)


restart -f

run 2.5 us;

configure wave -signalnamewidth 1
WaveRestoreZoom {0 ps} {2500000 ps}
