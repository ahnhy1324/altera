vlog -work work D:/altera/test/simulation/modelsim/Waveform.vwf.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.div_vlg_vec_tst
onerror {resume}
add wave {div_vlg_vec_tst/i1/clk}
add wave {div_vlg_vec_tst/i1/quotient}
add wave {div_vlg_vec_tst/i1/quotient[3]}
add wave {div_vlg_vec_tst/i1/quotient[2]}
add wave {div_vlg_vec_tst/i1/quotient[1]}
add wave {div_vlg_vec_tst/i1/quotient[0]}
add wave {div_vlg_vec_tst/i1/ready}
add wave {div_vlg_vec_tst/i1/remainder}
add wave {div_vlg_vec_tst/i1/remainder[3]}
add wave {div_vlg_vec_tst/i1/remainder[2]}
add wave {div_vlg_vec_tst/i1/remainder[1]}
add wave {div_vlg_vec_tst/i1/remainder[0]}
add wave {div_vlg_vec_tst/i1/reset}
add wave {div_vlg_vec_tst/i1/start}
add wave {div_vlg_vec_tst/i1/word1}
add wave {div_vlg_vec_tst/i1/word1[7]}
add wave {div_vlg_vec_tst/i1/word1[6]}
add wave {div_vlg_vec_tst/i1/word1[5]}
add wave {div_vlg_vec_tst/i1/word1[4]}
add wave {div_vlg_vec_tst/i1/word1[3]}
add wave {div_vlg_vec_tst/i1/word1[2]}
add wave {div_vlg_vec_tst/i1/word1[1]}
add wave {div_vlg_vec_tst/i1/word1[0]}
add wave {div_vlg_vec_tst/i1/word2}
add wave {div_vlg_vec_tst/i1/word2[3]}
add wave {div_vlg_vec_tst/i1/word2[2]}
add wave {div_vlg_vec_tst/i1/word2[1]}
add wave {div_vlg_vec_tst/i1/word2[0]}
run -all
