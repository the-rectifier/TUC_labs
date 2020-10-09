library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CONTROL_PIPELINE_tb is
end;

architecture bench of CONTROL_PIPELINE_tb is

  component CONTROL_PIPELINE
  	Port (
  		Instr : in std_logic_vector(31 downto 0);
  		WB_flags : out std_logic_vector(1 downto 0);
  		ALU_Flags: out std_logic_vector(4 downto 0);
  		MEM_Flags: out std_logic_vector(1 downto 0);
  		flush : in std_logic);
  end component;

  signal Instr: std_logic_vector(31 downto 0);
  signal WB_flags: std_logic_vector(1 downto 0);
  signal ALU_Flags: std_logic_vector(4 downto 0);
  signal MEM_Flags: std_logic_vector(1 downto 0);
  signal flush: std_logic;

begin

  uut: CONTROL_PIPELINE port map ( Instr     => Instr,
                                   WB_flags  => WB_flags,
                                   ALU_Flags => ALU_Flags,
                                   MEM_Flags => MEM_Flags,
                                   flush     => flush );

  stimulus: process
  begin
  
  	-- li r1, 10
  	-- WB_FLAGS -> 01
  	-- ALU_FLAGS -> 10011
  	-- MEM_FALGS -> 00
  	flush <= '0';
    Instr <= X"e001000a";
	wait for 10 ns;
	flush <= '1';
	wait for 10 ns;
	flush <= '0';
	wait for 10 ns;
    wait;
  end process;


end;