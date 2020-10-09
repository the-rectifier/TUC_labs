LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY full_adder_TB IS
END full_adder_TB;
 
ARCHITECTURE behavior OF full_adder_TB IS  --create an arch
    COMPONENT full_adder --declare a component and neccessary signals
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         cin : IN  std_logic;
         sum : OUT  std_logic;
         cout : OUT  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal a : std_logic := '0'; --init all inputs to 0 
   signal b : std_logic := '0';
   signal cin : std_logic := '0';

 	--Outputs
   signal sum : std_logic;
   signal cout : std_logic;
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder PORT MAP ( --map everything to itself
          a => a,
          b => b,
          cin => cin,
          sum => sum,
          cout => cout
        );
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		a <= '0'; --000
		b <= '0';
		cin <= '0';
		wait for 100 ns;	
		a <= '0'; --001
		b <= '0';
		cin <= '1';
		wait for 100 ns;	
		a <= '0'; --010
		b <= '1';
		cin <= '0';
		wait for 100 ns;	
		a <= '0'; --011
		b <= '1';
		cin <= '1';
		wait for 100 ns;	
		a <= '1'; --100
		b <= '0';
		cin <= '0';
		wait for 100 ns;	
		a <= '1'; --101
		b <= '0';
		cin <= '1';
		wait for 100 ns;	
		a <= '1'; --110
		b <= '1';
		cin <= '0';
		wait for 100 ns;	
		a <= '1'; --111
		b <= '1';
		cin <= '1';
      wait;
   end process;

END;
