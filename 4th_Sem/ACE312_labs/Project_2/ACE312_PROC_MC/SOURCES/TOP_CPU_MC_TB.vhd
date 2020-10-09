----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2020 01:40:54
-- Design Name: 
-- Module Name: TOP_CPU_MC_TB - Behavioral
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

entity TOP_CPU_MC_TB is
--  Port ( );
end TOP_CPU_MC_TB;

architecture Behavioral of TOP_CPU_MC_TB is

component TOP_CPU_MC is
   	Port ( 
   			Clk : in std_logic;
   			Rst : in std_logic);
  end component;

  signal Clk: std_logic;
  signal Rst: std_logic;
  signal stop_the_clock : boolean := False;
  constant clk_period : time := 50 ns;
begin

  uut: TOP_CPU_MC port map ( Clk => Clk,
                          Rst => Rst );

  stimulus: process
  begin
	rst <= '0';
	wait for clk_period*2;
	rst <= '1';
	wait for clk_period;
    wait;
  end process;
  
  clocking: process
	begin
  while not stop_the_clock loop
	clk <= '0', '1' after clk_period / 2;
	wait for clk_period;
  end loop;
  wait;
end process;


end Behavioral;
