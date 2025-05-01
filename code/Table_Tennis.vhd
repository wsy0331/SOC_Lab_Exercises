library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Table_Tennis is
	port (
		i_clk            : in STD_LOGIC;
		i_rst            : in STD_LOGIC;
		i_sw_left        : in STD_LOGIC;    
		i_sw_right       : in STD_LOGIC;
		o_left_paddle_x  : out INTEGER;
		o_left_paddle_y  : out INTEGER;
		o_right_paddle_x : out INTEGER;
		o_right_paddle_y : out INTEGER;
		o_paddle_dy      : out INTEGER;     
		o_ball_x         : out INTEGER;
		o_ball_y         : out INTEGER;
		o_ball_dx        : out INTEGER;
		o_ball_dy        : out INTEGER
	);
end Table_Tennis;

architecture Behavioral of Table_Tennis is

    -- 狀態宣告
    type state_type is (INIT, PLAYING, LEFT_SCORE, RIGHT_SCORE);
    signal state : state_type := INIT;
    
    type ball_state_type is (UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT);
    signal ball_state : ball_state_type := UP_RIGHT;
    
    -- 參數設定
    constant BALL_DIAMETER : INTEGER := 80;
    constant BALL_RADIUS   : INTEGER := 40;
    constant PADDLE_WIDTH  : INTEGER := 20;
    constant PADDLE_HEIGHT : INTEGER := 100;
    constant H_RES         : INTEGER := 800;
    constant V_RES         : INTEGER := 600;

    -- 球位置與速度
    signal ball_x  : INTEGER range 0 to 799 := 400;
    signal ball_y  : INTEGER range 0 to 599 := 300;
    signal ball_dx : INTEGER := 3;
    signal ball_dy : INTEGER := 5;
    
    -- 球拍位置與速度
	signal left_paddle_x : INTEGER range 0 to 799 := 0;
	signal left_paddle_y : INTEGER range 0 to 599 := 250;
	signal right_paddle_x : INTEGER range 0 to 799 := 780;
	signal right_paddle_y : INTEGER range 0 to 599 := 250;
	signal paddle_dy : INTEGER := 3;
    
    -- 分頻時脈產生器
    signal clk_div  : STD_LOGIC_VECTOR(25 downto 0) := (others => '0');
    signal slow_clk : STD_LOGIC;

