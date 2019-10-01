--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:29:28 05/12/2019
-- Design Name:   
-- Module Name:   /home/canopus/TUC/ECE/SEM2/ACE203/lab5/stack//control_TB.vhd
-- Project Name:  stack
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control
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
 
ENTITY control_TB IS
END control_TB;
 
ARCHITECTURE behavior OF control_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         push : IN  std_logic;
         pop : IN  std_logic;
         almost_empty : OUT  std_logic;
         almost_full : OUT  std_logic;
         full : OUT  std_logic;
         empty : OUT  std_logic;
         addra : OUT  std_logic_vector(3 downto 0);
         wen : OUT  std_logic_vector(0 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal push : std_logic := '0';
   signal pop : std_logic := '0';

 	--Outputs
   signal almost_empty : std_logic;
   signal almost_full : std_logic;
   signal full : std_logic;
   signal empty : std_logic;
   signal addra : std_logic_vector(3 downto 0);
   signal wen : std_logic_vector(0 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control PORT MAP (
          clk => clk,
          rst => rst,
          push => push,
          pop => pop,
          almost_empty => almost_empty,
          almost_full => almost_full,
          full => full,
          empty => empty,
          addra => addra,
          wen => wen
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
		--PUSH 12 times
		push <= '1';
		wait for clk_period*24;
		push <= '0';
		--POP 12 times
		pop <= '1';
		wait for clk_period*24;
		pop <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
