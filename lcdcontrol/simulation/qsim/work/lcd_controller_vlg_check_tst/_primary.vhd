library verilog;
use verilog.vl_types.all;
entity lcd_controller_vlg_check_tst is
    port(
        LCD_E           : in     vl_logic;
        LCD_RS          : in     vl_logic;
        LCD_RW          : in     vl_logic;
        LCD_data        : in     vl_logic_vector(7 downto 0);
        done            : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end lcd_controller_vlg_check_tst;
