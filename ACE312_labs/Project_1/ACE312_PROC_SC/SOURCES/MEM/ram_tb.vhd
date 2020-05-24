library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ram_tb is
end;

architecture bench of ram_tb is

  component ram
    Port (
          clk  : in std_logic;
          data_we : in std_logic;
          inst_addr : in std_logic_vector(10 downto 0);
          inst_dout : out std_logic_vector(31 downto 0);
          data_addr : in std_logic_vector(10 downto 0);
          data_din  : in std_logic_vector(31 downto 0);
          data_dout : out std_logic_vector(31 downto 0));
  end component;

  signal clk: std_logic;
  signal data_we: std_logic;
  signal inst_addr: std_logic_vector(10 downto 0);
  signal inst_dout: std_logic_vector(31 downto 0);
  signal data_addr: std_logic_vector(10 downto 0);
  signal data_din: std_logic_vector(31 downto 0);
  signal data_dout: std_logic_vector(31 downto 0);

  constant clk_period: time := 100 ns;
  signal stop_the_clock: boolean;

begin

  uut: ram port map ( clk       => clk,
                      data_we   => data_we,
                      inst_addr => inst_addr,
                      inst_dout => inst_dout,
                      data_addr => data_addr,
                      data_din  => data_din,
                      data_dout => data_dout );

  stimulus: process
  begin
  
    wait for 10 ns;
    -- instruction at pos 4 of ram
    inst_addr <= std_logic_vector(to_unsigned(4,11));
    -- try to write with no write enable
    data_we <= '0';
    data_din <= X"FFFF_B134";
    data_addr <= std_logic_vector(to_unsigned(1500,11));
    wait for clk_period;
    data_we <= '1';
    wait for clk_period;
    -- write it -> change address then come back to check
    data_we <= '0';
    data_addr <= std_logic_vector(to_unsigned(1600,11));
    wait for clk_period;
    data_addr <= std_logic_vector(to_unsigned(1500,11));
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