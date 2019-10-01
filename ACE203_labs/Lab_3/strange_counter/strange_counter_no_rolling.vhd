library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity strange_counter is
    Port ( clk : in  STD_LOGIC;
           control : in  STD_LOGIC_VECTOR (2 downto 0);
           rst : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (7 downto 0);
           valid : out  STD_LOGIC;
           ovf : out  STD_LOGIC;
           unf : out  STD_LOGIC);
end strange_counter;

architecture Behavioral of strange_counter is
signal qtemp : std_logic_vector(7 downto 0);
begin	
	process
		begin
			wait until clk'event and clk = '1';
			if rst = '1' then
				qtemp<= X"00";
				valid<='0';
				ovf <='0';
				unf <='0';
			else
				if control = 0 and qtemp < 5 then
					qtemp<=qtemp;
					unf<='1';
					valid<='0';
					ovf<='0';
				elsif control = 0 then 
					qtemp<=qtemp-5;
					valid <='1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 1 and qtemp < 2 then 
					qtemp<=qtemp;
					unf<='1';
					valid<= '0';
					ovf<='0';
				elsif control = 1 then
					qtemp<=qtemp - 2;
					valid <= '1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 2 then 
					qtemp<=qtemp;
					valid<= '1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 3 and qtemp = 255 then 
					qtemp<=qtemp;
					valid<='0';
					ovf<='1';
					unf<='0';
				elsif control = 3 then 
					qtemp <= qtemp + 1;
					ovf <='0';
					unf <='0';
					valid <='1';
				end if;
				if control = 4 and qtemp > 253 then 
					qtemp<=qtemp;
					valid<='0';
					ovf <='1';
					unf <='0';
				elsif control = 4 then
					qtemp <= qtemp + 2;
					valid<='1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 5 and qtemp > 250 then 
					qtemp <=qtemp;
					valid<='0';
					ovf <= '1';
					unf <='0';
				elsif control = 5 then
					qtemp <= qtemp + 5;
					valid <= '1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 6 and qtemp > 249 then 
					qtemp <= qtemp;
					valid <='0';
					ovf <= '1';
					unf <= '0';
				elsif control = 6 then
					qtemp <= qtemp + 6;
					valid <= '1';
					ovf <='0';
					unf <='0';
				end if;
				if control = 7 and qtemp > 243 then 
					qtemp <= qtemp;
					valid<='0';
					ovf <='1';
					unf<='0';
				elsif control = 7 then
					qtemp <= qtemp + 12 ;
					valid <= '1';
					ovf <='0';
					unf <='0';
				end if;
			end if;
	end process;
	count <= qtemp;
end Behavioral;

