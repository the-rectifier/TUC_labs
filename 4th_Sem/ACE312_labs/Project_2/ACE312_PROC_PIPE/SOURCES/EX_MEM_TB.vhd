library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity EX_MEM_tb is
end;

architecture bench of EX_MEM_tb is

  component EX_MEM
  	Port ( 
  		clk : in std_logic;
  		rst : in std_logic;
  		WB_flags_in : in std_logic_vector(1 downto 0);
  		WB_flags_out : out std_logic_vector(1 downto 0);
  		MEM_flags_in : in std_logic_vector(1 downto 0);
  		MEM_WE : out std_logic;
  		ByteOP : out std_logic;
  		ALU_z_in : in std_logic;
  		ALU_z_out : out std_logic;
  		ALU_OUT_in : in std_logic_vector(31 downto 0);
  		ALU_OUT_out : out std_logic_vector(31 downto 0);
  		DATA_in : in std_logic_vector(31 downto 0);
  		DATA_out : out std_logic_vector(31 downto 0);
  		RD_IN : in std_logic_vector(4 downto 0);
  		RD_OUT : out std_logic_vector(4 downto 0));
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal WB_flags_in: std_logic_vector(1 downto 0);
  signal WB_flags_out: std_logic_vector(1 downto 0);
  signal MEM_flags_in: std_logic_vector(1 downto 0);
  signal MEM_WE: std_logic;
  signal ByteOP: std_logic;
  signal ALU_z_in: std_logic;
  signal ALU_z_out: std_logic;
  signal ALU_OUT_in: std_logic_vector(31 downto 0);
  signal ALU_OUT_out: std_logic_vector(31 downto 0);
  signal DATA_in: std_logic_vector(31 downto 0);
  signal DATA_out: std_logic_vector(31 downto 0);
  signal RD_IN: std_logic_vector(4 downto 0);
  signal RD_OUT: std_logic_vector(4 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: EX_MEM port map ( clk          => clk,
                         rst          => rst,
                         WB_flags_in  => WB_flags_in,
                         WB_flags_out => WB_flags_out,
                         MEM_flags_in => MEM_flags_in,
                         MEM_WE       => MEM_WE,
                         ByteOP       => ByteOP,
                         ALU_z_in     => ALU_z_in,
                         ALU_z_out    => ALU_z_out,
                         ALU_OUT_in   => ALU_OUT_in,
                         ALU_OUT_out  => ALU_OUT_out,
                         DATA_in      => DATA_in,
                         DATA_out     => DATA_out,
                         RD_IN        => RD_IN,
                         RD_OUT       => RD_OUT );

  stimulus: process
  begin
  
  	rst <= '0';
  	wait for clock_period;
  	rst <= '1';
    WB_FLAGS_IN <= "11";
	MEM_FLAGS_IN <= "11";
	ALU_Z_IN <= '0';
	ALU_OUT_IN <= X"0000_FAFA";
	DATA_IN <= X"0000_FAFA";
	RD_IN <= "00101";
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