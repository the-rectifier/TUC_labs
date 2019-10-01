library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is -- create an entity with required inputs and outputs
	port(
	x : in std_logic;
	y : in std_logic;
	sum_h : out std_logic;
	cout_h : out std_logic
	);
end half_adder;

architecture Behavioral of half_adder is --create the arch with the required equations

begin
sum_h <= x xor y;
cout_h <= x and y;
end Behavioral;