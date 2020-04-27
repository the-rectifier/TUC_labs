library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity incrementor is
    Port ( a : in STD_LOGIC_vector(31 downto 0);
           q :out STD_LOGIC_vector(31 downto 0));
end incrementor;

architecture Behavioral of incrementor is

begin
q <= std_logic_vector(unsigned(a) + 4);
end Behavioral;
