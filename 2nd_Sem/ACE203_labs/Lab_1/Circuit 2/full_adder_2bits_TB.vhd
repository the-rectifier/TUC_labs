LIBRARY ieee;
USE ieee.std_logic_1164.ALL; --library declaration
 
ENTITY full_adder_2bits_TB IS
END full_adder_2bits_TB; --empty entity
 
ARCHITECTURE behavior OF full_adder_2bits_TB IS  --create an arch for testing
    COMPONENT full_adder_2bits --create a component instead of an entity 
    PORT(
         a : IN  std_logic_vector(1 downto 0);
         b : IN  std_logic_vector(1 downto 0);
         cin : IN  std_logic;
         sum : OUT  std_logic_vector(1 downto 0);
         cout : OUT  std_logic
        );
    END COMPONENT;
   --Inputs
   signal a : std_logic_vector(1 downto 0) := (others => '0'); --declare all neccessary signals and init all inputs to 0 
   signal b : std_logic_vector(1 downto 0) := (others => '0');
   signal cin : std_logic := '0';
 	--Outputs
   signal sum : std_logic_vector(1 downto 0);
   signal cout : std_logic;
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder_2bits PORT MAP ( 
          a => a, --map everything to itself
          b => b,
          cin => cin,
          sum => sum,
          cout => cout
        );

   -- Stimulus process
   stim_proc: process
   begin		--set the stimulus for every state and wait for the response
-- a1 a0 b1 b0 cin
-- MSB---------LSB
--state: 00000
a(1) <= '0';
a(0) <= '0';
b(1) <= '0';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 00001
a(1) <= '0';
a(0) <= '0';
b(1) <= '0';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 00010
a(1) <= '0';
a(0) <= '0';
b(1) <= '0';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 00011
a(1) <= '0';
a(0) <= '0';
b(1) <= '0';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 00100
a(1) <= '0';
a(0) <= '0';
b(1) <= '1';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 00101
a(1) <= '0';
a(0) <= '0';
b(1) <= '1';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 00110
a(1) <= '0';
a(0) <= '0';
b(1) <= '1';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 00111
a(1) <= '0';
a(0) <= '0';
b(1) <= '1';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 01000
a(1) <= '0';
a(0) <= '1';
b(1) <= '0';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 01001
a(1) <= '0';
a(0) <= '1';
b(1) <= '0';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 01010
a(1) <= '0';
a(0) <= '1';
b(1) <= '0';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 01011
a(1) <= '0';
a(0) <= '1';
b(1) <= '0';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 01100
a(1) <= '0';
a(0) <= '1';
b(1) <= '1';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 01101
a(1) <= '0';
a(0) <= '1';
b(1) <= '1';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 01110
a(1) <= '0';
a(0) <= '1';
b(1) <= '1';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 01111
a(1) <= '0';
a(0) <= '1';
b(1) <= '1';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 10000
a(1) <= '1';
a(0) <= '0';
b(1) <= '0';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 10001
a(1) <= '1';
a(0) <= '0';
b(1) <= '0';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 10010
a(1) <= '1';
a(0) <= '0';
b(1) <= '0';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 10011
a(1) <= '1';
a(0) <= '0';
b(1) <= '0';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 10100
a(1) <= '1';
a(0) <= '0';
b(1) <= '1';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 10101
a(1) <= '1';
a(0) <= '0';
b(1) <= '1';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 10110
a(1) <= '1';
a(0) <= '0';
b(1) <= '1';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 10111
a(1) <= '1';
a(0) <= '0';
b(1) <= '1';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 11000
a(1) <= '1';
a(0) <= '1';
b(1) <= '0';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 11001
a(1) <= '1';
a(0) <= '1';
b(1) <= '0';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 11010
a(1) <= '1';
a(0) <= '1';
b(1) <= '0';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 11011
a(1) <= '1';
a(0) <= '1';
b(1) <= '0';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
--state: 11100
a(1) <= '1';
a(0) <= '1';
b(1) <= '1';
b(0) <= '0';
cin <= '0';
wait for 25 ns;
--state: 11101
a(1) <= '1';
a(0) <= '1';
b(1) <= '1';
b(0) <= '0';
cin <= '1';
wait for 25 ns;
--state: 11110
a(1) <= '1';
a(0) <= '1';
b(1) <= '1';
b(0) <= '1';
cin <= '0';
wait for 25 ns;
--state: 11111
a(1) <= '1';
a(0) <= '1';
b(1) <= '1';
b(0) <= '1';
cin <= '1';
wait for 25 ns;
wait;
end process;

END;
