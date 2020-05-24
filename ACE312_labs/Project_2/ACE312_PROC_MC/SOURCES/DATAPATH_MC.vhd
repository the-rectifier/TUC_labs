library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH_MC is
  Port ( 
  		Clk : in std_logic;
  		Rst : in std_logic;
  		
  		--MEMSTAGE 
  		--from Control:
  		ByteOp: in std_logic;
  		Mem_We: in std_logic;
  		--from MM:
  		MM_Dout : in std_logic_vector(31 downto 0);
  		--to MM:
  		MM_Addr: out std_logic_vector(31 downto 0);
  		MM_We: out std_logic;
  		MM_Din : out std_logic_vector(31 downto 0);
  		
  		--EXSTAGE:
  		--From Control:
  		ALU_A_Sel : in std_logic;
  		ALU_B_sel : in std_logic_vector(1 downto 0);
  		ALU_Func : in std_logic_vector(3 downto 0);
  		--To Control:
  		ALU_z : out std_logic;
  		
  		--IFSTAGE:
  		--From Control:
  		PC_Sel : in std_logic;
  		PC_LD : in std_logic;
  		--To Control:
  		PC : out std_logic_vector(31 downto 0);
  		
  		--DECSTAGE:
  		--From Control:
  		RF_WE: in std_logic;
  		RF_WD_Sel : in std_logic;
  		RF_B_Sel : in std_logic;
  		ImmExt : in std_logic_vector(1 downto 0);
  		--From MM:
  		Instr : in std_logic_vector(31 downto 0);
  		
  		Instr_out : out std_logic_vector(31 downto 0);
  		IRWrite : in std_logic);
end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is

component MEMSTAGE is Port (
  		 ByteOp : in std_logic;
  		 Mem_WE : in std_logic;
  		 ALU_MEM_Addr : in std_logic_vector(31 downto 0);
  		 MEM_DataIn : in std_logic_vector(31 downto 0);
  		 MEM_DataOut : out std_logic_vector(31 downto 0);
  		 MM_Addr : out std_logic_vector(31 downto 0);
  		 MM_WE : out std_logic;
  		 MM_DataIn : out std_logic_vector(31 downto 0);
  		 MM_DataOut : in std_logic_vector(31 downto 0));
end component;

component EXSTAGE is Port (
		PC : in std_logic_vector(31 downto 0);
		RF_A : in std_logic_vector(31 downto 0);
		RF_B : in std_logic_vector(31 downto 0);
		Immed  : in std_logic_vector(31 downto 0);
		ALU_A_Sel : in std_logic;
		ALU_B_Sel : in std_logic_vector(1 downto 0);
		ALU_Func : in std_logic_vector(3 downto 0);
		ALU_OUT : out std_logic_vector(31 downto 0);
		ALU_z : out std_logic);
end component;

component IFSTAGE_MC is Port(  
		PC_Sel : in std_logic;
		PC_LD : in std_logic;
		PC_4 : in std_logic_vector(31 downto 0);
		PC_Immed : in std_logic_vector(31 downto 0);
		clk	: in std_logic;
		rst : in std_logic;
		PC : out std_logic_vector(31 downto 0));
end component;

component DECSTAGE is Port (
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
end component;

component plain_reg is Port(
		Data_in : in std_logic_vector(31 downto 0);
		WE  : in std_logic;
		Data_out : out std_logic_vector(31 downto 0);
		clk : in std_logic;
		rst : in std_logic 
		);
end component;

signal inner_MEM_OUT : std_logic_vector(31 downto 0);
signal inner_RF_A : std_logic_vector(31 downto 0);
signal inner_RF_B : std_logic_vector(31 downto 0);
signal inner_Immed : std_logic_vector(31 downto 0);
signal inner_ALU_OUT : std_logic_vector(31 downto 0);
signal inner_PROG_COUNT : std_logic_vector(31 downto 0);

signal inner_ALU_OUT_REG : std_logic_vector(31 downto 0);

signal inner_RF_A_REG : std_logic_vector(31 downto 0);

signal inner_RF_B_REG : std_logic_vector(31 downto 0);

signal inner_MEM_DATA_REG : std_logic_vector(31 downto 0);

signal inner_INST_DATA_REG : std_logic_vector(31 downto 0);

begin

PC <= inner_PROG_COUNT;
alu_reg : plain_reg port map(
					Data_in => inner_ALU_OUT,
					we => '1',
					Data_out => inner_ALU_OUT_REG,
					clk => clk, rst => rst);

RF_A_reg : plain_reg port map(
					Data_in => inner_RF_A,
					WE => '1',
					Data_out => inner_RF_A_REG,
					clk => clk, rst => rst);

RF_B_reg : plain_reg port map(
					Data_in => inner_RF_B,
					WE => '1',
					Data_out => inner_RF_B_REG,
					clk => clk, rst => rst);
					
MEM_DATA_REG : plain_reg port map(
					Data_in => inner_MEM_OUT,
					we => '1',
					Data_out => inner_MEM_DATA_REG,
					clk => clk, rst => rst);
					
INST_DATA_REG : plain_reg port map(
					Data_in => Instr,
					WE => IRWrite,
					Data_out => inner_INST_DATA_REG,
					clk => clk, rst => rst);

instruction_fetching : IFSTAGE_MC port map(
					PC_Sel => PC_Sel,
					PC_LD => PC_LD,
					PC_Immed => inner_ALU_OUT_REG,
					PC_4 => inner_ALU_OUT,
					clk => clk, rst => rst,
					PC => inner_PROG_COUNT);

rammit: MEMSTAGE port map(
					ByteOP => ByteOP,
					MEM_We => MEM_we,
					ALU_MEM_Addr => inner_ALU_OUT_REG,
					MEM_DataIn => inner_RF_B_REG,
					MEM_DataOut => inner_MEM_OUT,
					MM_Addr => MM_Addr,
					MM_WE => MM_WE,
					MM_DataIn => MM_Din,
					MM_DataOut => MM_Dout);
					
decode: DECSTAGE port map(
					clk => clk, rst => rst,
					Instr => inner_INST_DATA_REG,
					RF_WE => RF_WE,
					ALU_OUT => inner_ALU_OUT_REG,
					MEM_OUT => inner_MEM_DATA_REG,
					RF_WD_Sel => RF_WD_Sel,
					RF_B_Sel => RF_B_Sel,
					ImmExt => ImmExt,
					RF_A => inner_RF_A,
					RF_B => inner_RF_B,
					Immed => inner_Immed);
					
do_it: EXSTAGE port map(
					PC => inner_PROG_COUNT,
					RF_A => inner_RF_A_REG,
					RF_B => inner_RF_B_REG,
					Immed => inner_Immed,
					ALU_A_Sel => ALU_A_Sel,
					ALU_B_Sel => ALU_B_Sel,
					ALU_Func => ALU_Func,
					ALU_OUT => inner_ALU_OUT,
					ALU_z => ALU_z);
	
Instr_out <= inner_INST_DATA_REG;
end Behavioral;
