library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DualCounter is
    Port (
        i_clk         : in  std_logic;              -- �����T��
        i_reset       : in  std_logic;              -- ���m�T��
        i_count_up1   : in  std_logic;              -- �p�ƾ� 1 �W��/�U�Ʊ���
        i_count_up2   : in  std_logic;              -- �p�ƾ� 2 �W��/�U�Ʊ���
        i_max1        : in  unsigned(7 downto 0);   -- �p�ƾ� 1 �W��
        i_min1        : in  unsigned(7 downto 0);   -- �p�ƾ� 1 �U��
        i_max2        : in  unsigned(7 downto 0);   -- �p�ƾ� 2 �W��
        i_min2        : in  unsigned(7 downto 0);   -- �p�ƾ� 2 �U��
        o_counter1    : out unsigned(7 downto 0);   -- �p�ƾ� 1 ����
        o_counter2    : out unsigned(7 downto 0)    -- �p�ƾ� 2 ����
    );
end DualCounter;

architecture Behavioral of DualCounter is
    signal count1 : unsigned(7 downto 0) := (others => '0');
    signal count2 : unsigned(7 downto 0) := (others => '0');
begin
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            count1 <= i_min1;
            count2 <= i_min2;
        elsif rising_edge(i_clk) then
            -- �p�ƾ� 1 �޿�
            if i_count_up1 = '1' then
                if count1 < i_max1 then
                    count1 <= count1 + 1;
                else
                    count1 <= i_min1;  -- �W�L�W���^��U��
                end if;
            else
                if count1 > i_min1 then
                    count1 <= count1 - 1;
                else
                    count1 <= i_max1;  -- �C��U���^��W��
                end if;
            end if;

            -- �p�ƾ� 2 �޿�
            if i_count_up2 = '1' then
                if count2 < i_max2 then
                    count2 <= count2 + 1;
                else
                    count2 <= i_min2;  -- �W�L�W���^��U��
                end if;
            else
                if count2 > i_min2 then
                    count2 <= count2 - 1;
                else
                    count2 <= i_max2;  -- �C��U���^��W��
                end if;
            end if;
        end if;
    end process;

    o_counter1 <= count1;
    o_counter2 <= count2;
end Behavioral;
