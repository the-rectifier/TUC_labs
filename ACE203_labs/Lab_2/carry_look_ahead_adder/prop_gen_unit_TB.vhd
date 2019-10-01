LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY prop_gen_unit_TB IS
END prop_gen_unit_TB;
 
ARCHITECTURE behavior OF prop_gen_unit_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT carry_propagate_generate_unit
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         P : OUT  std_logic_vector(3 downto 0);
         G : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal P : std_logic_vector(3 downto 0);
   signal G : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: carry_propagate_generate_unit PORT MAP (
          A => A,
          B => B,
          P => P,
          G => G
        );
	-- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 10 ns;	
		A <= X"0"; --A(0000)
		B <= X"0"; --B(0000)
		wait for 10 ns;
		A <= X"F"; --A(1111)
		B <= X"0"; --B(0000)
		wait for 10 ns;
		A <= X"F"; --A(1111)
		B <= X"F"; --B(1111)
      -- insert stimulus here 

      wait;
   end process;

END;
