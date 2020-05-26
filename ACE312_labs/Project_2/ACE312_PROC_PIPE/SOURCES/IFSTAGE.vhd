library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- CHANGES SINCE MULTI_CYCLE:
-- just a store unit with an adder (tested in SINGE_CYCLE)

entity IFSTAGE is
	 Port(
		PC_LD : in std_logic;
		clk	: in std_logic;
		rst : in std_logic;
		PC : out std_logic_vector(31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is
signal pc_temp : std_logic_vector(31 downto 0);
signal s_pc_4 : std_logic_vector(31 downto 0);

component plain_reg is Port(
		Data_in : in std_logic_vector(31 downto 0);
		WE  : in std_logic;
		Data_out : out std_logic_vector(31 downto 0);
		clk : in std_logic;
		rst : in std_logic);
end component;

begin
	s_pc_4 <= std_logic_vector(unsigned(pc_temp) + 4);
	PC <= pc_temp;
	PC_reg : plain_reg port map(
			Data_in => s_pc_4,
			WE => PC_LD,
			Data_out => PC_temp,
			clk => clk, rst => rst);
end;
