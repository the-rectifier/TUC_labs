LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY sum_TB IS
END sum_TB;
 
ARCHITECTURE behavior OF sum_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sum_Unit
    PORT(
         P : IN  std_logic_vector(3 downto 0);
         C : IN  std_logic_vector(2 downto 0);
         Cin : IN  std_logic;
         S : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal P : std_logic_vector(3 downto 0) := (others => '0');
   signal C : std_logic_vector(2 downto 0) := (others => '0');
   signal Cin : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sum_Unit PORT MAP (
          P => P,
          C => C,
          Cin => Cin,
          S => S
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 10 ns;	
		P <= X"0";
		C <= B"000";
		Cin <= '0';
		wait for 10 ns;
		P <= X"F";
		C <= B"000";
		Cin <= '0';
		wait for 10 ns;
		P <= X"F";
		C <= B"111";
		Cin <= '1';
		wait for 10 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
