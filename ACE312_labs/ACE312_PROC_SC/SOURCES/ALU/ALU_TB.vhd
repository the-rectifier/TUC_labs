library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end;

architecture bench of ALU_tb is
  
  component ALU
      Port ( 
              A    : in  std_logic_vector(31 downto 0);
              B   : in  std_logic_vector(31 downto 0);
              OP  : in std_logic_vector(3 downto 0);
              alu_out : out std_logic_vector(31 downto 0);
              zero : out std_logic;
              cout : out std_logic;
              ovf  : out std_logic
          );
  end component;

  signal A: std_logic_vector(31 downto 0) := (others=>'0');
  signal B: std_logic_vector(31 downto 0) := (others=>'0');
  signal OP: std_logic_vector(3 downto 0) := (others=>'0');
  
  signal alu_out: std_logic_vector(31 downto 0);
  signal zero: std_logic;
  signal cout: std_logic;
  signal ovf: std_logic;
  constant period: time:= 50 ns;
begin

  uut: ALU port map ( A       => A,
                      B       => B,
                      OP      => OP,
                      alu_out => alu_out,
                      zero    => zero,
                      cout    => cout,
                      ovf     => ovf 
							 );

  stimulus: process
  begin
  	A <= x"AAAA_FFF0";
  	B <= x"0000_0000";
  	
  	-- check all funcs first
  	-- add
  	OP <= x"0";
  	wait for period;
  	-- sub
	OP <= x"1";
	wait for period;
	-- logic and
	OP <= x"2";
  	wait for period;
  	-- logic or
  	OP <= x"3";
  	wait for period;
  	-- logic not
  	OP <= x"4";
  	wait for period;
  	-- logic nand
  	OP <= x"5";
  	wait for period;
  	-- logic nor
  	OP <= x"6";
  	wait for period;
  	A <= x"FFFF_FFFE";
  	-- sra
  	OP <= x"8";
  	wait for period;
  	-- srl 
  	OP <= x"9";
  	wait for period;
  	-- sll
  	OP <= x"a";
  	wait for period;
  	-- ror
  	OP <= x"c";
  	wait for period;
  	-- rol
  	OP <= x"d";
  	wait for period;
  	
  	
  	-- different sign addition 
  	-- with cout never ovf
  	A <= X"7FFF_FFFF";
  	B <= X"FFFF_FFFF";
  	OP <= x"0";
  	wait for period;
  	-- different sign subtraction
  	-- never ovf, cout
  	
  	A <= X"0A00_0000";
  	B <= X"FFFF_0000";
  	OP <= x"1";
  	wait for period;
  	
  	-- ovf and cout flags
  	
  	-- ovf addition 2(pos)
  	-- 01000000....(pos)
  	-- 01000000....(pos)
  	-- 10000.......(neg)
  	-- ovf, no cout
	A <= X"4000_0000";
	B <= X"4000_0000";
	op <= x"0";
	wait for period;
	-- subtraction 2(negs) 
	-- 10000000....(neg)
	-- 10000000....(neg)
	-- 00000000....(0)
	-- no ovf, no cout -x - (-x) = 0
	A <= X"8000_0000";
	B <= X"8000_0000";
	op <= x"1";
	wait for period;
	-- same but with ovf, and cout this time -x + -x = -2x not 0
	op <= x"0"; 
	wait for period;
	-- plain addition 2(negs)with cout
	-- 10100000.....(neg)
	-- 11100000.....(neg)
	-- 10000000.....(neg)
	A<=x"A000_0000";
	B<=x"E000_0000";
	wait for period;
	
  	wait;
  end process;
  
end architecture;