library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgCount is
    Port (  pc_new : in std_logic_vector(31 downto 0);
            Rst : in std_logic;
            Clk : in std_logic;
            PC_we : in std_logic;
            PC  :   out std_logic_vector(31 downto 0));
end ProgCount;

architecture Behavioral of ProgCount is
signal pc_buff : std_logic_vector(31 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				pc_buff <= X"0000_0000";
			else
				if PC_we = '1' then
					pc_buff <= pc_new;
				end if;
			end if;
		end if;
	end process;
	PC <= pc_buff;
end Behavioral;
