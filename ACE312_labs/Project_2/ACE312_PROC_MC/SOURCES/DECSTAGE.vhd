library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DECSTAGE is
	Port (
		Clk : in std_logic;
		Rst : in std_logic;
		Instr : in std_logic_vector(31 downto 0);
		RF_WE : in std_logic;
		ALU_OUT : in std_logic_vector(31 downto 0);
		MEM_OUT : in std_logic_vector(31 downto 0);
		RF_WD_Sel : in std_logic;
		RF_B_Sel  : in std_logic;
		ImmExt : in std_logic_vector(1 downto 0);
		Immed  : out std_logic_vector(31 downto 0);
		RF_A : out std_logic_vector(31 downto 0);
		RF_B : out std_logic_vector(31 downto 0));
end DECSTAGE;

--Decoding is done asynchronously as soon as the instruction enters the module.
--The immediade gets processed based on the ImmExt signal from the Control however not necessarily used.
--Clk is used only for the Register file in order to Write to the registers

architecture Behavioral of DECSTAGE is 

component register_file is
  Port (
        clk     : in std_logic;
        rst     : in std_logic;
        we      : in std_logic;
        addr_1  : in std_logic_vector(4 downto 0);
        addr_2  : in std_logic_vector(4 downto 0);
        addr_w  : in std_logic_vector(4 downto 0);
        Dout_1  : out std_logic_vector(31 downto 0);
        Dout_2  : out std_logic_vector(31 downto 0);
        Din     : in std_logic_vector(31 downto 0)
        );
end component;

component mux_2_1 is Port ( sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_2_1_5bit is Port(sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (4 downto 0);
           b : in STD_LOGIC_VECTOR (4 downto 0);
           q : out STD_LOGIC_VECTOR (4 downto 0)); 
end component;

component immed_handlr is Port(  
		   immed : in STD_LOGIC_vector(15 downto 0);
           output : out STD_LOGIC_vector(31 downto 0);
           func : in std_logic_vector(1 downto 0));
end component;

signal rs : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal rd : std_logic_vector(4 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal mux_reg_b : std_logic_vector(4 downto 0);
signal mux_data	: std_logic_vector(31 downto 0);

begin
rs <= Instr(25 downto 21);
rt <= Instr(15 downto 11);
rd <= Instr(20 downto 16);
imm <= Instr(15 downto 0);

handle_immed : immed_handlr port map(
							immed => imm,
							func => ImmExt,
							output => Immed);
							
sel_reg : mux_2_1_5bit port map(
						a => rt,
						b => rd,
						sel => RF_B_Sel,
						q => mux_reg_b);
						
sel_data : mux_2_1 port map(
						a => ALU_OUT,
						b => MEM_OUT,
						Sel => RF_WD_Sel,
						q => mux_data);

RF : register_file port map(
						clk => clk,
						rst => rst,
						we => RF_WE,
						addr_1 => rs,
						addr_2 => mux_reg_b,
						addr_w => rd,
						Din => mux_data,
						Dout_1 => RF_A,
						Dout_2 => RF_B);

end Behavioral;
