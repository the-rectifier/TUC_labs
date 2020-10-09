LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY look_ahead_TB IS
END look_ahead_TB;
 
ARCHITECTURE behavior OF look_ahead_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT carry_look_ahead_unit
    PORT(
         Cin : IN  std_logic;
         P : IN  std_logic_vector(3 downto 0);
         G : IN  std_logic_vector(3 downto 0);
         C : OUT  std_logic_vector(2 downto 0);
         C3 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Cin : std_logic := '0';
   signal P : std_logic_vector(3 downto 0) := (others => '0');
   signal G : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal C : std_logic_vector(2 downto 0);
   signal C3 : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: carry_look_ahead_unit PORT MAP (
          Cin => Cin,
          P => P,
          G => G,
          C => C,
          C3 => C3
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 10 ns;	
		P <= X"0";
		G <= X"0";
		Cin <= '0';
		wait for 10 ns;
		P <= X"0";
		G <= X"F";
		Cin <= '0';
		wait for 10 ns;
		P <= X"F";
		G <= X"0";
		Cin <= '1';
		wait for 10 ns;	
		P <= X"A";
		G <= X"5";
		Cin <= '1';
		wait for 10 ns;
		P <= X"3";
		G <= X"1";
		Cin <= '1';
		wait for 10 ns;
		P <= X"F";
		G <= X"F";
		Cin <= '1';
		wait for 10 ns;		
      wait;
   end process;

END;
