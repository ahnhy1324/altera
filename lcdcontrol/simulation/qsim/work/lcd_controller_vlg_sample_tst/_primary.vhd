library verilog;
use verilog.vl_types.all;
entity lcd_controller_vlg_sample_tst is
    port(
        RS              : in     vl_logic;
        clk             : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end lcd_controller_vlg_sample_tst;
