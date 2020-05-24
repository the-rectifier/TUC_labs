library ieee;
use ieee.std_logic_1164.all;

entity mux_2_1_5bit is
    Port ( sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (4 downto 0);
           b : in STD_LOGIC_VECTOR (4 downto 0);
           q : out STD_LOGIC_VECTOR (4 downto 0));
end mux_2_1_5bit;

architecture Behavioral of mux_2_1_5bit is

begin
	q <= a when sel = '0' else b;
end Behavioral;