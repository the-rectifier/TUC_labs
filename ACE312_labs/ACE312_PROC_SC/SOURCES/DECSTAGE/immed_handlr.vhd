library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity immed_handlr is
    Port(  immed : in STD_LOGIC_vector(15 downto 0);
           output : out STD_LOGIC_vector(31 downto 0);
           func : in std_logic_vector(1 downto 0));
end immed_handlr;

architecture Behavioral of immed_handlr is
begin
	--Sign Extention
	output <= std_logic_vector(resize(signed(immed), output'length)) when func = "00" else
	--Sign Extention and * 4
	std_logic_vector(shift_left(resize(signed(immed), output'length),2)) when func = "01" else
	--Zero Fill
	(31 downto immed'length => '0') & immed when func = "10" else
	--Zero Fill and << 16 
	std_logic_vector(shift_left(unsigned((31 downto immed'length => '0') & immed),16));	
end Behavioral;
