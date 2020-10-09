library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux is
  port (
        mux_in_0 : in std_logic_vector(31 downto 0);
        mux_in_1 : in std_logic_vector(31 downto 0);
        mux_in_2 : in std_logic_vector(31 downto 0);
        mux_in_3 : in std_logic_vector(31 downto 0);
        mux_in_4 : in std_logic_vector(31 downto 0);
        mux_in_5 : in std_logic_vector(31 downto 0);
        mux_in_6 : in std_logic_vector(31 downto 0);
        mux_in_7 : in std_logic_vector(31 downto 0);
        mux_in_8 : in std_logic_vector(31 downto 0);
        mux_in_9 : in std_logic_vector(31 downto 0);
        mux_in_10 : in std_logic_vector(31 downto 0);
        mux_in_11 : in std_logic_vector(31 downto 0);
        mux_in_12 : in std_logic_vector(31 downto 0);
        mux_in_13 : in std_logic_vector(31 downto 0);
        mux_in_14 : in std_logic_vector(31 downto 0);
        mux_in_15 : in std_logic_vector(31 downto 0);
        mux_in_16 : in std_logic_vector(31 downto 0);
        mux_in_17 : in std_logic_vector(31 downto 0);
        mux_in_18 : in std_logic_vector(31 downto 0);
        mux_in_19 : in std_logic_vector(31 downto 0);
        mux_in_20 : in std_logic_vector(31 downto 0);
        mux_in_21 : in std_logic_vector(31 downto 0);
        mux_in_22 : in std_logic_vector(31 downto 0);
        mux_in_23 : in std_logic_vector(31 downto 0);
        mux_in_24 : in std_logic_vector(31 downto 0);
        mux_in_25 : in std_logic_vector(31 downto 0);
        mux_in_26 : in std_logic_vector(31 downto 0);
        mux_in_27 : in std_logic_vector(31 downto 0);
        mux_in_28 : in std_logic_vector(31 downto 0);
        mux_in_29 : in std_logic_vector(31 downto 0);
        mux_in_30 : in std_logic_vector(31 downto 0);
        mux_in_31 : in std_logic_vector(31 downto 0);
        sel : in std_logic_vector(4 downto 0);
        mux_out : out std_logic_vector(31 downto 0)
        );
end mux;

architecture arch of mux is
signal mux_out_temp : std_logic_vector(31 downto 0);
begin
	mux_out_temp <= mux_in_0 when sel = B"00000" else
					mux_in_1 when sel = B"00001" else
					mux_in_2 when sel = B"00010" else
					mux_in_3 when sel = B"00011" else
					mux_in_4 when sel = B"00100" else
					mux_in_5 when sel = B"00101" else
					mux_in_6 when sel = B"00110" else
					mux_in_7 when sel = B"00111" else
					mux_in_8 when sel = B"01000" else
					mux_in_9 when sel = B"01001" else
					mux_in_10 when sel = B"01010" else
					mux_in_11 when sel = B"01011" else
					mux_in_12 when sel = B"01100" else
					mux_in_13 when sel = B"01101" else
					mux_in_14 when sel = B"01110" else
					mux_in_15 when sel = B"01111" else
					mux_in_16 when sel = B"10000" else
					mux_in_17 when sel = B"10001" else
					mux_in_18 when sel = B"10010" else
					mux_in_19 when sel = B"10011" else
					mux_in_20 when sel = B"10100" else
					mux_in_21 when sel = B"10101" else
					mux_in_22 when sel = B"10110" else
					mux_in_23 when sel = B"10111" else
					mux_in_24 when sel = B"11000" else
					mux_in_25 when sel = B"11001" else
					mux_in_26 when sel = B"11010" else
					mux_in_27 when sel = B"11011" else
					mux_in_28 when sel = B"11100" else
					mux_in_29 when sel = B"11101" else
					mux_in_30 when sel = B"11110" else
					mux_in_31 when sel = B"11111";
	
		mux_out <= mux_out_temp after 10 ns;
end architecture;
