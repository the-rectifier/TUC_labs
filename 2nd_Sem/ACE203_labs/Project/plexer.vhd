-- Plexer:
--		4 X 1 MUX that selects one of 4 8-bit signals(bcd_0 - bcd_3)
--		based on a 2-bit signal en provided by the timer
-- 		outputs every segment of the display based on the selected signal
-- 		outputs a 4-bit signal An that enables each display
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity plexer is
	port
	(
		clk 	: in std_logic;
		en		: in std_logic_vector(1 downto 0);
		bcd_1	: in std_logic_vector(7 downto 0); 
		bcd_2	: in std_logic_vector(7 downto 0);
		bcd_3	: in std_logic_vector(7 downto 0);
		bcd_0	: in std_logic_vector(7 downto 0);
		CA 		: out  STD_LOGIC;
		CB 		: out  STD_LOGIC;
		CC 		: out  STD_LOGIC;
		CD 		: out  STD_LOGIC;
		CE 		: out  STD_LOGIC;
		CF 		: out  STD_LOGIC;
		CG 		: out  STD_LOGIC;
		DP 		: out  STD_LOGIC;
		An 		: out std_logic_vector(3 downto 0)
	);
end plexer;

architecture Behavioral of plexer is
begin
	process
	begin
		wait until clk'event and clk = '1';
		case en is
			when B"00" =>
				An <= B"0111";
				CA <= bcd_0(7);
				CB <= bcd_0(6);
				CC <= bcd_0(5);
				CD <= bcd_0(4);
				CE <= bcd_0(3);
				CF <= bcd_0(2);
				CG <= bcd_0(1);
				DP <= bcd_0(0);
			when B"01" =>
				An <= B"1011";
				CA <= bcd_1(7);
				CB <= bcd_1(6);
				CC <= bcd_1(5);
				CD <= bcd_1(4);
				CE <= bcd_1(3);
				CF <= bcd_1(2);
				CG <= bcd_1(1);
				DP <= bcd_1(0);
			when B"10" =>
				An <= B"1101";
				CA <= bcd_2(7);
				CB <= bcd_2(6);
				CC <= bcd_2(5);
				CD <= bcd_2(4);
				CE <= bcd_2(3);
				CF <= bcd_2(2);
				CG <= bcd_2(1);
				DP <= bcd_2(0);
			when B"11" =>
				An <= B"1110";
				CA <= bcd_3(7);
				CB <= bcd_3(6);
				CC <= bcd_3(5);
				CD <= bcd_3(4);
				CE <= bcd_3(3);
				CF <= bcd_3(2);
				CG <= bcd_3(1);
				DP <= bcd_3(0);
			when others =>
				An <= B"0111";
				CA <= '0';
				CB <= '0';
				CC <= '0';
				CD <= '0';
				CE <= '0';
				CF <= '0';
				CG <= '0';
				DP <= '0';
		end case;
	end process;
end Behavioral;

