library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DECSTAGE_tb is
end;

architecture bench of DECSTAGE_tb is

  component DECSTAGE
  	Port (
  		Clk : in std_logic;
  		Rst : in std_logic;
  		Instr : in std_logic_vector(31 downto 0);
  		RF_WE : in std_logic;
  		Data : in std_logic_vector(31 downto 0);
  		RD_in : in std_logic_vector(4 downto 0);
  		Immed  : out std_logic_vector(31 downto 0);
  		RF_A : out std_logic_vector(31 downto 0);
  		RF_B : out std_logic_vector(31 downto 0);
  		RD_OUT : out std_logic_vector(4 downto 0);
  		RS_OUT : out std_logic_vector(4 downto 0);
  		RT_OUT : out std_logic_vector(4 downto 0));
  end component;

  signal Clk: std_logic;
  signal Rst: std_logic;
  signal Instr: std_logic_vector(31 downto 0);
  signal RF_WE: std_logic;
  signal Data: std_logic_vector(31 downto 0);
  signal RD_in: std_logic_vector(4 downto 0);
  signal Immed: std_logic_vector(31 downto 0);
  signal RF_A: std_logic_vector(31 downto 0);
  signal RF_B: std_logic_vector(31 downto 0);
  signal RD_OUT: std_logic_vector(4 downto 0);
  signal RS_OUT: std_logic_vector(4 downto 0);
  signal RT_OUT: std_logic_vector(4 downto 0);
  constant clk_period : time := 100 ns;
  signal stop_the_clock : boolean := False; 

begin

  uut: DECSTAGE port map ( Clk    => Clk,
                           Rst    => Rst,
                           Instr  => Instr,
                           RF_WE  => RF_WE,
                           Data   => Data,
                           RD_in  => RD_in,
                           Immed  => Immed,
                           RF_A   => RF_A,
                           RF_B   => RF_B,
                           RD_OUT => RD_OUT,
                           RS_OUT => RS_OUT,
                           RT_OUT => RT_OUT );

	stimulus: process
	begin
		rst <= '0';
		wait for clk_period;
		rst <= '1';
		Instr <= "11000000000001010000000000001000";
		wait for clk_period;
		Instr <= "11001100000000111010101111001101";
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
