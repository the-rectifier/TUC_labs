LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timer_TB IS
END timer_TB;
 
ARCHITECTURE behavior OF timer_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         gear0 : IN  std_logic;
         gearup : IN  std_logic;
         shift : OUT  std_logic;
         plex : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal gear0 : std_logic := '0';
   signal gearup : std_logic := '0';

 	--Outputs
   signal shift : std_logic;
   signal plex : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer PORT MAP (
          clk => clk,
          rst => rst,
          gear0 => gear0,
          gearup => gearup,
          shift => shift,
          plex => plex
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for clk_period*10;
      rst <= '0';
      wait for clk_period; 

      gearup <= '1'; -- g0 -> g1
      wait for clk_period;
      gearup <= '0';
      wait for clk_period;
      gearup <= '1'; -- g1 -> g2
      wait for clk_period;
      gearup <= '0';
      wait for clk_period;
      gearup <= '1'; -- g2
      wait for clk_period;
      gearup <= '0';
      wait for clk_period;
      
      gear0 <= '1'; -- g* -> g0
      wait for clk_period;
      gear0 <= '0';
      wait for clk_period;
      
      wait;
   end process;

END;
