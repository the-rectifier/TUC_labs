library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ping_pong_top is port
   (
      clk : in std_logic;
      rst : in std_logic;
      Strike_1 : in std_logic;
      Strike_2 : in std_logic;
      gamemode : in std_logic;
      CA : out  STD_LOGIC;
      CB : out  STD_LOGIC;
      CC : out  STD_LOGIC;
      CD : out  STD_LOGIC;
      CE : out  STD_LOGIC;
      CF : out  STD_LOGIC;
      CG : out  STD_LOGIC;
      DP : out  STD_LOGIC;
      An : out std_logic_vector(3 downto 0);
      led : out std_logic_vector(7 downto 0)
   );
end Ping_pong_top;

architecture Behavioral of Ping_pong_top is
component ref is port
   (
   	clk : in std_logic;
   	rst : in std_logic;
   	PntA: in std_logic;
   	PntB: in std_logic;
   	gamemode : in std_logic;
   	Gear0 : out std_logic;
      en: in std_logic_vector(1 downto 0);
      winner : out std_logic_vector(1 downto 0);
   	CA : out  STD_LOGIC;
   	CB : out  STD_LOGIC;
   	CC : out  STD_LOGIC;
   	CD : out  STD_LOGIC;
   	CE : out  STD_LOGIC;
   	CF : out  STD_LOGIC;
   	CG : out  STD_LOGIC;
   	DP : out  STD_LOGIC;
   	An : out std_logic_vector(3 downto 0)
   );
end component;
component timer is port
(
	clk : in std_logic;
	rst : in std_logic;
	gear0 : in std_logic;
	gearup : in std_logic;
	shift : out std_logic;
	plex : out std_logic_vector(1 downto 0)
);
end component;
component strikes_fsm is port
(
	CLK : in  STD_LOGIC;
	RST : in  STD_LOGIC;
	Strike1 : in  STD_LOGIC;
	Strike2 : in  STD_LOGIC;
	Pos : in  STD_LOGIC_VECTOR (1 downto 0);
	GameMode : in  STD_LOGIC;
	GearUp : out  STD_LOGIC;
	HitA : out  STD_LOGIC;
	HitB : out  STD_LOGIC;
	PntA : out  STD_LOGIC;
   PntB : out  STD_LOGIC;
   serv : out  std_logic
);
end component;
component court is port
(
	clk : in std_logic;
	rst : in std_logic;
	shift : in std_logic;
	hit_a : in std_logic;
	hit_b : in std_logic;
   serv : in std_logic;
   gamemode : in std_logic;
	pos : out std_logic_vector(1 downto 0);
   led : out std_logic_vector(7 downto 0);
   winner : in std_logic_vector(1 downto 0)
);
end component;
component singlepulsegen is port
(
	clk 		: in std_logic;
	rst 		: in std_logic;
	input 	: in std_logic;
	output 	: out std_logic
);
end component;
signal tmp_gear0 : std_logic;
signal tmp_shift : std_logic;
signal tmp_gear_up : std_logic;
signal tmp_en : std_logic_vector (1 downto 0);
signal tmp_pos : std_logic_vector (1 downto 0);
signal tmp_winner : std_logic_vector(1 downto 0);
signal tmp_serv : std_logic;
signal tmp_hitA, tmp_hitB, tmp_PntA, tmp_PntB, tmp_strike1, tmp_strike2 : std_logic;
begin
   timing : timer port map(
      clk => clk,
      rst => rst,
      gear0 => tmp_gear0,
      GearUp => tmp_gear_up,
      shift => tmp_shift,
      plex => tmp_en
   );
   striking : strikes_fsm port map(
      clk => clk,
      rst => rst,
      Strike1 => tmp_strike1,
      Strike2 => tmp_strike2,
      pos => tmp_pos,
      GameMode => gamemode,
      GearUp => tmp_gear_up,
      HitA => tmp_hitA,
      hitB => tmp_hitB,
      PntA => tmp_PntA,
      PntB => tmp_PntB,
      serv => tmp_serv
   );
   striking_1 : singlepulsegen port map(clk,rst,Strike_1,tmp_strike1);
   striking_2 : singlepulsegen port map(clk,rst,Strike_2,tmp_strike2);
   table : court port map(
      clk => clk,
      rst => rst,
      shift => tmp_shift,
      hit_a => tmp_hitA,
      hit_b => tmp_hitB,
      serv => tmp_serv,
      pos => tmp_pos,
      led => led,
      gamemode => gamemode,
      winner => tmp_winner
   );
   referee : ref port map(clk,rst,tmp_PntA,tmp_PntB,GameMode,tmp_gear0,tmp_en,tmp_winner,CA,CB,CC,CD,CE,CF,CG,DP,An);
end Behavioral;
