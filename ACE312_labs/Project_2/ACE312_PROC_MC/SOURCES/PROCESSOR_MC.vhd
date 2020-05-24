library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSOR_MC is
 	Port ( 
 			Clk : in std_logic;
 			Rst : in std_logic;
 			Instr : in std_logic_vector(31 downto 0);
 			Instr_addr : out std_logic_vector(31 downto 0);
 			MM_Addr : out std_logic_vector(31 downto 0);
			MM_WE : out std_logic;
			MM_DataIn : out std_logic_vector(31 downto 0);
			MM_DataOut : in std_logic_vector(31 downto 0));
end PROCESSOR_MC;

architecture Behavioral of PROCESSOR_MC is

component DATAPATH_MC is Port ( 
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
end component;

component CONTROL_MC is Port (
		clk : in std_logic;
		rst : in std_logic;
		Instr : in std_logic_vector(31 downto 0);
		ALU_z : in std_logic;
		ALU_Func: out std_logic_vector(3 downto 0); --done 
		PC_Sel : out std_logic; --done
		PC_LD : out std_logic;
		RF_WD_Sel: out std_logic; --done
		RF_B_Sel : out std_logic; --done
		RF_WE : out std_logic; --done
		ImmExt : out std_logic_vector(1 downto 0); --done
		ALU_A_Sel : out std_logic;
		ALU_B_Sel : out std_logic_vector(1 downto 0); --done
		ByteOp : out std_logic; --done
		MEM_WE : out std_logic;
		IRWrite : out std_logic); --done
end component;

signal s_ByteOp : std_logic;
signal s_ALU_z : std_logic;
signal s_ALU_Func : std_logic_vector(3 downto 0);
signal s_PC_Sel : std_logic;
signal s_RF_WD_Sel : std_logic;
signal s_RF_B_Sel : std_logic;
signal s_RF_WE : std_logic;
signal s_ImmExt : std_logic_vector(1 downto 0);
signal s_ALU_A_Sel : std_logic;
signal s_ALU_B_Sel : std_logic_vector(1 downto 0);
signal s_MEM_WE : std_logic;
signal s_MEM_DataIn : std_logic_vector(31 downto 0);
signal s_MEM_DataOut : std_logic_vector(31 downto 0);
signal s2_MM_WE : std_logic;
signal s_IRWrite : std_logic;
signal s_PC_LD : std_logic;
signal s_Instr_Control : std_logic_vector(31 downto 0);
begin

control_it : CONTROL_MC port map(
					clk => clk , rst => rst,
					Instr => s_Instr_Control,
					ALU_z => s_ALU_z,
					PC_Sel => s_PC_Sel,
					PC_LD => s_PC_LD,
					RF_WD_Sel => s_RF_WD_Sel,
					RF_B_Sel => s_RF_B_Sel,
					RF_WE => s_RF_WE,
					ImmExt => s_ImmExt,
					ALU_A_Sel => s_ALU_A_Sel,
					ALU_B_Sel => s_ALU_B_Sel,
					ALU_Func => s_ALU_Func,
					ByteOp => s_ByteOp,
					MEM_WE => s_MEM_we,
					IRWrite => s_IRWrite);
					
path_it : DATAPATH_MC port map(
					Clk => Clk,
					Rst => Rst,
					ByteOp => s_ByteOp,
					Mem_We => s_MEM_WE,
					MM_Dout => MM_DataOut,
					MM_Addr => MM_Addr,
					MM_Din => MM_DataIn,
					MM_WE => MM_WE,
					ALU_A_Sel => s_ALU_A_Sel,
					ALU_B_Sel => s_ALU_B_Sel,
					ALU_Func => s_ALU_Func,
					ALU_z => s_ALU_z,
					PC_Sel => s_PC_Sel,
					PC_LD => s_PC_LD,
					PC => Instr_Addr,
					RF_WE => s_RF_WE,
					RF_WD_Sel => s_RF_WD_Sel, 
					RF_B_Sel => s_RF_B_Sel,
					ImmExt => s_ImmExt, 
					Instr => Instr,
					Instr_out => s_Instr_Control,
					IRWrite => s_IRWrite);	
end Behavioral;
