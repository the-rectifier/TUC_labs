library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_3_1 is
    Port ( sel: in std_logic_vector(1 downto 0);
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : in std_logic_vector(31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end mux_3_1;

architecture Behavioral of mux_3_1 is
begin
	q <= a when sel = "00" else
		b when sel = "01" else
		c when sel = "10" else
		a;	
end Behavioral;