LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY lab_1_circuit_1_TB IS
END lab_1_circuit_1_TB;
 
ARCHITECTURE behavior OF lab_1_circuit_1_TB IS   
 
    COMPONENT circ_1
    PORT(
         a : IN  std_logic; --create a component
         b : IN  std_logic;
         c0 : IN  std_logic;
         c1 : IN  std_logic;
         c2 : IN  std_logic;
         c3 : IN  std_logic;
         c4 : IN  std_logic;
         c5 : IN  std_logic;
         res : OUT  std_logic_vector(0 to 5)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c0 : std_logic := '0';
   signal c1 : std_logic := '0';
   signal c2 : std_logic := '0';
   signal c3 : std_logic := '0';
   signal c4 : std_logic := '0';
   signal c5 : std_logic := '0';

 	--Outputs
   signal res : std_logic_vector(0 to 5);


 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circ_1 PORT MAP ( --create a unit and map everything to itself
          a => a,
          b => b,
          c0 => c0,
          c1 => c1,
          c2 => c2,
          c3 => c3,
          c4 => c4,
          c5 => c5,
          res => res
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns; --the c are always 1 to pass the result of a/b 
      a <='0'; --00
      b <='0';
      c0 <= '1';
      c1 <= '1';
            c2 <= '1';
            c3 <= '1';
            c4 <= '1';
            c5 <= '1';
            wait for 100 ns;
            a <='0'; --01
            b <='1';
            c0 <= '1';
            c1 <= '1';
            c2 <= '1';
            c3 <= '1';
            c4 <= '1';
            c5 <= '1';
            wait for 100 ns;
            a <='1'; --10
            b <='0';
            c0 <= '1';
            c1 <= '1';
            c2 <= '1';
            c3 <= '1';
            c4 <= '1';
            c5 <= '1';
            wait for 100 ns;
            a <='1'; --11
            b <='1';
            c0 <= '1';
            c1 <= '1';
            c2 <= '1';
            c3 <= '1';
            c4 <= '1';
            c5 <= '1';
		wait;
      -- insert stimulus here 
   end process;

END;
