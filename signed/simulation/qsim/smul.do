onerror {quit -f}
vlib work
vlog -work work smul.vo
vlog -work work smul.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.smul_vlg_vec_tst
vcd file -direction smul.msim.vcd
vcd add -internal smul_vlg_vec_tst/*
vcd add -internal smul_vlg_vec_tst/i1/*
add wave /*
run -all
