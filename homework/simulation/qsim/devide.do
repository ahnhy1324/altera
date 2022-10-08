onerror {quit -f}
vlib work
vlog -work work devide.vo
vlog -work work devide.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.divide_vlg_vec_tst
vcd file -direction devide.msim.vcd
vcd add -internal divide_vlg_vec_tst/*
vcd add -internal divide_vlg_vec_tst/i1/*
add wave /*
run -all
