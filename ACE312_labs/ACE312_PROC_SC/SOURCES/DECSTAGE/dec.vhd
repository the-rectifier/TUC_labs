library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec is
    Port (
          dec_in : in std_logic_vector(4 downto 0);
          dec_out : out std_logic_vector(31 downto 0)
          );
end dec;

architecture Behavioral of dec is
signal dec_out_temp : std_logic_vector(31 downto 0);
begin
	dec_out_temp <= X"0000_0001" when dec_in = B"00000" else
				X"0000_0002" when dec_in = B"00001" else
				X"0000_0004" when dec_in = B"00010" else
				X"0000_0008" when dec_in = B"00011" else
				X"0000_0010" when dec_in = B"00100" else
				X"0000_0020" when dec_in = B"00101" else
				X"0000_0040" when dec_in = B"00110" else
				X"0000_0080" when dec_in = B"00111" else
				X"0000_0100" when dec_in = B"01000" else
				X"0000_0200" when dec_in = B"01001" else
				X"0000_0400" when dec_in = B"01010" else
				X"0000_0800" when dec_in = B"01011" else
				X"0000_1000" when dec_in = B"01100" else
				X"0000_2000" when dec_in = B"01101" else
				X"0000_4000" when dec_in = B"01110" else
				X"0000_8000" when dec_in = B"01111" else
				X"0001_0000" when dec_in = B"10000" else
				X"0002_0000" when dec_in = B"10001" else
				X"0004_0000" when dec_in = B"10010" else
				X"0008_0000" when dec_in = B"10011" else
				X"0010_0000" when dec_in = B"10100" else
				X"0020_0000" when dec_in = B"10101" else
				X"0040_0000" when dec_in = B"10110" else
				X"0080_0000" when dec_in = B"10111" else
				X"0100_0000" when dec_in = B"11000" else
				X"0200_0000" when dec_in = B"11001" else
				X"0400_0000" when dec_in = B"11010" else
				X"0800_0000" when dec_in = B"11011" else 
				X"1000_0000" when dec_in = B"11100" else
				X"2000_0000" when dec_in = B"11101" else
				X"4000_0000" when dec_in = B"11110" else
				X"8000_0000";
				
				--afer simulates the ~2ns delay the gates have
				dec_out <= dec_out_temp after 10 ns;
end Behavioral;
