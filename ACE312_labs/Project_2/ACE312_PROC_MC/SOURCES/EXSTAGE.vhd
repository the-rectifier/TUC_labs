library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- add 2:1 multilexer to switch between RF_A and PC
-- add 3:1 multiplexer to switch between RF_B +4 and Immed
-- used for +4 the PC and PC(+4 already applies) + Immed when branched
entity EXSTAGE is
	Port (
			PC : in std_logic_vector(31 downto 0);
			RF_A : in std_logic_vector(31 downto 0);
			RF_B : in std_logic_vector(31 downto 0);
			Immed  : in std_logic_vector(31 downto 0);
			ALU_A_Sel : in std_logic;
			ALU_B_Sel : in std_logic_vector(1 downto 0);
			ALU_Func : in std_logic_vector(3 downto 0);
			ALU_OUT : out std_logic_vector(31 downto 0);
			ALU_z : out std_logic);
end EXSTAGE;

architecture Behavioral of EXSTAGE is

component ALU is Port (
            A    : in  std_logic_vector(31 downto 0);
            B   : in  std_logic_vector(31 downto 0);
            OP  : in std_logic_vector(3 downto 0);
            alu_out : out std_logic_vector(31 downto 0);
            zero : out std_logic;
            cout : out std_logic;
            ovf  : out std_logic);
end component;

component mux_2_1 is Port ( sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_3_1 is Port ( sel: in std_logic_vector(1 downto 0);
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal mux_A_out : std_logic_vector(31 downto 0);
signal mux_B_out : std_logic_vector(31 downto 0);

begin
	operand_A : mux_2_1 port map(
					a => PC,
					b => RF_A,
					sel => ALU_A_Sel,
					q => mux_A_out);
					
	operand_B : mux_3_1 port map(
					a => RF_B,
					b => Immed,
					sel => ALU_B_Sel,
					q => mux_B_out);
	
	aluing : ALU port map(
					A => mux_A_out,
					B => mux_B_out,
					OP => ALU_Func,
					zero => ALU_z,
					alu_out => ALU_OUT,
					cout => open,
					ovf => open);
	
end Behavioral;
