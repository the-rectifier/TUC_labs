library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFSTAGE_MC is
	 Port(  
	 		PC_Sel : in std_logic;
	 		PC_LD : in std_logic;
	 		PC_4 : in std_logic_vector(31 downto 0);
	 		PC_Immed : in std_logic_vector(31 downto 0);
	 		clk	: in std_logic;
	 		rst : in std_logic;
	 		PC : out std_logic_vector(31 downto 0));
end IFSTAGE_MC;


architecture Behavioral of IFSTAGE_MC is
signal selected_pc : std_logic_vector(31 downto 0);

component plain_reg is Port(
		Data_in : in std_logic_vector(31 downto 0);
		WE  : in std_logic;
		Data_out : out std_logic_vector(31 downto 0);
		clk : in std_logic;
		rst : in std_logic);
end component;

component mux_2_1 is Port ( 
		   sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
	select_pc : mux_2_1 port map(
							sel => PC_Sel,
							a => PC_4,
							b => PC_Immed,
							q => selected_pc);
							
	write_new_pc : plain_reg port map(
							clk => clk, 
							rst => rst,
							Data_in => selected_pc,
							WE => PC_LD,
							Data_out => PC);
end;
