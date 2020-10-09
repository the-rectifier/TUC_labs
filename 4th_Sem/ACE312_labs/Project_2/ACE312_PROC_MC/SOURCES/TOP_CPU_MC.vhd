----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2020 01:27:36
-- Design Name: 
-- Module Name: TOP_CPU_MC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP_CPU_MC is
	Port ( 
			clk : in std_logic;
			rst : in std_logic);
end TOP_CPU_MC;

architecture Behavioral of TOP_CPU_MC is

component PROCESSOR_MC is Port ( 
 			Clk : in std_logic;
 			Rst : in std_logic;
 			Instr : in std_logic_vector(31 downto 0);
 			Instr_addr : out std_logic_vector(31 downto 0);
 			MM_Addr : out std_logic_vector(31 downto 0);
			MM_WE : out std_logic;
			MM_DataIn : out std_logic_vector(31 downto 0);
			MM_DataOut : in std_logic_vector(31 downto 0));
end component;

component ram is
  Port (
        clk  : in std_logic;
        data_we : in std_logic;
        inst_addr : in std_logic_vector(10 downto 0);
        inst_dout : out std_logic_vector(31 downto 0);
        data_addr : in std_logic_vector(10 downto 0);
        data_din  : in std_logic_vector(31 downto 0);
        data_dout : out std_logic_vector(31 downto 0));
end component;

signal s_Instr : std_logic_vector(31 downto 0);
signal s_Instr_Addr : std_logic_vector(31 downto 0);
signal s_MM_WE : std_logic;
signal s_Data_Addr : std_logic_vector(31 downto 0);
signal s_Data_din : std_logic_vector(31 downto 0);
signal s_Data_dout : std_logic_vector(31 downto 0);

begin

cpu: PROCESSOR_MC port map(
			clk => clk, rst=> rst,
			Instr => S_Instr,
			Instr_Addr => S_Instr_Addr,
			MM_Addr => s_Data_Addr,
			MM_WE => s_MM_WE,
			MM_DataIn => s_Data_din,
			MM_DataOut => s_Data_dout);

rammit : ram port map(
			clk => clk,
			data_we => s_MM_WE,
			inst_addr => s_Instr_Addr(12 downto 2),
			inst_dout => s_Instr,
			data_addr => s_Data_Addr(12 downto 2),
			data_din => s_Data_din,
			data_dout => s_Data_dout);

end Behavioral;
