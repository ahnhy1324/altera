library verilog;
use verilog.vl_types.all;
entity mulmul is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        word1           : in     vl_logic_vector(3 downto 0);
        word2           : in     vl_logic_vector(3 downto 0);
        product         : out    vl_logic_vector(7 downto 0);
        ready           : out    vl_logic;
        sign            : in     vl_logic
    );
end mulmul;
