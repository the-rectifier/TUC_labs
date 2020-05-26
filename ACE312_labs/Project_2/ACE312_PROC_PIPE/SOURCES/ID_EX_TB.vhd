library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ID_EX_tb is
end;

architecture bench of ID_EX_tb is

  component ID_EX
  	Port(
  		clk : in std_logic;
  		rst : in std_logic;
  		WB_FLAGS_IN : in std_logic_vector(1 downto 0);
  		WB_FLAGS_OUT : out std_logic_vector(1 downto 0);
  		MEM_FLAGS_IN : in std_logic_vector(1 downto 0);
  		MEM_FLAGS_OUT : out std_logic_vector(1 downto 0);
  		ALU_FLAGS_IN : in std_logic_vector(4 downto 0);
  		ALU_Func : out std_logic_vector(3 downto 0);
  		ALU_B_Sel : out std_logic;
  		OP_CODE_IN : in std_logic_vector(5 downto 0);
  		OP_CODE_OUT : out std_logic_vector(5 downto 0);
  		RF_A_IN : in std_logic_vector(31 downto 0);
  		RF_B_IN : in std_logic_vector(31 downto 0);
  		RF_A_OUT : out std_logic_vector(31 downto 0);
  		RF_B_OUT : out std_logic_vector(31 downto 0);
  		IMMED_IN : in std_logic_vector(31 downto 0);
  		IMMED_OUT : out std_logic_vector(31 downto 0);
  		REGS_IN : in std_logic_vector(14 downto 0);
  		RD_OUT : out std_logic_vector(4 downto 0);
  		RS_OUT : out std_logic_vector(4 downto 0);
  		RT_OUT : out std_logic_vector(4 downto 0));
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal WB_FLAGS_IN: std_logic_vector(1 downto 0);
  signal WB_FLAGS_OUT: std_logic_vector(1 downto 0);
  signal MEM_FLAGS_IN: std_logic_vector(1 downto 0);
  signal MEM_FLAGS_OUT: std_logic_vector(1 downto 0);
  signal ALU_FLAGS_IN: std_logic_vector(4 downto 0);
  signal ALU_Func: std_logic_vector(3 downto 0);
  signal ALU_B_Sel: std_logic;
  signal OP_CODE_IN: std_logic_vector(5 downto 0);
  signal OP_CODE_OUT: std_logic_vector(5 downto 0);
  signal RF_A_IN: std_logic_vector(31 downto 0);
  signal RF_B_IN: std_logic_vector(31 downto 0);
  signal RF_A_OUT: std_logic_vector(31 downto 0);
  signal RF_B_OUT: std_logic_vector(31 downto 0);
  signal IMMED_IN: std_logic_vector(31 downto 0);
  signal IMMED_OUT: std_logic_vector(31 downto 0);
  signal REGS_IN: std_logic_vector(14 downto 0);
  signal RD_OUT: std_logic_vector(4 downto 0);
  signal RS_OUT: std_logic_vector(4 downto 0);
  signal RT_OUT: std_logic_vector(4 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: ID_EX port map ( clk           => clk,
                        rst           => rst,
                        WB_FLAGS_IN   => WB_FLAGS_IN,
                        WB_FLAGS_OUT  => WB_FLAGS_OUT,
                        MEM_FLAGS_IN  => MEM_FLAGS_IN,
                        MEM_FLAGS_OUT => MEM_FLAGS_OUT,
                        ALU_FLAGS_IN  => ALU_FLAGS_IN,
                        ALU_Func      => ALU_Func,
                        ALU_B_Sel     => ALU_B_Sel,
                        OP_CODE_IN    => OP_CODE_IN,
                        OP_CODE_OUT   => OP_CODE_OUT,
                        RF_A_IN       => RF_A_IN,
                        RF_B_IN       => RF_B_IN,
                        RF_A_OUT      => RF_A_OUT,
                        RF_B_OUT      => RF_B_OUT,
                        IMMED_IN      => IMMED_IN,
                        IMMED_OUT     => IMMED_OUT,
                        REGS_IN       => REGS_IN,
                        RD_OUT        => RD_OUT,
                        RS_OUT        => RS_OUT,
                        RT_OUT        => RT_OUT );

  stimulus: process
  begin
  
    rst <= '0';
    wait for clock_period;
    rst <= '1';

	WB_FLAGS_IN <= "11";
	MEM_FLAGS_IN <= "11";
	ALU_FLAGS_IN <= "10110";
	OP_CODE_IN <= "111000";
	RF_A_IN <= X"AAAA_BBBC";
	RF_B_IN <= X"AAAA_BBBD";
	Immed_IN <= X"AAAA_BBBE";
	
	REGS_IN <= B"01010_11111_00010";
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