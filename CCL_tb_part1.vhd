library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_part1 is
end tb_part1;

architecture Behavioral of tb_part1 is
    signal i_clk    : std_logic := '0';
    signal i_reset  : std_logic := '0';
    signal o_count  : INTEGER range 0 to 9;

    -- �s���� part1 ����
    component part1
        Port (
            i_clk    : in std_logic;
            i_reset  : in std_logic;
            o_count  : out INTEGER range 0 to 9
        );
    end component;

begin
    uut: part1 Port Map (
        i_clk => i_clk,
        i_reset => i_reset,
        o_count => o_count
    );

    -- �ɯ߲��;�
    i_clk_process: process
    begin
        i_clk <= '0';
        wait for 10 ns;
        i_clk <= '1';
        wait for 10 ns;
    end process;

    -- �����y�{
    stim_proc: process
    begin
        -- ��l�ƭ��m�T��
        i_reset <= '1';
        wait for 20 ns;
        i_reset <= '0';
        
        -- ���� 200 ns
        wait for 200 ns;
        
        -- ��������
        wait;
    end process;
end Behavioral;
