library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity IFSTAGE_tb is
end;

architecture bench of IFSTAGE_tb is

  component IFSTAGE
  	 Port(  PC_Sel : in std_logic;
  	 		PC_LD	: in std_logic;
  	 		PC_Immed : in std_logic_vector(31 downto 0);
  	 		clk	: in std_logic;
  	 		rst : in std_logic;
  	 		PC : out std_logic_vector(31 downto 0));
  end component;
  
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

  signal PC_Sel: std_logic;
  signal PC_LD: std_logic;
  signal PC_Immed: std_logic_vector(31 downto 0);
  signal clk: std_logic;
  signal rst: std_logic;
  signal PC: std_logic_vector(31 downto 0);
  signal inst : std_logic_vector(31 downto 0);
  signal stop_the_clock : boolean := False;
  constant clk_period : time := 100 ns;
begin

  uut: IFSTAGE port map ( PC_Sel   => PC_Sel,
                          PC_LD    => PC_LD,
                          PC_Immed => PC_Immed,
                          clk      => clk,
                          rst      => rst,
                          PC       => PC );
  ramming: ram port map(
  						clk => clk,
  						data_we => '0',
  						data_addr => B"00000000000",
  						data_dout => open,
  						data_din => X"0000_0000",
  						inst_dout => inst,
  						inst_addr => PC(12 downto 2)
  						);
  stimulus: process
  begin
  
  	PC_Sel <= '0';
  	PC_LD <= '1';
  	PC_Immed <= X"DEAD_BEEF";
  	
    rst <= '0';
    wait for clk_period;
    rst <= '1';
    wait for clk_period * 5;
    
    PC_Sel <= '1';
    wait for clk_period;
    PC_Sel <= '0';
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