library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

 
ENTITY strange_counter_TB IS
END strange_counter_TB;
 
ARCHITECTURE behavior OF strange_counter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT strange_counter
    PORT(
         clk : IN  std_logic;
         control : IN  std_logic_vector(2 downto 0);
         rst : IN  std_logic;
         count : OUT  std_logic_vector(7 downto 0);
         valid : OUT  std_logic;
         ovf : OUT  std_logic;
         unf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal control : std_logic_vector(2 downto 0) := (others => '0');
   signal rst : std_logic := '0';

 	--Outputs
   signal count : std_logic_vector(7 downto 0);
   signal valid : std_logic;
   signal ovf : std_logic;
   signal unf : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: strange_counter PORT MAP (
          clk => clk,
          control => control,
          rst => rst,
          count => count,
          valid => valid,
          ovf => ovf,
          unf => unf
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
		rst<='1';
		wait for clk_period*10; -- reset for 10 clocks
		rst<='0';
		-- start counting for all possible controls
		control<=B"111"; -- add 12
		wait for clk_period; -- sum 12
		control<=B"110"; -- add 6
		wait for clk_period; -- sum 18
		control<=B"101"; -- add 5
		wait for clk_period; -- sum 23
		control<=B"100"; -- add 2
		wait for clk_period; -- sum 25
		control<=B"011"; -- add 1 
		wait for clk_period; -- sum 26
		control<=B"010"; -- freeze
		wait for clk_period; -- sum 26
		control<=B"001"; -- sub 2
		wait for clk_period; -- sum 24
		control<=B"000"; -- sub 5
		wait for clk_period; -- sum 19
		-- counted for every control state
		wait for clk_period * 5; -- underflow
		rst<='1'; -- hit the reset
		wait for clk_period;
		rst<='0'; 
		control<=B"010"; 
		-- test the overflow
		wait for clk_period;
		control<=B"111";
		wait for clk_period * 25;
		rst<='1'; -- hit the reset
		wait for clk_period;
		rst<='0';
		control<=B"010";
      wait; 
   end process;

END;
