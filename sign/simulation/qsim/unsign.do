onerror {quit -f}
vlib work
vlog -work work unsign.vo
vlog -work work unsign.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.unsign_vlg_vec_tst
vcd file -direction unsign.msim.vcd
vcd add -internal unsign_vlg_vec_tst/*
vcd add -internal unsign_vlg_vec_tst/i1/*
add wave /*
run -all
