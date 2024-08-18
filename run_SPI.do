vlib work
vlog SPI_wrapper.v SPI_wrapper_tb.v
vsim -voptargs=+acc work.SPI_wrapper_tb
#add wave *
add wave /SPI_wrapper_tb/test/SPI_1/*
run -all
#quit -sim