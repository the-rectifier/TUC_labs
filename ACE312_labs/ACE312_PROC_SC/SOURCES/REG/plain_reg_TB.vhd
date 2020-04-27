library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity plain_reg_tb is
end;

architecture bench of plain_reg_tb is

  component plain_reg
        Port (
              Data_in : in std_logic_vector(31 downto 0);
              WE  : in std_logic;
              Data_out : out std_logic_vector(31 downto 0);
              clk : in std_logic;
              rst : in std_logic 
              );
  end component;

  signal Data_in: std_logic_vector(31 downto 0);
  signal WE: std_logic;
  signal Data_out: std_logic_vector(31 downto 0);
  signal clk: std_logic;
  signal rst: std_logic;

  constant CLK_period: time := 100 ns;
  signal stop_the_clock: boolean;

begin
	
  uut: plain_reg port map ( Data_in  => Data_in,
                            WE       => WE,
                            Data_out => Data_out,
                            clk      => clk,
                            rst      => rst 
									 );
									 
									    -- Clock process definitions

  stimulus: process
  begin
  
    -- Put initialisation code here
    Data_in <= X"FFAA_B0B0";
	we <= '0';
    wait for clk_period; 
    rst <= '0';
    wait for clk_period * 5;
    rst <= '1';
    we <= '1';
    --write it
    wait for clk_period;
    rst <= '0';
    --reset it
    wait for clk_period;
    rst <= '1';
    we <= '0';
    -- try to write with no enable
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

end;