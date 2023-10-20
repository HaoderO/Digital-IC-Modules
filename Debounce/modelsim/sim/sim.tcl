quit -sim

.main clear

vlib work

vmap work work

vlog ./../../src/*.v
vlog ./../*.v

vsim -voptargs=+acc work.debounce_tb

add wave -divider {debounce_h}
add wave -divider {debounce_l}
add wave -divider {debounce_hl}

add wave /debounce_tb/*

run -all