LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FSM_TB IS
END FSM_TB;
 
ARCHITECTURE behavior OF FSM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSM
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         a : IN  std_logic;
         b : IN  std_logic;
         control : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal a : std_logic := '0';
   signal b : std_logic := '0';

 	--Outputs
   signal control : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSM PORT MAP (
          clk => clk,
          rst => rst,
          a => a,
          b => b,
          control => control
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
      wait for 100 ns;	
	  --reset
	  rst <='1';
      wait for clk_period*10;
	  rst<='0'; -- state 0
	  --forward
	  wait for clk_period;
	  a<='1';
	  b<='0';
	  wait for clk_period; -- state 1
	  a<='1';
	  b<='1';
	  wait for clk_period;
	  a<='0';
	  b<='0';
	  wait for clk_period;
	  a<='1';
	  b<='0';
	  wait for clk_period; -- state 2
	  a<='1';
	  b<='1';
	  wait for clk_period;
	  a<='0';
	  b<='0';
	  wait for clk_period;
	  a<='1';
	  b<='0';
	  wait for clk_period; -- state 3
	  a<='1';
	  b<='1';
	  wait for clk_period;
	  a<='0';
	  b<='0';
	  wait for clk_period;
	  a<='1';
	  b<='0';
	  wait for clk_period; -- state 4
	  a<='1';
	  b<='1';
	  wait for clk_period;
	  a<='0';
	  b<='0';
	  wait for clk_period;
	  a<='1';
	  b<='0';
	  wait for clk_period; -- state 0 again
	  -- now backwards
	  a<='0';
	  b<='1';
	  wait for clk_period*7; -- state 4
	  rst<='1';
	  wait for clk_period;
	  rst<='0';
	  a<='1';
	  b<='1';
      wait;
   end process;

END;
