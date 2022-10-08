library verilog;
use verilog.vl_types.all;
entity smul_vlg_check_tst is
    port(
        product         : in     vl_logic_vector(7 downto 0);
        ready           : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end smul_vlg_check_tst;
