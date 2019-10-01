library ieee;
use ieee.std_logic_1164.all;

ENTITY carry_look_ahead_unit IS
     PORT(
           Cin: IN  STD_LOGIC;
           P:   IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           G:   IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           C:   OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
           C3:  OUT STD_LOGIC
         );
END carry_look_ahead_unit;


ARCHITECTURE model OF carry_look_ahead_unit IS
BEGIN
C(0)<= G(0) OR (P(0) AND Cin);
C(1)<= G(1) OR (P(1) AND G(0)) OR (P(1) AND P(0) AND Cin);
C(2)<= G(2) OR (P(2) AND G(1)) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND P(1) AND P(0) AND Cin);
C3	<= G(3) OR (P(3) AND G(2)) OR (P(3) AND P(2) AND G(1)) OR (P(3) AND P(2) AND P(1) AND G(0)) OR (P(3)AND P(2) AND P(1) AND P(0) AND Cin);
END model;