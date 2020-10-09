-- this module maps 3 components into a display unit for 4 7-seg displays
-- Points A/B contain the points and output the first player to reach 15

-- plexer a 4X1 MUX that selects an 8-bit bcd value based on a 2 bit control
-- provided by the timer
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display is
	port 
	(
		clk			: in std_logic;
		APoints 	: in std_logic_vector(3 downto 0);
		Bpoints 	: in std_logic_vector(3 downto 0);
		winner 		: in std_logic_vector(1 downto 0);
		gamemode	: in std_logic;
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
end Display;

architecture Behavioral of Display is
signal tmp_bcd_0 : std_logic_vector(7 downto 0);
signal tmp_bcd_1 : std_logic_vector(7 downto 0);
signal tmp_bcd_2 : std_logic_vector(7 downto 0);
signal tmp_bcd_3 : std_logic_vector(7 downto 0);

component Points_A is port
(
	clk 		: in std_logic;
	A_points 	: in std_logic_vector(3 downto 0);
	bcd_3 		: out std_logic_vector(7 downto 0);
	bcd_2 		: out std_logic_vector(7 downto 0);
	winner 		: in std_logic_vector(1 downto 0);
	game_mode 	: in std_logic
);
end component;

component Points_B is port
(
	clk 		: in std_logic;
	B_points 	: in std_logic_vector(3 downto 0);
	bcd_1 		: out std_logic_vector(7 downto 0);
	bcd_0 		: out std_logic_vector(7 downto 0);
	winner 		: in std_logic_vector(1 downto 0);
	game_mode 	: in std_logic
);
end component;

component plexer is port 
(
	clk 	: IN  std_logic;
	en 		: IN  std_logic_vector(1 downto 0);
	bcd_1 	: IN  std_logic_vector(7 downto 0);
	bcd_2 	: IN  std_logic_vector(7 downto 0);
	bcd_3 	: IN  std_logic_vector(7 downto 0);
	bcd_0 	: IN  std_logic_vector(7 downto 0);
	CA 		: OUT  std_logic;
	CB 		: OUT  std_logic;	
	CC		: OUT  std_logic;
   	CD 		: OUT  std_logic;
	CE 		: OUT  std_logic;
	CF		: OUT  std_logic;
	CG 		: OUT  std_logic;
	DP 		: OUT  std_logic;
	An 		: OUT  std_logic_vector(3 downto 0)
);
end component;

begin

	PointsA	: Points_A port map(clk,Apoints,tmp_bcd_3,tmp_bcd_2,winner,gamemode);
	PointsB	: Points_B port map(clk,Bpoints,tmp_bcd_0,tmp_bcd_1,winner,gamemode);
	MUX 	: plexer port map(clk,en,tmp_bcd_1,tmp_bcd_2,tmp_bcd_3,tmp_bcd_0,CA,CB,CC,CD,CE,CF,CG,DP,An);

end Behavioral;

