library ieee;
use ieee.std_logic_1164.all;

entity carry_propagate_generate_unit is 
PORT (
        A: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        P: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        G: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
     );
END carry_propagate_generate_unit;

ARCHITECTURE model OF carry_propagate_generate_unit IS
BEGIN

P(0)<= A(0) XOR B(0);
P(1)<= A(1) XOR B(1);
P(2)<= A(2) XOR B(2);
P(3)<= A(3) XOR B(3);

G(0)<= A(0) AND B(0);
G(1)<= A(1) AND B(1);
G(2)<= A(2) AND B(2);
G(3)<= A(3) AND B(3);
END model;