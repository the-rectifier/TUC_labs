LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY court_TB IS
END court_TB;
 
ARCHITECTURE behavior OF court_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT court
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         shift : IN  std_logic;
         hit_a : IN  std_logic;
         hit_b : IN  std_logic;
         serv : IN  std_logic;
         pos : OUT  std_logic_vector(1 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         gamemode : IN  std_logic;
         winner : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal shift : std_logic := '0';
   signal hit_a : std_logic := '0';
   signal hit_b : std_logic := '0';
   signal serv : std_logic := '0';
   signal gamemode : std_logic := '0';
   signal winner : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal pos : std_logic_vector(1 downto 0);
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: court PORT MAP (
          clk => clk,
          rst => rst,
          shift => shift,
          hit_a => hit_a,
          hit_b => hit_b,
          serv => serv,
          pos => pos,
          led => led,
          gamemode => gamemode,
          winner => winner
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
      winner <= B"11";
      wait for clk_period;

      hit_a <= '1';
      wait for clk_period;
      hit_a <= '0';
      wait for clk_period;

      shift <= '1'; --1
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; --2
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --3
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --4
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --5
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; -- 6
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; --7
      wait for clk_period;
      shift <= '0';
      wait for clk_period;

      hit_b <= '1';
      wait for clk_period;
      hit_b <= '0';
      wait for clk_period;

      shift <= '1'; --1
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; --2
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --3
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --4
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --5
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; -- 6
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; --7
      wait for clk_period;
      shift <= '0';
      wait for clk_period;

      
      hit_a <= '1';
      wait for clk_period;
      hit_a <= '0';
      wait for clk_period;

      shift <= '1'; --4
      wait for clk_period;
      shift <= '0'; 
      wait for clk_period;
      shift <= '1'; --5
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; -- 6
      wait for clk_period;
      shift <= '0';
      wait for clk_period;
      shift <= '1'; --7
      wait for clk_period;
      shift <= '0';
      wait for clk_period;

      serv <= '1';
      wait for clk_period;
      serv <= '0';
      wait for clk_period;

      serv <= '1';
      wait for clk_period;
      serv <= '0';
      wait for clk_period;

      winner <= "10";

      wait;
   end process;

END;
