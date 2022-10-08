library verilog;
use verilog.vl_types.all;
entity lcd_controller is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        RS              : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        done            : out    vl_logic;
        LCD_RS          : out    vl_logic;
        LCD_RW          : out    vl_logic;
        LCD_E           : out    vl_logic;
        LCD_data        : out    vl_logic_vector(7 downto 0)
    );
end lcd_controller;
