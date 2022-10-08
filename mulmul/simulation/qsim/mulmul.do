onerror {quit -f}
vlib work
vlog -work work mulmul.vo
vlog -work work mulmul.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.mulmul_vlg_vec_tst
vcd file -direction mulmul.msim.vcd
vcd add -internal mulmul_vlg_vec_tst/*
vcd add -internal mulmul_vlg_vec_tst/i1/*
add wave /*
run -all
