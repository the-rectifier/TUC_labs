library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity register_file_tb is
end;

architecture bench of register_file_tb is

  component register_file
    Port (
          clk     : in std_logic;
          rst     : in std_logic;
          we      : in std_logic;
          addr_1  : in std_logic_vector(4 downto 0);
          addr_2  : in std_logic_vector(4 downto 0);
          addr_w  : in std_logic_vector(4 downto 0);
          Dout_1  : out std_logic_vector(31 downto 0);
          Dout_2  : out std_logic_vector(31 downto 0);
          Din     : in std_logic_vector(31 downto 0)
          );
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal we: std_logic;
  signal addr_1: std_logic_vector(4 downto 0);
  signal addr_2: std_logic_vector(4 downto 0);
  signal addr_w: std_logic_vector(4 downto 0);
  signal Dout_1: std_logic_vector(31 downto 0);
  signal Dout_2: std_logic_vector(31 downto 0);
  signal Din: std_logic_vector(31 downto 0) ;
  
  constant CLK_period: time := 100 ns;
  signal stop_the_clock: boolean;

begin
  
  uut: register_file port map ( clk    => clk,
                                rst    => rst,
                                we     => we,
                                addr_1 => addr_1,
                                addr_2 => addr_2,
                                addr_w => addr_w,
                                Dout_1 => Dout_1,
                                Dout_2 => Dout_2,
                                Din    => Din );
										  
								-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;


  stimulus: process
  begin
  
    addr_1 <= B"00000";
    addr_2 <= B"00010";
    rst <= '0';
	we <= '0';
    wait for clk_period*5; --Check the Outputs 
    rst <= '1';
    wait for clk_period;
	 
    Din <= X"FAFA_BA6A";
    we <= '1';
    addr_w <= B"11010"; --reg26 <= FAFA_BA6A.hex
    wait for clk_period;
	 
    we <= '0';
    addr_1 <= B"11010";
    wait for clk_period; --Dout1 <= FAFA_BA6A.hex
	 
    addr_w <= B"11111";
    we <= '1';
    Din <= X"ABBA_BABA";
    wait for clk_period; --reg31 <= ABBA_BABA.hex
	 
    we <= '0';
    addr_2 <= B"11111";
    wait for clk_period; --Dout2 <= ABBA_BABA.hex
	 
    addr_w <= B"11011";
    we <= '1';
    Din <= X"FEFE_BABA";
    wait for clk_period;
	 
    we <= '0';
    addr_1 <= B"11011";
    wait for clk_period;
	 
    addr_1 <= B"11010";
    rst <= '0';
    wait for clk_period;
    rst <= '1';
    wait for clk_period;
    wait;
  end process;

  --clocking: process
  --begin
   -- while not stop_the_clock loop
     -- clk <= '0', '1' after clk_period / 2;
      --wait for clk_period;
    --end loop;
    --wait;
  --end process;
end;