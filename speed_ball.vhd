library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all;

entity speed_ball is
	Port ( 
		i_rst   : in std_logic;
		i_clk   : in std_logic;
		i_btn_l : in std_logic;
		i_btn_r : in std_logic;
		o_led   : out std_logic_vector ( 7 downto 0 )
	);
end speed_ball;

architecture Behavioral of speed_ball is
	type state_type is (INIT, RIGHT, LEFT, SCORE_L, SCORE_R);
	signal state    : state_type := INIT; 
	signal move     : std_logic_vector ( 7 downto 0 ) := "00000001"; --Move left/right
	signal scores_l : std_logic_vector ( 3 downto 0 ) := "0000"; --left score
	signal scores_r : std_logic_vector ( 3 downto 0 ) := "0000"; --right score
	signal scored_l : std_logic := '0';
	signal scored_r : std_logic := '0';
	signal random   : std_logic_vector ( 4 downto 0 ) := "10101";
	signal rang_dice  : std_logic_vector ( 1 downto 0 ) ;
	signal clk_ball : std_logic;
	signal slow_clk : std_logic;
	signal clk_div  : std_logic_vector(28 downto 0) := (others => '0');
begin

    rang_dice <= random(1 downto 0);
    clk_ball <= clk_div (to_integer (unsigned (rang_dice)) + 23 );
    slow_clk <= clk_div(23);


    -- Generate random number
    process (slow_clk, i_rst)
    begin
        if i_rst = '0' then
            random <= "10101";
        elsif rising_edge(slow_clk) then
            random <= random(3 downto 0) & (random(4) xor random(1));
        end if;
    end process;
    
	--div_clk
    process (i_clk, i_rst)
    begin
        if i_rst = '0' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
            
        end if;
    end process;
	
	-- FSM
	process( i_clk, i_rst) 
	begin 
        if i_rst = '0' then 
            state <= INIT;
		elsif rising_edge(i_clk) then 
			case state is 
				when INIT => 
					if i_btn_r = '1' then
						state <= LEFT;
					end if;
					o_led <= std_logic_vector(move);
				when LEFT => --
					if  ( i_btn_l = '1' ) and ( move = "10000000" ) then
						state <= RIGHT;
					elsif ( i_btn_l = '0' ) and ( move = "00000000" ) then
						state <= SCORE_R;
					elsif ( i_btn_l = '1' ) and ( move /= "10000000" ) then
						state <= SCORE_R;
					end if;
					o_led <= std_logic_vector(move);
				when RIGHT =>
					if  ( i_btn_r = '1' ) and ( move = "00000001" ) then
						state <= LEFT;
					elsif ( i_btn_r = '0' ) and (  move = "00000000" ) then
						state <= SCORE_L;
					elsif ( i_btn_r = '1' ) and (  move /= "00000001" ) then
						state <= SCORE_L;
					end if;
					o_led <= std_logic_vector(move);
				when SCORE_L => 
					if i_btn_l = '1' then
						state <= RIGHT;
					elsif ( scores_l = "1111" ) and ( i_btn_l = '1' ) then
						state <= INIT;
					end if;
					o_led <= std_logic_vector(scores_l) & std_logic_vector(scores_r);
				when SCORE_R =>
					if i_btn_r = '1' then
						state <= LEFT;
					elsif ( scores_r = "1111" ) and ( i_btn_r = '1' ) then
						state <= INIT;
					end if;
					o_led <= std_logic_vector(scores_l) & std_logic_vector(scores_r);
				when others => 
					null; 
			end case;   
		end if; 
	end process;

	--Move left/right
	process( clk_ball, i_rst,  move, i_btn_l, i_btn_r )
	begin
		if i_rst = '0' then
			move <= "00000001" ;
        elsif rising_edge(clk_ball) then
            if state = LEFT then
                move <= move(6 downto 0) & '0';
            elsif state = RIGHT then
                move <= '0' & move(7 downto 1);
		   elsif state = SCORE_R then
		       move <= "00000001" ;
		   elsif state = SCORE_L then
		       move <= "10000000" ;
            end if;
		end if;
	end process;
	
	--Score on the left
    process(slow_clk, i_rst, move, scores_l)
    begin
        if i_rst = '0' then
            scores_l <= "0000";
            scored_l <= '0';
        elsif rising_edge(slow_clk) then
            if (((state = SCORE_L) and (scores_l = "1111")) or ((state = SCORE_R) and (scores_r = "1111"))) then
                scores_l <= "0000";
                scored_l <= '0';
            elsif state = SCORE_L and scored_l = '0' then
                scores_l <= scores_l + 1;
                scored_l <= '1';
            elsif state /= SCORE_L then
                scored_l <= '0';
            end if;
        end if;
    end process;
	
	--Score on the right
    process(slow_clk, i_rst, move, scores_r)
    begin
        if i_rst = '0' then
            scores_r <= "0000";
            scored_r <= '0';
        elsif rising_edge(slow_clk) then
            if (((state = SCORE_R) and (scores_r = "1111")) or ((state = SCORE_L) and (scores_l = "1111"))) then
                scores_r <= "0000";
                scored_r <= '0';
            elsif state = SCORE_R and scored_r = '0' then
                scores_r <= scores_r + 1;
                scored_r <= '1';
            elsif state /= SCORE_R then
                scored_r <= '0';
            end if;
        end if;
    end process;	

end Behavioral;
