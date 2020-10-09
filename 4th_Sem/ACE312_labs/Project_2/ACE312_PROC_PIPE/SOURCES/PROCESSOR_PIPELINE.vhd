library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSOR_PIPELINE is
	Port (	clk: in std_logic;
			rst : in std_logic;
			Instr: in std_logic_vector(31 downto 0);
			Instr_addr : out std_logic_vector(31 downto 0);
			MM_Addr : out std_logic_vector(31 downto 0);
			MM_WE : out std_logic;
			MM_DataIn : out std_logic_vector(31 downto 0);
			MM_DataOut : in std_logic_vector(31 downto 0));
end PROCESSOR_PIPELINE;

architecture Behavioral of PROCESSOR_PIPELINE is

component control_pipeline is port(
		flush : in std_logic;
		Instr : in std_logic_vector(31 downto 0);
		WB_flags : out std_logic_vector(1 downto 0);
		ALU_Flags: out std_logic_vector(4 downto 0);
		MEM_Flags: out std_logic_vector(1 downto 0));
end component;

component datapath_pipeline is port(
		clk : in std_logic;
		rst : in std_logic;
		
		flush : out std_logic;
		WB_flags : in std_logic_vector(1 downto 0); 
		MEM_flags : in std_logic_vector(1 downto 0); 
		Alu_flags: in std_logic_vector(4 downto 0); 
		Instr : in std_logic_vector(31 downto 0);  
		Instr_control : out std_logic_vector(31 downto 0);
		Instr_addr : out std_logic_vector(31 downto 0);
		MM_Addr : out std_logic_vector(31 downto 0);
		MM_WE : out std_logic;
		MM_DataIn : out std_logic_vector(31 downto 0);
		MM_DataOut : in std_logic_vector(31 downto 0));
end component;	


signal s_wb_flags : std_logic_vector(1 downto 0);
signal s_alu_flags: std_logic_vector(4 downto 0);
signal s_mem_flags: std_logic_vector(1 downto 0);    
signal s_instr_datapath : std_logic_vector(31 downto 0);		
signal s_flush : std_logic;	
signal s_instr : std_logic_vector(31 downto 0);
begin
s_instr <= Instr;

control_it : control_pipeline port map(
							Instr=> s_instr_datapath,
							wb_flags=>s_wb_flags,
							mem_flags=>s_mem_flags,
							alu_flags=>s_alu_flags,
							flush=>s_flush);	
			
datapath: datapath_pipeline port map(clk=>clk, rst=>rst,
							Instr_control=>s_instr_datapath,
							WB_flags=>S_wb_flags,
							MEM_FLAGS=>S_MEM_FLAGS,
							ALU_FLAGS=>S_ALU_FLAGS,
							INSTR=>s_instr,
							INSTR_Addr=>Instr_Addr,
							MM_Addr=>MM_ADDR,
							mm_we=>mm_we,
							mm_datain=>mm_datain,
							mm_dataout=>mm_dataout,
							flush=>s_flush);

end Behavioral;