begin

    slow_clk         <= clk_div(20);
    o_left_paddle_x  <= left_paddle_x;
    o_left_paddle_y  <= left_paddle_y;
    o_right_paddle_x <= right_paddle_x;
    o_right_paddle_y <= right_paddle_y;	
    o_ball_x         <= ball_x;
    o_ball_y         <= ball_y;
    o_ball_dx        <= ball_dx;
    o_ball_dy        <= ball_dy;

    --slow_clk
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    -- FSM 控制遊戲狀態
	process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			state <= INIT;
		elsif rising_edge(i_clk) then
			case state is
				when INIT =>
				  
					state <= PLAYING;
				when PLAYING =>
					if ball_x < 40 then
						state <= RIGHT_SCORE;
					elsif ball_x > 760 then
						state <= LEFT_SCORE;
					end if;
				when LEFT_SCORE =>
				    
					state <= INIT;
				when RIGHT_SCORE =>

				    
					state <= INIT;
				when others =>
					state <= INIT;
			end case;
		end if;
	end process;

    -- 球的 FSM（方向與反彈邏輯）
	process(slow_clk, i_rst)
	begin
        if i_rst = '1' then
            ball_state <= UP_RIGHT;
            ball_x <= 400;
            ball_y <= 300;
            ball_dx <= 3;
            ball_dy <= 5;
        elsif rising_edge(slow_clk) then
            case ball_state is

                -- 右下（X+, Y+）
                when DOWN_RIGHT =>
                    ball_x <= ball_x + ball_dx;
                    ball_y <= ball_y + ball_dy;

                    if (ball_y + BALL_RADIUS) > V_RES then
                        ball_state <= UP_RIGHT;
                    elsif (ball_x + BALL_RADIUS) > right_paddle_x and
                          ball_y >= right_paddle_y and 
                          ball_y <= right_paddle_y + PADDLE_HEIGHT then
                        ball_state <= DOWN_LEFT;
                    elsif (ball_x + BALL_RADIUS) > H_RES then
                        ball_x <= 400;
                    ball_y <= 300;
                    ball_dx <= 3;   -- 重設速度
                    ball_dy <= 5;   -- 重設速度
                        ball_state <= DOWN_LEFT;  -- 超出畫面右邊也反彈
                    end if;

                -- 右上（X+, Y-）
                when UP_RIGHT =>
                    ball_x <= ball_x + ball_dx;
                    ball_y <= ball_y - ball_dy;

                    if (ball_y - BALL_RADIUS) < 0 then
                        ball_state <= DOWN_RIGHT;
                    elsif (ball_x + BALL_RADIUS) > right_paddle_x and
                          ball_y >= right_paddle_y and 
                          ball_y <= right_paddle_y + PADDLE_HEIGHT then
                        ball_state <= UP_LEFT;
                    elsif (ball_x + BALL_RADIUS) > H_RES then
                    ball_x <= 400;
                    ball_y <= 300;
                    ball_dx <= 3;   -- 重設速度
                    ball_dy <= 5;   -- 重設速度
                        ball_state <= UP_LEFT;
                    end if;

                -- 左下（X-, Y+）
                when DOWN_LEFT =>
                    ball_x <= ball_x - ball_dx;
                    ball_y <= ball_y + ball_dy;

                    if (ball_y + BALL_RADIUS) > V_RES then
                        ball_state <= UP_LEFT;
                    elsif (ball_x - BALL_RADIUS) < left_paddle_x + PADDLE_WIDTH and
                          ball_y >= left_paddle_y and 
                          ball_y <= left_paddle_y + PADDLE_HEIGHT then
                        ball_state <= DOWN_RIGHT;
                    elsif (ball_x - BALL_RADIUS) < 0 then
                    ball_x <= 400;
                    ball_y <= 300;
                    ball_dx <= 3;   -- 重設速度
                    ball_dy <= 5;   -- 重設速度
                        ball_state <= DOWN_RIGHT;
                    end if;

                -- 左上（X-, Y-）
                when UP_LEFT =>
                    ball_x <= ball_x - ball_dx;
                    ball_y <= ball_y - ball_dy;

                    if (ball_y - BALL_RADIUS) < 0 then
                        ball_state <= DOWN_LEFT;
                    elsif (ball_x - BALL_RADIUS) < left_paddle_x + PADDLE_WIDTH and
                          ball_y >= left_paddle_y and 
                          ball_y <= left_paddle_y + PADDLE_HEIGHT then
                        ball_state <= UP_RIGHT;
                    elsif (ball_x - BALL_RADIUS) < 0 then
                    ball_x <= 400;
                    ball_y <= 300;
                    ball_dx <= 3;   -- 重設速度
                    ball_dy <= 5;   -- 重設速度
                        ball_state <= UP_RIGHT;
                    end if;

                when others =>
                    ball_x <= ball_x;
                    ball_y <= ball_y;
            end case;
        end if;
	end process;

	--左球拍的移動
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            left_paddle_y <= 250;
        elsif rising_edge(slow_clk) then
            if i_sw_left = '1' and left_paddle_y > 1 then
                left_paddle_y <= left_paddle_y - 5;
            elsif i_sw_left = '0' and (left_paddle_y + PADDLE_HEIGHT) < 600 then
                left_paddle_y <= left_paddle_y + 5;
            end if;
        end if;
    end process;

	--右球拍的移動
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            right_paddle_y <= 250;
        elsif rising_edge(slow_clk) then
            if i_sw_right = '1' and right_paddle_y > 1 then
                right_paddle_y <= right_paddle_y - 5;
            elsif i_sw_right = '0' and (right_paddle_y + PADDLE_HEIGHT) < 600 then
                right_paddle_y <= right_paddle_y + 5;
            end if;
        end if;
    end process;

end Behavioral;