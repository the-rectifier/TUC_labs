library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EXSTAGE is
	Port (
			RF_A : in std_logic_vector(31 downto 0);
			RF_B : in std_logic_vector(31 downto 0);
			Immed  : in std_logic_vector(31 downto 0);
			ALU_B_Sel : in std_logic;
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

signal mux_out : std_logic_vector(31 downto 0);

begin
	aluing : ALU port map(
						A => RF_A,
						B => mux_out,
						op => ALU_Func,
						alu_out => ALU_OUT,
						zero => ALU_z,
						ovf => open,
						cout => open);
						
	muxing : mux_2_1 port map(
						a => RF_B,
						b => Immed,
						q => mux_out,
						sel => ALU_B_Sel);
end Behavioral;
