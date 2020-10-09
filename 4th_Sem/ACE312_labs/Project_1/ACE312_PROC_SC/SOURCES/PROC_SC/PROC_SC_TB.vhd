library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PROC_SC_tb is
end;

architecture bench of PROC_SC_tb is

  component PROC_SC
   	Port ( 
   			Clk : in std_logic;
   			Rst : in std_logic);
  end component;

  signal Clk: std_logic;
  signal Rst: std_logic;
   signal stop_the_clock: boolean := false;
   constant clk_period : time := 100 ns;

begin

  uut: PROC_SC port map ( Clk => Clk,
                          Rst => Rst );

  stimulus: process
  begin
  
    rst <= '0';
    wait for clk_period * 5;
    rst <= '1';
    -- DEFAULT ROM IS CHARIS_1!!
    -- set the time at 100ns and pulse the clock
    -- cpu should run instructions one by one
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

end;