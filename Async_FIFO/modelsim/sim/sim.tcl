quit -sim

.main clear

vlib work

vmap work work

vlog ./../../rtl/*.v
vlog ./../*.v

vsim -voptargs=+acc work.async_fifo_tb

add wave -divider {async_fifo}

add wave /async_fifo_tb/*

run -all