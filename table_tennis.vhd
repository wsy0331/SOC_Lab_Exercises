library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_unsigned.all;

entity table_tennis is
	Port ( 
		i_rst  : in std_logic;
		i_clk  : in std_logic;
		i_btn_l : in std_logic;
		i_btn_r : in std_logic;
		o_led  : out std_logic_vector ( 7 downto 0 )
	);
end table_tennis;

architecture Behavioral of table_tennis is
	signal state     :  std_logic_vector( 2 downto 0 ) := "000";
	signal move      : std_logic_vector ( 7 downto 0 ) := "00000001"; --Move left/right
	signal scores_l  : std_logic_vector ( 3 downto 0 ) := "0000"; --left score
	signal scores_r  : std_logic_vector ( 3 downto 0 ) := "0000"; --right score
	signal scored_l : std_logic := '0';
	signal scored_r : std_logic := '0'; 
	signal clk_div   : std_logic_vector(25 downto 0) := (others => '0');
begin

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
            state <= "000";
--            scores_l <= "0000";
--            scores_r <= "0000";
--            scored_l <= '0';
--            scored_r <= '0'; 
		elsif rising_edge(i_clk) then 
			case state is 
				when "000" => 
					if i_btn_r = '1' then
						state <= "001";
					end if;
					o_led <= std_logic_vector(move);
				when "001" => --
					if  ( i_btn_l = '1' ) and ( move = "10000000" ) then
						state <= "010";
					elsif ( i_btn_l = '0' ) and ( move = "00000000" ) then
						state <= "100";
					elsif ( i_btn_l = '1' ) and ( move /= "10000000" ) then
						state <= "100";
					end if;
					o_led <= std_logic_vector(move);
				when "010" =>
					if  ( i_btn_r = '1' ) and ( move = "00000001" ) then
						state <= "001";
					elsif ( i_btn_r = '0' ) and (  move = "00000000" ) then
						state <= "011";
					elsif ( i_btn_r = '1' ) and (  move /= "00000001" ) then
						state <= "011";
					end if;
					o_led <= std_logic_vector(move);
				when "011" => 
					if i_btn_l = '1' then
						state <= "010";
					elsif ( scores_l = "1111" ) and ( i_btn_l = '1' ) then
						state <= "000";
--                    elsif state = "011" and scores_l = "1111" then
--                        state <= "000";
					end if;
					o_led <= std_logic_vector(scores_l) & std_logic_vector(scores_r);
				when "100" =>
					if i_btn_r = '1' then
						state <= "001";
					elsif ( scores_r = "1111" ) and ( i_btn_r = '1' ) then
						state <= "000";
--					elsif state = "100" and scores_r = "1111" then
--					    state <= "000";
					end if;
					o_led <= std_logic_vector(scores_l) & std_logic_vector(scores_r);
				when others => 
					null; 
			end case;   
		end if; 
	end process;

	--Move left/right
	process( clk_div, i_rst,  move, i_btn_l, i_btn_r)
	begin
		if i_rst = '0' then
			move <= "00000001" ;
        elsif rising_edge(clk_div(23)) then
            if state = "001" then
                move <= move(6 downto 0) & '0';
            elsif state = "010" then
                move <= '0' & move(7 downto 1);
		   elsif state = "100" then
		       move <= "00000001" ;
		   elsif state = "011" then
		       move <= "10000000" ;
            end if;
		end if;
	end process;
	
	--Score on the left
    process(clk_div, i_rst, move, scores_l)
    begin
        if i_rst = '0' then
            scores_l <= "0000";
            scored_l <= '0';
        elsif rising_edge(clk_div(25)) then
            if state = "011" and scored_l = '0' then
                scores_l <= scores_l + 1;
                scored_l <= '1';
            elsif state /= "011" then
                scored_l <= '0';
            elsif state = "011" and scores_l = "1111" then
                scores_l <= "0000";
                scored_l <= '0';
            end if;
        end if;
    end process;
	
	--Score on the right
    process(clk_div, i_rst, move, scores_r)
    begin
        if i_rst = '0' then
            scores_r <= "0000";
            scored_r <= '0';
        elsif rising_edge(clk_div(25)) then
            if state = "100" and scored_r = '0' then
                scores_r <= scores_r + 1;
                scored_r <= '1';
            elsif state /= "100" then
                scored_r <= '0';
            elsif state = "011" and scores_r = "1111" then
                scores_r <= "0000";
                scored_r <= '0';
            end if;
        end if;
    end process;	

end Behavioral;
