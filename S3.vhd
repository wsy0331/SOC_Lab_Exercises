library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all; 
 
entity two_counter is 
    port ( 
        i_clk    : in std_logic; 
        i_rst    : in std_logic; 
        o_count1 : out std_logic_vector(3 downto 0); 
        o_count2 : out std_logic_vector(3 downto 0) 
    ); 
end two_counter; 
 
architecture Behavioral of two_counter is 
    signal count1  : std_logic_vector(3 downto 0); 
    signal count2  : std_logic_vector(3 downto 0); 
    signal state   : std_logic; 
    signal clk_div : std_logic := '0';  -- 除頻後的時鐘
    signal div_cnt : std_logic_vector(23 downto 0) := (others => '0'); -- 5-bit 分頻計數器 (0~23)
begin 
    o_count1 <= count1; 
    o_count2 <= count2; 
 
    -- 除頻器：除頻 24，產生 clk_div
    process (i_clk, i_rst)
    begin
        if i_rst = '0' then
            div_cnt <= (others => '0');
            clk_div <= '0';
        elsif rising_edge(i_clk) then
                div_cnt <= div_cnt + 1;
            end if;
    end process;
 
    -- 狀態機
    FSM: process(div_cnt, i_rst) 
    begin 
        if i_rst = '0' then 
            state <= '0'; 
        elsif rising_edge(div_cnt(23)) then 
            case state is 
                when '0' => 
                    if count1 = "1111" then 
                        state <= '1'; 
                    end if; 
                when '1' => 
                    if count2 = "0000" then 
                        state <= '0'; 
                    end if; 
                when others => 
                    state <= '0'; 
            end case;   
        end if; 
    end process; 
 
    -- 計數器 1：0 到 15 計數
    counter1: process(div_cnt, i_rst, state) 
    begin 
        if i_rst = '0' then 
            count1 <= "0000"; 
        elsif rising_edge(div_cnt(23)) then 
            case state is 
                when '0' => 
                    count1 <= count1 + 1; 
                when '1' => 
                    null; -- count2 is active 
                when others => 
                    null; 
            end case; 
        end if; 
    end process; 
 
    -- 計數器 2：15 到 0 計數
    counter2: process(div_cnt, i_rst, state) 
    begin 
        if i_rst = '0' then 
            count2 <= "1111"; 
        elsif rising_edge(div_cnt(23)) then 
            case state is 
                when '0' => 
                    null; -- count1 is active 
                when '1' => 
                    count2 <= count2 - 1; 
                when others => 
                    null; 
            end case; 
        end if; 
    end process; 
 
end Behavioral;
