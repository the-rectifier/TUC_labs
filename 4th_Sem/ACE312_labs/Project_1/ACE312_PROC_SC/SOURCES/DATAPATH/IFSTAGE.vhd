library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFSTAGE is
	 Port(  PC_Sel : in std_logic;
	 		PC_LD	: in std_logic;
	 		PC_Immed : in std_logic_vector(31 downto 0);
	 		clk	: in std_logic;
	 		rst : in std_logic;
	 		PC : out std_logic_vector(31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

component ProgCount is Port(  
			pc_new : in std_logic_vector(31 downto 0);
        	Rst : in std_logic;
            Clk : in std_logic;
            PC_we : in std_logic;
            PC  :   out std_logic_vector(31 downto 0));
end component;

component incrementor is Port( 
	a : in STD_LOGIC_vector(31 downto 0);
    q :out STD_LOGIC_vector(31 downto 0));
end component;

component mux_2_1 is port(
	sel: in std_logic;
  	a : in STD_LOGIC_VECTOR (31 downto 0);
  	b : in STD_LOGIC_VECTOR (31 downto 0);
  	q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal pc_buff :std_logic_vector(31 downto 0);
signal pc_4 :std_logic_vector(31 downto 0);
signal pc_4_immed :std_logic_vector(31 downto 0);
signal mux_out :std_logic_vector(31 downto 0);
begin
	progcounter: ProgCount port map(
				Clk => Clk,
				Rst => Rst,
				PC_we => PC_LD,
				PC => PC_buff,
				PC_new => mux_out);
				
	PC <= pc_buff;
		
	incr : incrementor port map(
				a => pc_buff,
				q => pc_4);
				
	pc_4_immed <= std_logic_vector(unsigned(pc_4) + unsigned(PC_Immed));
							
	selectPC : mux_2_1 port map(
				q => mux_out,
				a => pc_4,
				b => pc_4_immed,
				sel => PC_Sel);
				
end Behavioral;
