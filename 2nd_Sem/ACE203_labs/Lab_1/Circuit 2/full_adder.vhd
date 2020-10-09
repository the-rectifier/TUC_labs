-- TUC_ACE203_LAB_1_CIRCUIT_2
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is -- create an entity with required inputs and outputs
    Port( 
		a : in  STD_LOGIC;
		b : in  STD_LOGIC;
		cin : in  STD_LOGIC;
      sum : out  STD_LOGIC;
      cout : out  STD_LOGIC
		);
end full_adder;

architecture Behavioral of full_adder is 
signal half_sum : std_logic;
signal half_carry : std_logic;
signal half_carry_2: std_logic;
--we need 3 extra signals for the in-between connections of 2 half adders
component half_adder is --declare a component named half_adder located in another module
	port(
		x : in std_logic;
		y : in std_logic;
		sum_h : out std_logic;
		cout_h : out std_logic
		);
end component;
begin
	FA1: half_adder port map --map the components inputs-outputs to the entity + signals
	(
		x => a,
		y => b,
		sum_h => half_sum,
		cout_h => half_carry
	);
	FA2: half_adder port map
	(	
		x => half_sum,
		y => cin,
		sum_h => sum,
		cout_h => half_carry_2
	);
	cout <= half_carry_2 or half_carry;
end Behavioral;