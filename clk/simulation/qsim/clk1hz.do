onerror {quit -f}
vlib work
vlog -work work clk1hz.vo
vlog -work work clk1hz.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.clk1hz_vlg_vec_tst
vcd file -direction clk1hz.msim.vcd
vcd add -internal clk1hz_vlg_vec_tst/*
vcd add -internal clk1hz_vlg_vec_tst/i1/*
add wave /*
run -all
