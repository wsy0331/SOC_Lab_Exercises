library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all;

entity tb_speed_ball is
-- Testbench 不需要任何 Port
end tb_speed_ball;

architecture sim of tb_speed_ball is

    -- 測試檔內部訊號
    signal i_rst   : std_logic;
    signal i_clk   : std_logic := '0';
    signal i_btn_l : std_logic;
    signal i_btn_r : std_logic;
    signal o_led   : std_logic_vector(7 downto 0);

    -- 時脈週期常數
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 例化被測模組 (DUT, Design Under Test)
    uut: entity work.speed_ball
        port map (
            i_rst   => i_rst,
            i_clk   => i_clk,
            i_btn_l => i_btn_l,
            i_btn_r => i_btn_r,
            o_led   => o_led
        );

    -- 產生時脈訊號
    clk_gen: process
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- 測試流程
    stim_proc: process
    begin
        -- 初始化
        i_rst   <= '0';
        i_btn_l <= '0';
        i_btn_r <= '0';
        wait for 20 ns;

        -- 釋放重置
        i_rst <= '1';
        wait for 20 ns;

        -- 測試按下右按鈕，移動到左側
        i_btn_r <= '1';
        wait for 50 ns;
        i_btn_r <= '0';

--        -- 測試按下左按鈕，移動到右側
--        wait for 100 ns;
--        i_btn_l <= '1';
--        wait for 50 ns;
--        i_btn_l <= '0';

--        -- 測試左側得分
--        wait for 200 ns;
--        i_btn_l <= '1';
--        wait for 50 ns;
--        i_btn_l <= '0';

--        -- 測試右側得分
--        wait for 200 ns;
--        i_btn_r <= '1';
--        wait for 50 ns;
--        i_btn_r <= '0';

--        -- 測試完整分數累積
--        wait for 500 ns;
--        for i in 0 to 15 loop
--            i_btn_r <= '1';
--            wait for 20 ns;
--            i_btn_r <= '0';
--            wait for 100 ns;
--        end loop;

        -- 結束模擬
        wait;
    end process;

end sim;
