library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity part1 is
    Port (
        i_clk    : in std_logic;
        i_reset  : in std_logic; 
        o_counter  : out std_logic_vector (3 downto 0)
    );
end part1;

architecture Behavioral of part1 is
    signal counter_24 : std_logic_vector(23 downto 0) := (others => '0'); 
    signal clk_reg    : std_logic := '0';                               
    signal counter_10 : std_logic_vector(3 downto 0) := (others => '0');
    signal up_count   : std_logic := '1'; -- 1 表示遞增，0 表示遞減 
begin
    -- 除 24 的除頻器
    process (i_clk, i_reset)
    begin
        if i_reset = '1' then
            counter_24 <= (others => '0');
            clk_reg    <= '0';
        elsif rising_edge(i_clk) then
                counter_24 <= counter_24 + 1;
        end if;
    end process;

    -- 0 到 9 的計數器
    process (i_clk, i_reset,counter_24)
    begin
        if i_reset = '1' then
            counter_10 <= (others => '0');
            up_count <= '1';
        elsif rising_edge(counter_24(23)) then
            if up_count = '1' then -- 遞增計數
                if counter_10 = "1001" then -- 計數到 9 時轉為遞減
                    up_count <= '0';
                    counter_10 <= counter_10 - 1;
                else
                    counter_10 <= counter_10 + 1;
                end if;
            else -- 遞減計數
                if counter_10 = "0000" then -- 計數到 0 時轉為遞增
                    up_count <= '1';
                    counter_10 <= counter_10 + 1;
                else
                    counter_10 <= counter_10 - 1;
                end if;
            end if;
        end if;
    end process;

    o_counter <= counter_10;
end Behavioral;

