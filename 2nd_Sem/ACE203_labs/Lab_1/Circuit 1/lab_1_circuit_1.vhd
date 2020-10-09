
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity circ_1 is --create an entity containing all inputs/outputs
	port(
	a : in std_logic;
	b : in std_logic;
	c0: in std_logic;
	c1: in std_logic;
	c2: in std_logic;
	c3: in std_logic;
	c4: in std_logic;
	c5: in std_logic;
	res: out std_logic_vector(0 TO 5)
	);
end circ_1;

architecture function_1 of circ_1 is

begin
	res(0) <= (a nand b) and c0; --needed equations using the in/outs of the entity
	res(1) <= (a nor b) and c1;
	res(2) <= (a and b) and c2;
	res(3) <= (a xor b) and c3;
	res(4) <= ((a and b) or (NOT a and NOT b)) and c4;
	res(5) <= ((NOT a and b) xor (NOT a or b)) and c5;
end function_1;

