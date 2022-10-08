library verilog;
use verilog.vl_types.all;
entity clk1hz is
    port(
        clk50           : in     vl_logic;
        clk1            : out    vl_logic
    );
end clk1hz;
