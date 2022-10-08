library verilog;
use verilog.vl_types.all;
entity divide is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        word1           : in     vl_logic_vector(7 downto 0);
        word2           : in     vl_logic_vector(3 downto 0);
        quotient        : out    vl_logic_vector(3 downto 0);
        remainder       : out    vl_logic_vector(3 downto 0);
        ready           : out    vl_logic
    );
end divide;
