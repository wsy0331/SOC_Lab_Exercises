library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity table_tennis_tb is
    -- 測試檔不需要埠宣告
end table_tennis_tb;

architecture Behavioral of table_tennis_tb is

    -- 宣告待測單元 (Unit Under Test, UUT) 的元件
    component table_tennis
        Port (
            i_rst  : in std_logic;  -- 系統重置訊號
            i_clk  : in std_logic;  -- 系統時脈訊號
            i_btn_l : in std_logic; -- 左邊玩家按鍵
            i_btn_r : in std_logic; -- 右邊玩家按鍵
            o_led  : out std_logic_vector (7 downto 0) -- LED 輸出顯示
        );
    end component;

    -- 測試信號宣告
    signal i_rst  : std_logic := '0';                  -- 重置訊號
    signal i_clk  : std_logic := '0';                  -- 時脈訊號
    signal i_btn_l : std_logic := '0';                 -- 左按鍵
    signal i_btn_r : std_logic := '0';                 -- 右按鍵
    signal o_led  : std_logic_vector (7 downto 0);     -- LED 輸出

    -- 時脈週期設定，1 MHz 時脈 (1us 週期)
    constant CLK_PERIOD : time := 1 us;

begin

    -- 待測單元 (UUT) 的實例化
    uut: table_tennis
        port map (
            i_rst  => i_rst,    -- 連接重置訊號
            i_clk  => i_clk,    -- 連接時脈訊號
            i_btn_l => i_btn_l, -- 連接左按鍵訊號
            i_btn_r => i_btn_r, -- 連接右按鍵訊號
            o_led  => o_led     -- 連接 LED 輸出
        );

    -- 時脈產生程序
    clk_process : process
    begin
        while now < 10 ms loop  -- 模擬 10 毫秒的時脈
            i_clk <= '0';
            wait for CLK_PERIOD / 2; -- 時脈低電位保持時間
            i_clk <= '1';
            wait for CLK_PERIOD / 2; -- 時脈高電位保持時間
        end loop;
        wait; -- 結束模擬
    end process;

    -- 測試刺激程序
    stimulus_process : process
    begin
        -- 初始重置
        i_rst <= '0';            -- 將重置訊號設為低電位
        wait for 2 * CLK_PERIOD; -- 等待兩個時脈週期
        i_rst <= '1';            -- 解除重置訊號
        wait for 2 * CLK_PERIOD; -- 等待系統穩定

        -- 模擬 8 毫秒內的正常對打
        -- 第一次右鍵按下
        i_btn_r <= '1';          -- 按下右鍵
        wait for 4 ms;           -- 右鍵保持按下 4 毫秒
        i_btn_r <= '0';          -- 釋放右鍵
        wait for 4 ms;           -- 等待左鍵操作

        -- 第一次左鍵按下
        i_btn_l <= '1';          -- 按下左鍵
        wait for 4 ms;           -- 左鍵保持按下 4 毫秒
        i_btn_l <= '0';          -- 釋放左鍵
        wait for 4 ms;           -- 等待右鍵操作

        -- 第二次右鍵按下
        i_btn_r <= '1';          -- 按下右鍵
        wait for 4 ms;           -- 右鍵保持按下 4 毫秒
        i_btn_r <= '0';          -- 釋放右鍵
        wait for 4 ms;           -- 等待左鍵操作

        -- 第二次左鍵按下
        i_btn_l <= '1';          -- 按下左鍵
        wait for 4 ms;           -- 左鍵保持按下 4 毫秒
        i_btn_l <= '0';          -- 釋放左鍵

        -- 結束模擬，觀察結果
        wait for 1 ms;

        wait; -- 模擬結束
    end process;

end Behavioral;
