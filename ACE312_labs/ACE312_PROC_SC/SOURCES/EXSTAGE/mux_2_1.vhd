library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_1 is
    Port ( sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end mux_2_1;

architecture Behavioral of mux_2_1 is

begin
	q <= a when sel = '0' else b;
end Behavioral;
