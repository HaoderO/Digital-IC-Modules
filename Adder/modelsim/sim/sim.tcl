quit -sim

.main clear

vlib work

vmap work work

vlog ./../../sources/*.v
vlog ./../*.v

vsim -voptargs=+acc work.adder_tb

add wave -divider {sobel}
add wave /adder_tb/adder_inst/*

run -all