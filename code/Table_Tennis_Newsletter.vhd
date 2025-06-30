library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all;

entity Pingpong_gpio is
    port (
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_btn   : in std_logic;
        io_gpio : inout std_logic;
        o_led   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of Pingpong_gpio is
    type state_type is ( RECEIVE, SEND, MOVE_R, MOVE_L);
    signal state        : state_type := RECEIVE;  
    signal move         : std_logic_vector(9 downto 0) := "0000000001";
    signal clk_div      : std_logic_vector(25 downto 0) := (others => '0');
    signal slow_clk     : std_logic;
    signal flag         : std_logic := '1';
    signal gpio_out     : std_logic := 'Z';
    signal gpio_in      : std_logic;
    signal gpio_prev    : std_logic := '0';
    signal recv_edge    : std_logic := '0';
    signal send_pulse   : std_logic := '0';
    signal pulse_counter: std_logic_vector(3 downto 0) := "0000";

begin

	o_led <= move(8 downto 1);
    io_gpio <= gpio_out;
    gpio_in <= io_gpio;
    slow_clk <= clk_div(23);

    --div_clk
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    -- ¤W¤É½t°»´ú
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if  gpio_in = '1' and gpio_prev = '0' then
                recv_edge <= '1';
            else
                recv_edge <= '0';
            end if;
            gpio_prev <= gpio_in;
        end if;
    end process;

    -- FSM
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            state <= RECEIVE;
            gpio_out <= 'Z';
        elsif rising_edge(i_clk) then
            case state is               
                when RECEIVE =>
                    if recv_edge = '1' then
                        state <= MOVE_L;
                    elsif ((i_btn = '1') and (move = "0000000001")) then
                        state <= MOVE_R;
                    end if;
                when MOVE_R =>
                    if move = "1000000000" then
                        state <= SEND;
                    end if;
                when SEND =>
                    if pulse_counter = "1000" then
                        state <= RECEIVE;
                    end if;
                when MOVE_L =>
                    if (move = "0000000001") and (flag = '0') then
                        state <= RECEIVE;
                    elsif (i_btn = '1') then
                        if move = "0000000010" then
                            state <= MOVE_R;
                        else
                            state <= RECEIVE; 
                        end if;
                    end if;
                when others =>
                    state <= RECEIVE;
            end case;
        end if;
    end process;

    -- Ball_move
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            move <= "0000000001";
            flag <= '1';
        elsif rising_edge(slow_clk) then
            case state is
                when RECEIVE =>
                    if (move /= "0000000001") and (move /= "1000000000") then
                        move <= "0000000001";
                    end if;
                when MOVE_R =>
                    move <= move(8 downto 0) & move(9);
                when MOVE_L =>
                    if flag = '1' then
                        move <= "1000000000";
                        flag <= '0';
                    else
                        move <= move(0) & move(9 downto 1);
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

    -- SEND
    process(i_clk, i_rst)
    begin
         if i_rst = '1' then
             pulse_counter <= "0000";
             send_pulse <= '0';
         elsif rising_edge(i_clk) then
             case state is
				when SEND =>
					if pulse_counter < "1000" then
						pulse_counter <= pulse_counter + 1;
						send_pulse <= '1';
					else
						pulse_counter <= "0000";
						send_pulse <= '0';
					end if;
				when others =>
					pulse_counter <= "0000";
					send_pulse <= '0';
			end case;
		end if;
	end process;

    -- gpio_out
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if state = SEND then
                gpio_out <= send_pulse;
            else
                gpio_out <= 'Z';
            end if;
        end if;
    end process;

end Behavioral;
