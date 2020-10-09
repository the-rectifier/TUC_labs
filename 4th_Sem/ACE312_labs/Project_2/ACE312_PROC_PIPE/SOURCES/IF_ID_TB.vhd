library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity IF_ID_tb is
end;

architecture bench of IF_ID_tb is

  component IF_ID port
  	(
  		clk : in std_logic;
  		rst : in std_logic;
  		IFID_WE : in std_logic;
  		Instr_in : in std_logic_vector(31 downto 0);
  		Instr_out : out std_logic_vector(31 downto 0);
  		RD_OUT : out std_logic_vector(4 downto 0);
  		RS_OUT : out std_logic_vector(4 downto 0);
  		RT_OUT : out std_logic_vector(4 downto 0));
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal IFID_WE: std_logic;
  signal Instr_in: std_logic_vector(31 downto 0);
  signal Instr_out: std_logic_vector(31 downto 0);
  signal RD_OUT: std_logic_vector(4 downto 0);
  signal RS_OUT: std_logic_vector(4 downto 0);
  signal RT_OUT: std_logic_vector(4 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: IF_ID port map ( clk       => clk,
                        rst       => rst,
                        IFID_WE   => IFID_WE,
                        Instr_in  => Instr_in,
                        Instr_out => Instr_out,
                        RD_OUT    => RD_OUT,
                        RS_OUT    => RS_OUT,
                        RT_OUT    => RT_OUT );

  stimulus: process
  begin
  
    rst<= '0';
    wait for clock_period;
    rst <= '1';
    IFID_WE <= '1';
    Instr_in <= B"000000_01010_01111_01011_00000_000000";
    wait for clock_period;
    IFID_WE <= '0';
    Instr_in <= B"000000_01010_11111_11111_00000_000000";
    wait for clock_period;

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
  