LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY half_adder_TB IS
END half_adder_TB;
 
ARCHITECTURE behavior OF half_adder_TB IS  --create  arch
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT half_adder -- create the component
    PORT(
         x : IN  std_logic;
         y : IN  std_logic;
         sum_h : OUT  std_logic;
         cout_h : OUT  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal x : std_logic := '0'; --init all input signals as 0
   signal y : std_logic := '0';

 	--Outputs
   signal sum_h : std_logic;
   signal cout_h : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: half_adder PORT MAP ( --map everything to itself
          x => x,
          y => y,
          sum_h => sum_h,
          cout_h => cout_h
        );
 

   -- Stimulus process
   stim_proc: process --send the stimulus and wait for the response 
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		 x <= '0'; -- 00
		 y <= '0';
      wait for 100 ns;	
		 x <= '0'; -- 01
		 y <= '1';
      wait for 100 ns;	
		 x <= '1'; -- 10
		 y <= '0';
      wait for 100 ns;	
		 x <= '1'; -- 11
		 y <= '1';
		wait for 100 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
