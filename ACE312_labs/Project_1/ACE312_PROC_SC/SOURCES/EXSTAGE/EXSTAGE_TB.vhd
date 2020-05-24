library IEEE;
use IEEE.Std_logic_1164.all;

entity EXSTAGE_tb is
end;

architecture bench of EXSTAGE_tb is

  component EXSTAGE
  	Port (
  			RF_A : in std_logic_vector(31 downto 0);
  			RF_B : in std_logic_vector(31 downto 0);
  			Immed  : in std_logic_vector(31 downto 0);
  			ALU_B_Sel : in std_logic;
  			ALU_Func : in std_logic_vector(3 downto 0);
  			ALU_OUT : out std_logic_vector(31 downto 0);
  			ALU_z : out std_logic);
  end component;

  signal RF_A: std_logic_vector(31 downto 0);
  signal RF_B: std_logic_vector(31 downto 0);
  signal Immed: std_logic_vector(31 downto 0);
  signal ALU_B_Sel: std_logic;
  signal ALU_Func: std_logic_vector(3 downto 0);
  signal ALU_OUT: std_logic_vector(31 downto 0);
  signal ALU_z: std_logic;

begin

  uut: EXSTAGE port map ( RF_A      => RF_A,
                          RF_B      => RF_B,
                          Immed     => Immed,
                          ALU_B_Sel => ALU_B_Sel,
                          ALU_Func  => ALU_Func,
                          ALU_OUT   => ALU_OUT,
                          ALU_z     => ALU_z );

  stimulus: process
  begin
  
    --Test the multiplexer and more or less the ALU
    RF_A <= x"FFFF_B0B1";
    RF_B <= x"F00D_F00D";
    Immed <= x"DEAD_BEEF";
    
    ALU_Func <= "0000";
    
    ALU_B_Sel <= '0';
    wait for 100 ns;
    ALU_B_Sel <= '1';
    wait for 100 ns;
    
    wait;
  end process;


end;