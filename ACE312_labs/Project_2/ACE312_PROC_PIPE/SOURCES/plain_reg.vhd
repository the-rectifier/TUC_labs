library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity plain_reg is
      Port (
            Data_in : in std_logic_vector(31 downto 0);
            WE  : in std_logic;
            Data_out : out std_logic_vector(31 downto 0);
            clk : in std_logic;
            rst : in std_logic 
            );
end plain_reg;

architecture Behavioral of plain_reg is

signal R_data : std_logic_vector(31 downto 0):= X"0000_0000";

begin

    proc: process(clk)
    begin
		if rising_edge(clk) then
      		if rst = '0' then
            	R_data <= X"0000_0000";
        	else
            	if we = '1' then
                	R_data <= Data_in;
            	end if;
        	end if;
		end if;  
    end process;
    --afer simulates the ~2ns delay the gates have
    Data_out <= R_data after 10 ns;
end;
