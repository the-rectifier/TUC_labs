library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DECODE_tb is
end;

architecture bench of DECODE_tb is

  component DECSTAGE
  	Port (
  		Clk : in std_logic;
  		Rst : in std_logic;
  		Instr : in std_logic_vector(31 downto 0);
  		RF_WE : in std_logic;
  		ALU_OUT : in std_logic_vector(31 downto 0);
  		MEM_OUT : in std_logic_vector(31 downto 0);
  		RF_WD_Sel : in std_logic;
  		RF_B_Sel  : in std_logic;
  		ImmExt : in std_logic_vector(1 downto 0);
  		Immed  : out std_logic_vector(31 downto 0);
  		RF_A : out std_logic_vector(31 downto 0);
  		RF_B : out std_logic_vector(31 downto 0));
  end component;

  signal Clk: std_logic;
  signal Rst: std_logic;
  signal Instr: std_logic_vector(31 downto 0);
  signal RF_WE: std_logic;
  signal ALU_OUT: std_logic_vector(31 downto 0);
  signal MEM_OUT: std_logic_vector(31 downto 0);
  signal RF_WD_Sel: std_logic;
  signal RF_B_Sel: std_logic;
  signal ImmExt: std_logic_vector(1 downto 0);
  signal Immed: std_logic_vector(31 downto 0);
  signal RF_A: std_logic_vector(31 downto 0);
  signal RF_B: std_logic_vector(31 downto 0);
  constant clk_period : time := 100 ns;
  signal stop_the_clock : boolean := False; 
begin

  uut: DECSTAGE port map ( Clk       => Clk,
                         Rst       => Rst,
                         Instr     => Instr,
                         RF_WE     => RF_WE,
                         ALU_OUT   => ALU_OUT,
                         MEM_OUT   => MEM_OUT,
                         RF_WD_Sel => RF_WD_Sel,
                         RF_B_Sel  => RF_B_Sel,
                         ImmExt    => ImmExt,
                         Immed     => Immed,
                         RF_A      => RF_A,
                         RF_B      => RF_B );

  stimulus: process
  begin
  	
  	ALU_OUT <= X"AAAA_FFFF"; --stuff from alu
    MEM_OUT <= X"0000_DDDD"; --stuff from mem
  	RF_WE <= '0';
  	RF_B_Sel <= '0';
  	RF_WD_Sel <= '0';
  	ImmExt <= "00";
  	
  	rst <= '0';
  	wait for clk_period;
  	rst <= '1';
  	wait for clk_period;
  	
  	-- li r1, 0xa
  	-- not exact values from alu!
  	Instr <= x"e001000a";
  	-- SignExtend immediate
  	ImmExt <= "00";
  	-- Write to register
  	RF_WE <= '1';
  	-- Write from ALU
  	RF_WD_Sel <= '0';
  	-- Dont care bout the 2nd register
  	-- but use it as the RD so we check the output
  	RF_B_Sel <= '1';
  	wait for clk_period;
  	-- this time write from MEM
  	RF_WD_Sel <= '1';
  	wait for clk_period;
  	RF_WD_Sel <= '0';
  	Instr <= x"e001800a";
  	-- Sign Ext << 2
  	ImmExt <= "01";
  	wait for clk_period;
  	-- Zfill
  	ImmExt <= "10";
  	wait for clk_period;
  	-- Zfill << 16
  	ImmExt <= "11";
  	wait for clk_period;
  	-- The 2 multiplexers work as intended 
  	-- The WE works
  	-- The extender functions correctly
  	-- Lastly check the rd, rs, rt case
  	-- if it gets decoded correctly
  	Instr <= x"80440830";
  	--	add r4, r2, r1
	wait for clk_period;
	stop_the_clock <= True;
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