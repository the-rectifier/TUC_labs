library ieee;
use ieee.std_logic_1164.all;

ENTITY sum_Unit IS 
     PORT (
             P:  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
             C:  IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
             Cin:IN  STD_LOGIC;
             S:  OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
          );
          
END sum_Unit;

ARCHITECTURE model OF sum_Unit IS

BEGIN 
S(0)<= P(0) XOR Cin;
S(1)<= P(1) XOR C(0);
S(2)<= P(2) XOR C(1);
S(3)<= P(3) XOR C(2);
END model;         