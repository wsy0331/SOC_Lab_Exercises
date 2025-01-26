library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all;

entity DualCounter is
    Port (
        i_clk       : in  std_logic;                      -- 時鐘訊號
        i_rst       : in  std_logic;                      -- 重置訊號
        i_count_up1 : in  std_logic;                    -- 計數器 1 上數/下數控制
        i_count_up2 : in  std_logic;                    -- 計數器 2 上數/下數控制
        i_min       : in std_logic_vector(3 downto 0);   -- 計數器最小值
        i_max       : in std_logic_vector(3 downto 0);   -- 計數器最大值
        o_led       : out std_logic_vector(7 downto 0)   -- LED 輸出
    );
end DualCounter;

architecture Behavioral of DualCounter is
    type state_type is (IDLE, INCREMENT, DECREMENT);  -- 狀態類型定義
    signal state   : state_type := IDLE;              -- 初始狀態設為 IDLE
    signal count1  : std_logic_vector(3 downto 0) := (others => '0');
    signal count2  : std_logic_vector(3 downto 0) := (others => '0');
    signal div_cnt : std_logic_vector(23 downto 0) := (others => '0'); -- 分頻計數器 (0~23)

begin
    -- LED 輸出對應
    o_led(3 downto 0) <= count1;
    o_led(7 downto 4) <= count2;

    -- 除頻器：除頻 2^24
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            div_cnt <= (others => '0');
        elsif rising_edge(i_clk) then
            div_cnt <= div_cnt + 1;
        end if;
    end process;

    -- FSM 狀態轉換邏輯
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            state <= IDLE;
        elsif rising_edge(i_clk) then
            case state is
                when IDLE =>
                    -- 在 IDLE 狀態下，如果 i_min 按鈕被按下，進入 DECREMENT 狀態
                    if i_min = "0001" then
                        state <= DECREMENT;
                    -- 如果 i_max 按鈕被按下，則進入 INCREMENT 狀態
                    elsif i_max = "0001" then
                        state <= INCREMENT;
                    else
                        state <= IDLE; -- 默認保持在 IDLE
                    end if;

                when INCREMENT =>
                    -- 如果 count1 達到 i_max，則轉換回 IDLE 狀態
                    if count1 = i_max then
                        state <= IDLE;
                    end if;

                when DECREMENT =>
                    -- 如果 count1 達到 i_min，則轉換回 IDLE 狀態
                    if count1 = i_min then
                        state <= IDLE;
                    end if;

                when others =>
                    state <= IDLE; -- 如果是未知狀態，則回到 IDLE
            end case;
        end if;
    end process;

    -- 計數器進行動
    process(div_cnt, i_rst, i_count_up1, i_count_up2)
    begin
        if i_rst = '1' then
            count1 <= i_min;
            count2 <= i_min;
        elsif rising_edge(div_cnt(23)) then
            -- 計數器 1 邏輯
            if i_count_up1 = '1' then
                if count1 < i_max then
                    count1 <= count1 + 1;
                else
                    count1 <= i_min;  -- 超過上限回到下限
                end if;
            else
                if count1 > i_min then
                    count1 <= count1 - 1;
                else
                    count1 <= i_max;  -- 低於下限回到上限
                end if;
            end if;

            -- 計數器 2 邏輯
            if i_count_up2 = '1' then
                if count2 < i_max then
                    count2 <= count2 + 1;
                else
                    count2 <= i_min;  -- 超過上限回到下限
                end if;
            else
                if count2 > i_min then
                    count2 <= count2 - 1;
                else
                    count2 <= i_max;  -- 低於下限回到上限
                end if;
            end if;
        end if;
    end process;

end Behavioral;
