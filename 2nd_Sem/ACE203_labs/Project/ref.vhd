-- the ref module portmaps the display module(3 modules it self) and the scoreboard which keeps track of the points
-- it also outputs the winner as a 2-bit signal 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ref is port
	(
		clk 		: in std_logic;
		rst 		: in std_logic;
		PntA		: in std_logic;
		PntB		: in std_logic;
		gamemode 	: in std_logic;
		Gear0		: out std_logic;
		en			: in std_logic_vector(1 downto 0);
		winner 		: out std_logic_vector(1 downto 0);
		CA 			: out  STD_LOGIC;
		CB 			: out  STD_LOGIC;
		CC 			: out  STD_LOGIC;
		CD 			: out  STD_LOGIC;
		CE 			: out  STD_LOGIC;
		CF 			: out  STD_LOGIC;
		CG 			: out  STD_LOGIC;
		DP 			: out  STD_LOGIC;
		An 			: out std_logic_vector(3 downto 0)
	);
end ref;

architecture Behavioral of ref is
signal tmp_winner 	: std_logic_vector(1 downto 0);
signal tmp_A_points : std_logic_vector(3 downto 0);
signal tmp_B_points : std_logic_vector(3 downto 0);
	component Display is port
	(
		clk			: in std_logic;
		APoints 	: in std_logic_vector(3 downto 0);
		Bpoints 	: in std_logic_vector(3 downto 0);
		winner 		: in std_logic_vector(1 downto 0);
		gamemode 	: in std_logic;
		en 			: in std_logic_vector(1 downto 0);
		An 			: out std_logic_vector(3 downto 0);
		CA 			: out  STD_LOGIC;
		CB 			: out  STD_LOGIC;
		CC 			: out  STD_LOGIC;
		CD 			: out  STD_LOGIC;
		CE 			: out  STD_LOGIC;
		CF 			: out  STD_LOGIC;
		CG 			: out  STD_LOGIC;
		DP 			: out  STD_LOGIC
	);
	end component;
	component score is port
	(
		CLK 		: in STD_LOGIC;
	    RST			: in STD_LOGIC;
		PntA 		: in  STD_LOGIC;
		PntB		: in  STD_LOGIC;
		GameMode 	: in  STD_LOGIC;
		Apoints 	: out  STD_LOGIC_VECTOR (3 downto 0);
		Bpoints 	: out  STD_LOGIC_VECTOR (3 downto 0);
		winner 		: out  STD_LOGIC_VECTOR (1 downto 0);
		Gear0 		: out  STD_LOGIC
	);
	end component;
begin
	disp : Display port map
	(
		clk => clk,
		APoints => tmp_A_points,
		Bpoints => tmp_B_points,
		winner => tmp_winner,
		gamemode => gamemode,
		en => en,
		an => an,
		CA => CA,
		CB => CB,
		CC => CC,
		CD => CD,
		CE => CE,
		CF => CF,
		CG => CG,
		DP => DP
	);
	scoreboard : SCORE port map
	(
		clk => clk,
		rst => rst,
		PntA => PntA,
		PntB => PntB,
		gamemode => GameMode,
		Apoints => tmp_A_points,
		Bpoints => tmp_B_points,
		winner => tmp_winner,
		gear0 => Gear0
	);
	winner <= tmp_winner;
end Behavioral;