library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH is
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
  		ALU_B_sel : in std_logic;
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
  		Instr : in std_logic_vector(31 downto 0));
end DATAPATH;

architecture Behavioral of DATAPATH is

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
			RF_A : in std_logic_vector(31 downto 0);
			RF_B : in std_logic_vector(31 downto 0);
			Immed  : in std_logic_vector(31 downto 0);
			ALU_B_Sel : in std_logic;
			ALU_Func : in std_logic_vector(3 downto 0);
			ALU_OUT : out std_logic_vector(31 downto 0);
			ALU_z : out std_logic);
end component;

component IFSTAGE is Port(  
			PC_Sel : in std_logic;
	 		PC_LD	: in std_logic;
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

signal inner_MEM_OUT, inner_RF_A, inner_RF_B, inner_Immed, inner_ALU_OUT : std_logic_vector(31 downto 0);

begin

just_do_it : EXSTAGE port map(
	RF_A => inner_RF_A,
	RF_B => inner_RF_B,
	Immed => inner_Immed,
	ALU_B_Sel => ALU_B_Sel,
	ALU_Func => ALU_Func,
	ALU_z => ALU_z,
	ALU_OUT => inner_ALU_OUT);

fetch_it : IFSTAGE port map(
	PC_Sel => PC_Sel,
	PC_LD => PC_LD,
	PC_Immed => inner_Immed,
	clk => clk, rst => rst,
	PC => PC);
	
save_it : MEMSTAGE port map(
	ByteOp => ByteOp,
	Mem_WE => Mem_WE,
	ALU_MEM_Addr => inner_ALU_OUT,
	MEM_DataIn => inner_RF_B,
	MEM_DataOut => inner_MEM_OUT,
	MM_Addr => MM_Addr, 
	MM_WE => MM_WE,
	MM_DataIn => MM_Din,
	MM_DataOut => MM_Dout);

decode : DECSTAGE port map(
	clk => clk, rst => rst,
	Instr => Instr,
	RF_WE => RF_WE,
	ALU_OUT => inner_ALU_OUT,
	MEM_OUT => inner_MEM_OUT,
	RF_WD_Sel => RF_WD_Sel,
	RF_B_Sel => RF_B_Sel,
	ImmExt => ImmExt,
	Immed => inner_Immed,
	RF_A => inner_RF_A,
	RF_B => inner_RF_B);

end Behavioral;
