-- Points A / B: 
--		is a counter containing the points of the players
--		outputs as winner whoever reaches first 15 points
--		outputs a bcd for each digit (2 in total) for each player
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity Points_A is
	port
	(
		clk 		: in std_logic;
		A_points 	: in std_logic_vector(3 downto 0);
		bcd_3 		: out std_logic_vector(7 downto 0);
		bcd_2 		: out std_logic_vector(7 downto 0);
		winner 		: in std_logic_vector(1 downto 0);
		game_mode 	: in std_logic
	);  
end Points_A;

architecture Behavioral of Points_A is
signal digit_0 : std_logic;
signal digit_1 : std_logic_vector(3 downto 0);
begin
	decoding: process
	begin
		wait until clk'event and clk = '1';
		if game_mode = '0' then 
			if winner = B"00" or winner = B"11" then
				-- as long as there is no winner we are counting points 
				-- and feed them to the 2 bcd_* signals accordingly
				-- digit_0 has values of 0-1 while digit_1 0-9
				-- as soon as there is a winner the 2 digits light up as "PL"
				-- Points_B module will take care the rest 2 digits
				if A_points > 9  then
					digit_0 <= '1';
					digit_1 <= A_points - 10;
				else
					digit_0 <= '0';
					digit_1 <= A_points;
				end if;
				case digit_1 is
					when "0000" => bcd_2 <= "00000010"; -- "0"     
					when "0001" => bcd_2 <= "10011110"; -- "1" 
					when "0010" => bcd_2 <= "00100100"; -- "2" 
					when "0011" => bcd_2 <= "00001100"; -- "3" 
					when "0100" => bcd_2 <= "10011000"; -- "4" 
					when "0101" => bcd_2 <= "01001000"; -- "5" 
					when "0110" => bcd_2 <= "01000000"; -- "6" 
					when "0111" => bcd_2 <= "00011110"; -- "7" 
					when "1000" => bcd_2 <= "00000000"; -- "8"     
					when "1001" => bcd_2 <= "00001000"; -- "9" 
					when others => bcd_2 <= "00000001";
				end case;
				case digit_0 is
					when '0' => bcd_3 <= "00000011"; -- "0"     
					when '1' => bcd_3 <= "10011111"; -- "1"
					when others => bcd_3 <= "00000001";
				end case;
			elsif winner = B"10" or winner = B"01" then
			bcd_2 <= X"E3"; --L
			bcd_3 <= X"31"; --P
			end if;
		else
			if winner = B"11" then
				if A_points > 9  then
						digit_0 <= '1';
						digit_1 <= A_points - 10;
					else
						digit_0 <= '0';
						digit_1 <= A_points;
					end if;
					case digit_1 is
						when "0000" => bcd_2 <= "00000010"; -- "0"     
						when "0001" => bcd_2 <= "10011110"; -- "1" 
						when "0010" => bcd_2 <= "00100100"; -- "2" 
						when "0011" => bcd_2 <= "00001100"; -- "3" 
						when "0100" => bcd_2 <= "10011000"; -- "4" 
						when "0101" => bcd_2 <= "01001000"; -- "5" 
						when "0110" => bcd_2 <= "01000000"; -- "6" 
						when "0111" => bcd_2 <= "00011110"; -- "7" 
						when "1000" => bcd_2 <= "00000000"; -- "8"     
						when "1001" => bcd_2 <= "00001000"; -- "9"
						when others => bcd_2 <= "00000000";
					end case;
					case digit_0 is
						when '0' => bcd_3 <= "00000011"; -- "0"     
						when '1' => bcd_3 <= "10011111"; -- "1"
						when others => bcd_3 <= "00000000";
					end case;
			elsif winner = B"00" then
				bcd_2 <= X"31"; --P
				bcd_3 <= X"63"; --C
			elsif winner = B"10" then
				bcd_2 <= X"E3"; --L
				bcd_3 <= X"31"; --P
			end if;
		end if;
	end process;
end Behavioral;

