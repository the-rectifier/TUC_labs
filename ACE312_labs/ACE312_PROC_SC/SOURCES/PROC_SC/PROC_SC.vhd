library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROC_SC is
 	Port ( 
 			Clk : in std_logic;
 			Rst : in std_logic);
end PROC_SC;

architecture Behavioral of PROC_SC is

component DATAPATH is Port ( 
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
end component;

component CONTROL is Port (
		Instr : in std_logic_vector(31 downto 0);
		ALU_z : in std_logic;
		ALU_Func: out std_logic_vector(3 downto 0); --done 
		PC_Sel : out std_logic; --done
		RF_WD_Sel: out std_logic; --done
		RF_B_Sel : out std_logic; --done
		RF_WE : out std_logic; --done
		ImmExt : out std_logic_vector(1 downto 0); --done
		ALU_B_Sel : out std_logic; --done
		ByteOp : out std_logic; --done
		MEM_WE : out std_logic); --done
end component;

component ram is Port (
        clk  : in std_logic;
        data_we : in std_logic;
        inst_addr : in std_logic_vector(10 downto 0);
        inst_dout : out std_logic_vector(31 downto 0);
        data_addr : in std_logic_vector(10 downto 0);
        data_din  : in std_logic_vector(31 downto 0);
        data_dout : out std_logic_vector(31 downto 0));
end component;

signal s_ByteOp : std_logic;
signal s_Instr : std_logic_vector(31 downto 0);
signal s_ALU_z : std_logic;
signal s_ALU_Func : std_logic_vector(3 downto 0);
signal s_PC_Sel : std_logic;
signal s_RF_WD_Sel : std_logic;
signal s_RF_B_Sel : std_logic;
signal s_RF_WE : std_logic;
signal s_ImmExt : std_logic_vector(1 downto 0);
signal s_ALU_B_Sel : std_logic;
signal s_MEM_WE : std_logic;
signal s_MEM_DataIn : std_logic_vector(31 downto 0);
signal s_MEM_DataOut : std_logic_vector(31 downto 0);
signal s_MM_Addr : std_logic_vector(31 downto 0);
signal s_MM_WE : std_logic;
signal s_MM_DataIn : std_logic_vector(31 downto 0);
signal s_MM_DataOut : std_logic_vector(31 downto 0);
signal s_Instr_Addr : std_logic_vector(31 downto 0);
signal s2_MM_WE : std_logic;
begin

control_it : CONTROL port map(
					Instr => s_Instr,
					ALU_z => s_ALU_z,
					PC_Sel => s_PC_Sel,
					RF_WD_Sel => s_RF_WD_Sel,
					RF_B_Sel => s_RF_B_Sel,
					RF_WE => s_RF_WE,
					ImmExt => s_ImmExt,
					ALU_B_Sel => s_ALU_B_Sel,
					ALU_Func => s_ALU_Func,
					ByteOp => s_ByteOp,
					MEM_WE => s_MEM_we);
					
path_it : DATAPATH port map(
					Clk => Clk,
					Rst => Rst,
					ByteOp => s_ByteOp,
					Mem_We => s_MEM_WE,
					MM_Dout => s_MM_DataOut,
					MM_Addr => s_MM_Addr,
					MM_Din => s_MM_DataIn,
					MM_WE => s2_MM_WE,
					ALU_B_Sel => s_ALU_B_Sel,
					ALU_Func => s_ALU_Func,
					ALU_z => s_ALU_z,
					PC_Sel => s_PC_Sel,
					PC_LD => '1',
					PC => s_Instr_Addr,
					RF_WE => s_RF_WE,
					RF_WD_Sel => s_RF_WD_Sel, 
					RF_B_Sel => s_RF_B_Sel,
					ImmExt => s_ImmExt, 
					Instr => s_Instr);	

ramm_it : ram port map(
				clk => Clk,
				data_we => s2_MM_WE,
				inst_addr => s_Instr_Addr(12 downto 2),
				inst_dout => s_Instr,
				data_addr => s_MM_Addr(12 downto 2),
				data_din => s_MM_DataIn,
				data_dout => s_MM_DataOut);
end Behavioral;
