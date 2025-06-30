library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pingpong_gpio_tb is
end entity;

architecture sim of Pingpong_gpio_tb is

    -- DUT (Device Under Test) ports
    signal clk    : std_logic := '0';
    signal rst_n  : std_logic := '1'; -- 主動低
    signal btn_A  : std_logic := '0';
    signal btn_B  : std_logic := '0';
    signal gpio_AB: std_logic := 'Z'; -- 兩塊板子的io_gpio
    signal led_A  : std_logic_vector(7 downto 0);
    signal led_B  : std_logic_vector(7 downto 0);

    -- 方便切換正負緣
    signal rst    : std_logic;

begin

    rst <= not rst_n;

    -- clock
    clk_gen: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- 板子A
    UUT_A: entity work.Pingpong_gpio
        port map (
            i_clk   => clk,
            i_rst   => rst,
            i_btn   => btn_A,
            io_gpio => gpio_AB,
            o_led   => led_A
        );

    -- 板子B
    UUT_B: entity work.Pingpong_gpio
        port map (
            i_clk   => clk,
            i_rst   => rst,
            i_btn   => btn_B,
            io_gpio => gpio_AB,
            o_led   => led_B
        );

    -- 測試情境
    stim_proc: process
    begin
        -- 初始化
        rst_n <= '0'; wait for 50 ns;
        rst_n <= '1'; wait for 50 ns;
        btn_A <= '0'; btn_B <= '0';

        -- 1. 正常雙方對打（A->B->A->B...）
        wait for 100 ns;
        btn_A <= '1';          -- A擊球
        wait for 20 ns;
        btn_A <= '0';
        wait for 2000 ns;      -- 等待球到B

        btn_B <= '1';          -- B擊球
        wait for 20 ns;
        btn_B <= '0';
        wait for 2000 ns;      -- 等待球到A

        btn_A <= '1';          -- 再A擊球
        wait for 20 ns;
        btn_A <= '0';
        wait for 2000 ns;

        btn_B <= '1';          -- B擊球
        wait for 20 ns;
        btn_B <= '0';
        wait for 1000 ns;

        -- 2. B提前擊球（球尚未到B時就按下）
        btn_A <= '1';
        wait for 20 ns;
        btn_A <= '0';
        wait for 1000 ns;

        -- 3. A漏接球（球到A但沒按）
        -- 等球到A但不按
        wait for 3000 ns;

        -- 結束
        wait;
    end process;

end sim;