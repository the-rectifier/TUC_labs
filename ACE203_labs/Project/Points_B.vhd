-- Points A / B: 
--		is a counter containing the points of the players
--		outputs as winner whoever reaches first 15 points
--		outputs a bcd for each digit (2 in total) for each player
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity Points_B is
	port
	(
		clk  		: in std_logic;
		B_points 	: in std_logic_vector(3 downto 0);
		bcd_1 		: out std_logic_vector(7 downto 0);
		bcd_0 		: out std_logic_vector(7 downto 0);
		winner 		: in std_logic_vector(1 downto 0);
		game_mode 	: in std_logic
	);  
end Points_B;

architecture Behavioral of Points_B is
signal digit_0 		: std_logic_vector(3 downto 0);
signal digit_1 		: std_logic;
signal tmp_bcd_0 	: std_logic_vector(7 downto 0);
signal tmp_bcd_1 	: std_logic_vector(7 downto 0);
begin
	process
	begin
		wait until clk'event and clk = '1';
		if game_mode = '0' then
			if winner = B"00" or winner = B"11" then
				-- as long as there is no winner we are counting points 
				-- and feed them to the 2 bcd_* signals accordingly
				-- digit_0 has values of 0-1 while digit_1 0-9
				-- as soon as there is a winner it checks who won 
				-- and diplays "r" + 1 or 2 based on the advertised "winner signal"
				if B_points > 9  then
					digit_1 <= '1';
					digit_0 <= B_points - 10;
				else
					digit_1 <= '0';
					digit_0 <= B_points;
				end if;
				case digit_0 is
					when "0000" => tmp_bcd_0 <= "00000011"; -- "0"     
					when "0001" => tmp_bcd_0 <= "10011111"; -- "1" 
					when "0010" => tmp_bcd_0 <= "00100101"; -- "2" 
					when "0011" => tmp_bcd_0 <= "00001101"; -- "3" 
					when "0100" => tmp_bcd_0 <= "10011001"; -- "4" 
					when "0101" => tmp_bcd_0 <= "01001001"; -- "5" 
					when "0110" => tmp_bcd_0 <= "01000001"; -- "6" 
					when "0111" => tmp_bcd_0 <= "00011111"; -- "7" 
					when "1000" => tmp_bcd_0 <= "00000001"; -- "8"     
					when "1001" => tmp_bcd_0 <= "00001001"; -- "9" 
					when others => tmp_bcd_0 <= "00000001";
				end case;
				case digit_1 is
					when '0' => tmp_bcd_1 <= "00000011"; -- "0"     
					when '1' => tmp_bcd_1 <= "10011111"; -- "1"
					when others => tmp_bcd_1 <= "00000001";
				end case;
			elsif winner = B"10" then
				tmp_bcd_1 <= X"F5"; --r
				tmp_bcd_0 <= X"9F"; --1
			elsif winner = B"01" then
				tmp_bcd_1 <= X"F5"; --r
				tmp_bcd_0 <= X"25"; --2
			end if;
		else 
			if winner = B"11" then
				tmp_bcd_1 <= X"FF"; -- null
				tmp_bcd_0 <= X"FF"; -- null
			elsif winner = B"00" then
				tmp_bcd_1 <= X"83"; -- U
				tmp_bcd_0 <= x"FF"; -- null
			elsif winner = B"10" then
				tmp_bcd_1 <= X"F5"; --r
				tmp_bcd_0 <= X"9F"; --1
			end if;
		end if;
	end process;
	bcd_0 <= tmp_bcd_1;
	bcd_1 <= tmp_bcd_0;
end Behavioral;