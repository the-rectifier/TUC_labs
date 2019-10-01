LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Strikes_TB IS
END Strikes_TB;
 
ARCHITECTURE behavior OF Strikes_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STRIKES_fsm
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Strike1 : IN  std_logic;
         Strike2 : IN  std_logic;
         pos : IN  std_logic_vector(1 downto 0);
         gamemode : IN  std_logic;
         gearup : OUT  std_logic;
         HitA : OUT  std_logic;
         HitB : OUT  std_logic;
         PntA : OUT  std_logic;
         PntB : OUT  std_logic;
         serv : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Strike1 : std_logic := '0';
   signal Strike2 : std_logic := '0';
   signal pos : std_logic_vector(1 downto 0) := (others => '0');
   signal gamemode : std_logic := '0';

 	--Outputs
   signal gearup : std_logic;
   signal HitA : std_logic;
   signal HitB : std_logic;
   signal PntA : std_logic;
   signal PntB : std_logic;
   signal serv : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STRIKES_fsm PORT MAP (
          clk => clk,
          rst => rst,
          Strike1 => Strike1,
          Strike2 => Strike2,
          pos => pos,
          gamemode => gamemode,
          gearup => gearup,
          HitA => HitA,
          HitB => HitB,
          PntA => PntA,
          PntB => PntB,
          serv => serv
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
      wait for clk_period;

      pos <= B"10"; -- 1st service
      wait for clk_period;

      Strike1 <= '1';
      wait for clk_period;
      Strike1 <= '0';
      wait for clk_period;
      
      pos <= B"00";
      wait for clk_period;

      pos <= B"01";
      wait for clk_period;

      Strike2 <= '1';
      wait for clk_period;
      Strike2 <= '0';
      wait for clk_period;

      rst <= '1';
      wait for clk_period*10;
      rst <= '0';
      wait for clk_period;

      pos <= B"10"; -- 1st service
      wait for clk_period;

      Strike1 <= '1';
      wait for clk_period;
      Strike1 <= '0';
      wait for clk_period;

      pos <= B"00";
      wait for clk_period*5;

      Strike1 <= '1';
      wait for clk_period;
      Strike1 <= '0';
      wait for clk_period;

      rst <= '1';
      pos <= B"10";
      wait for clk_period*10;
      rst <= '0';
      wait for clk_period;
      
      gamemode <= '1'; -- practice
      Strike1 <= '1';
      wait for clk_period;
      Strike1 <= '0';
      wait for clk_period;

      pos <= B"00";
      wait for clk_period;
      pos <= B"01";
      wait for clk_period;

      pos <= B"00";
      Strike1 <= '1';
      wait for clk_period;
      Strike1 <= '0';
      wait for clk_period;
      

      wait;
   end process;

END;
