library verilog;
use verilog.vl_types.all;
entity clk1hz_vlg_sample_tst is
    port(
        clk50           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end clk1hz_vlg_sample_tst;
