library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_test is
	Port (clk: in std_logic;
			rst : in std_logic );
end top_test;

architecture Behavioral of top_test is

component ram is port (
        clk  : in std_logic;
        data_we : in std_logic;
        inst_addr : in std_logic_vector(10 downto 0);
        inst_dout : out std_logic_vector(31 downto 0);
        data_addr : in std_logic_vector(10 downto 0);
        data_din  : in std_logic_vector(31 downto 0);
        data_dout : out std_logic_vector(31 downto 0));
end component;

component PROCESSOR_PIPELINE is
	Port (	clk: in std_logic;
			rst : in std_logic;
			Instr: in std_logic_vector(31 downto 0);
			Instr_addr : out std_logic_vector(31 downto 0);
			MM_Addr : out std_logic_vector(31 downto 0);
			MM_WE : out std_logic;
			MM_DataIn : out std_logic_vector(31 downto 0);
			MM_DataOut : in std_logic_vector(31 downto 0));
end component;
			
signal s_mm_we : std_logic;
signal s_mm_addr : std_logic_vector(31 downto 0);
signal s_mm_datain : std_logic_vector(31 downto 0);    			
signal s_mm_dataout : std_logic_vector(31 downto 0);    
signal s_instr : std_logic_vector(31 downto 0);
signal s_instr_addr: std_logic_vector(31 downto 0);
begin

ramming : ram port map(clk=>clk,
					data_we=>s_mm_we,
					inst_addr=>s_instr_addr(12 downto 2),
					inst_dout=>s_instr,
					data_addr=>s_mm_addr(12 downto 2),
					data_din=>s_mm_datain,
					data_dout=>s_mm_dataout);
					
cpu : PROCESSOR_PIPELINE port map(clk=>clk,rst=>rst,
					Instr=>s_instr,
					Instr_addr=>s_instr_addr,
					MM_ADDR=>S_MM_ADDR,
					MM_WE=>S_MM_WE,
					MM_DATAIN=>S_MM_DATAIN,
					MM_DATAOUT=>S_MM_DATAOUT);

end Behavioral;
