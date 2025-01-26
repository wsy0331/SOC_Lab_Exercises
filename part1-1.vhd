library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity part1 is
    Port (
        i_clk    : in std_logic;
        i_reset  : in std_logic;
        o_count  : out INTEGER range 0 to 9
    );
end part1;

architecture Behavioral of part1 is
    signal current_o_count : INTEGER range 0 to 9 := 0;
    signal direction     : std_logic := '1'; -- '1' means o_count up, '0' means o_count down
begin
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            current_o_count <= 0;
            direction <= '1';
        elsif rising_edge(i_clk) then
            if direction = '1' then -- o_count up
                if current_o_count = 9 then
                    direction <= '0';
                    current_o_count <= 8; -- Start o_counting down from 9
                else
                    current_o_count <= current_o_count + 1;
                end if;
            else -- o_count down
                if current_o_count = 0 then
                    direction <= '1';
                    current_o_count <= 1; -- Start o_counting up from 0
                else
                    current_o_count <= current_o_count - 1;
                end if;
            end if;
        end if;
    end process;

    o_count <= current_o_count;
end Behavioral;
