--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:12:50 05/13/2019
-- Design Name:   
-- Module Name:   /home/canopus/TUC/ECE/SEM2/ACE203/lab5/memory/memory_TB.vhd
-- Project Name:  memory
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memory
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memory_TB IS
END memory_TB;
 
ARCHITECTURE behavior OF memory_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory
    PORT(
         push : IN  std_logic;
         pop : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_in : IN  std_logic_vector(3 downto 0);
         data_out : OUT  std_logic_vector(3 downto 0);
         full : OUT  std_logic;
         empty : OUT  std_logic;
         almost_empty : OUT  std_logic;
         almost_full : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal push : std_logic := '0';
   signal pop : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic_vector(3 downto 0);
   signal full : std_logic;
   signal empty : std_logic;
   signal almost_empty : std_logic;
   signal almost_full : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory PORT MAP (
          push => push,
          pop => pop,
          clk => clk,
          rst => rst,
          data_in => data_in,
          data_out => data_out,
          full => full,
          empty => empty,
          almost_empty => almost_empty,
          almost_full => almost_full
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
		wait for clk_period;
		rst <= '0';
		wait for clk_period;

		data_in <= X"F";
		push <='1';
		wait for clk_period*3;
		data_in <= X"A";
		wait for clk_period*2;
		data_in <= X"B";
		wait for clk_period*2;
		data_in <= X"5";
		wait for clk_period*2;
		data_in <= X"C";
		wait for clk_period*30;
		push <='0';
		wait for clk_period;
		
		--we're popping
		pop <= '1';
		wait for clk_period * 30;
		pop <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
