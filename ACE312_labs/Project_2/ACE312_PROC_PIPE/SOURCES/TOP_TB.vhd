library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_test_tb is
end;

architecture bench of top_test_tb is

  component top_test
  	Port (clk: in std_logic;
  			rst : in std_logic );
  end component;

  signal clk: std_logic;
  signal rst: std_logic ;
  signal stop_the_clock: boolean := false;
   constant clk_period : time := 50 ns;

begin

  uut: top_test port map ( clk => clk,
                           rst => rst );

  stimulus: process
  begin
  	rst <= '0';
	wait for clk_period;
	rst <= '1';
	--wait for clk_period;
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