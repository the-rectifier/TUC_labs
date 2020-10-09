LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
 
ENTITY Display_TB IS
END Display_TB;
 
ARCHITECTURE behavior OF Display_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Display
    PORT(
         clk : IN  std_logic;
         APoints : IN  std_logic_vector(3 downto 0);
         Bpoints : IN  std_logic_vector(3 downto 0);
         winner : IN  std_logic_vector(1 downto 0);
         gamemode : IN  std_logic;
         en : IN  std_logic_vector(1 downto 0);
         An : OUT  std_logic_vector(3 downto 0);
         CA : OUT  std_logic;
         CB : OUT  std_logic;
         CC : OUT  std_logic;
         CD : OUT  std_logic;
         CE : OUT  std_logic;
         CF : OUT  std_logic;
         CG : OUT  std_logic;
         DP : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal APoints : std_logic_vector(3 downto 0) := (others => '0');
   signal Bpoints : std_logic_vector(3 downto 0) := (others => '0');
   signal winner : std_logic_vector(1 downto 0) := (others => '0');
   signal gamemode : std_logic := '0';
   signal en : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal An : std_logic_vector(3 downto 0);
   signal CA : std_logic;
   signal CB : std_logic;
   signal CC : std_logic;
   signal CD : std_logic;
   signal CE : std_logic;
   signal CF : std_logic;
   signal CG : std_logic;
   signal DP : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Display PORT MAP (
          clk => clk,
          APoints => APoints,
          Bpoints => Bpoints,
          winner => winner,
          gamemode => gamemode,
          en => en,
          An => An,
          CA => CA,
          CB => CB,
          CC => CC,
          CD => CD,
          CE => CE,
          CF => CF,
          CG => CG,
          DP => DP
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

      winner <= B"11";
      Apoints <= X"4";
      wait for clk_period;
      en <= B"00";
      wait for clk_period;
      Apoints <= X"C";
      wait for clk_period;
      en <= B"01";
      wait for clk_period;
      Bpoints <= X"5";
      wait for clk_period;
      en <= B"10";
      wait for clk_period;
      Bpoints <= X"B";
      wait for clk_period;
      en <= B"11";
      wait for clk_period;

      wait;
   end process;

END;
