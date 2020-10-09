library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MEM_WB_tb is
end;

architecture bench of MEM_WB_tb is

  component MEM_WB port(
  			clk : in std_logic; 
  			rst : in std_logic;
  			WB_flags_in : in std_logic_vector(1 downto 0);
  			RF_WE : out std_logic;
  			RF_WD_Sel : out std_logic;
  			MEM_DATA_in : in std_logic_vector(31 downto 0);
  			MEM_DATA_out : out std_logic_vector(31 downto 0);
  			R_DATA_in : in std_logic_vector(31 downto 0);
  			R_DATA_out : out std_logic_vector(31 downto 0);
  			RD_IN : in std_logic_vector(4 downto 0);
  			RD_out : out std_logic_vector(4 downto 0));
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal WB_flags_in: std_logic_vector(1 downto 0);
  signal RF_WE: std_logic;
  signal RF_WD_Sel: std_logic;
  signal MEM_DATA_in: std_logic_vector(31 downto 0);
  signal MEM_DATA_out: std_logic_vector(31 downto 0);
  signal R_DATA_in: std_logic_vector(31 downto 0);
  signal R_DATA_out: std_logic_vector(31 downto 0);
  signal RD_IN: std_logic_vector(4 downto 0);
  signal RD_out: std_logic_vector(4 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: MEM_WB port map ( clk          => clk,
                         rst          => rst,
                         WB_flags_in  => WB_flags_in,
                         RF_WE        => RF_WE,
                         RF_WD_Sel    => RF_WD_Sel,
                         MEM_DATA_in  => MEM_DATA_in,
                         MEM_DATA_out => MEM_DATA_out,
                         R_DATA_in    => R_DATA_in,
                         R_DATA_out   => R_DATA_out,
                         RD_IN        => RD_IN,
                         RD_out       => RD_out );

  stimulus: process
  begin
  
  	rst <= '0';
  	wait for clock_period;
  	rst <= '1';
    WB_FLAGS_IN <= "11";
    MEM_DATA_IN <= X"AAFF_BEEF";
    R_DATA_IN <= X"B0BE_BEEF";
    RD_IN <= "00101";

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;