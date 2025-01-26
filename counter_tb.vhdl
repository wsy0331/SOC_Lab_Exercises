library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_DualCounter is
end TB_DualCounter;

architecture Behavioral of TB_DualCounter is
    signal i_clk         : std_logic := '0';
    signal i_reset       : std_logic := '0';
    signal i_count_up1   : std_logic := '1';
    signal i_count_up2   : std_logic := '1';
    signal i_max1, i_min1  : unsigned(7 downto 0) := (others => '0');
    signal i_max2, i_min2  : unsigned(7 downto 0) := (others => '0');
    signal o_counter1    : unsigned(7 downto 0);
    signal o_counter2    : unsigned(7 downto 0);

    constant i_clk_period : time := 10 ns;
begin
    UUT: entity work.DualCounter
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_count_up1 => i_count_up1,
            i_count_up2 => i_count_up2,
            i_max1 => i_max1,
            i_min1 => i_min1,
            i_max2 => i_max2,
            i_min2 => i_min2,
            o_counter1 => o_counter1,
            o_counter2 => o_counter2
        );

    -- Clock generation
    i_clk_process : process
    begin
        while true loop
            i_clk <= '0';
            wait for i_clk_period / 2;
            i_clk <= '1';
            wait for i_clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- ��l�ưѼ�
        i_max1 <= to_unsigned(10, 8);
        i_min1 <= to_unsigned(0, 8);
        i_max2 <= to_unsigned(20, 8);
        i_min2 <= to_unsigned(5, 8);

        -- ���m�t��
        i_reset <= '1';
        wait for i_clk_period * 2;
        i_reset <= '0';

        -- �����W��
        i_count_up1 <= '1';
        i_count_up2 <= '1';
        wait for i_clk_period * 50;

        -- �����U��
        i_count_up1 <= '0';
        i_count_up2 <= '0';
        wait for i_clk_period * 50;

        -- ��������
        wait;
    end process;
end Behavioral;
