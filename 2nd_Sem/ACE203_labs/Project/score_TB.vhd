LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY score_TB IS
END score_TB;
 
ARCHITECTURE behavior OF score_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT score
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         PntA : IN  std_logic;
         PntB : IN  std_logic;
         GameMode : IN  std_logic;
         Apoints : OUT  std_logic_vector(3 downto 0);
         Bpoints : OUT  std_logic_vector(3 downto 0);
         winner : OUT  std_logic_vector(1 downto 0);
         gear0 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal PntA : std_logic := '0';
   signal PntB : std_logic := '0';
   signal GameMode : std_logic := '0';

 	--Outputs
   signal Apoints : std_logic_vector(3 downto 0);
   signal Bpoints : std_logic_vector(3 downto 0);
   signal winner : std_logic_vector(1 downto 0);
   signal gear0 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: score PORT MAP (
          CLK => CLK,
          RST => RST,
          PntA => PntA,
          PntB => PntB,
          GameMode => GameMode,
          Apoints => Apoints,
          Bpoints => Bpoints,
          winner => winner,
          gear0 => gear0
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for clk_period*10;
      rst <= '0';
      wait for clk_period;

      PntA <= '1'; --A1
      wait for clk_period;
      PntA <= '0';
      wait for clk_period;
      PntA <= '1'; --A2
      wait for clk_period;
      PntA <= '0';
      wait for clk_period;
      PntA <= '1'; --A3
      wait for clk_period;
      PntA <= '0';
      wait for clk_period;
      PntB <= '1'; --B1
      wait for clk_period;
      PntB <= '0';
      wait for clk_period;
      PntA <= '1'; 
      wait for clk_period*12;
      PntA <= '0';
      wait for clk_period;

      gamemode <= '1';
      wait for clk_period;
      PntA <= '1';
      wait for clk_period*5;
      PntA <= '0';
      wait for clk_period;
      PntB <= '1';
      wait for clk_period;
      PntB <= '0';
      wait for clk_period;

      wait;
   end process;

END;
