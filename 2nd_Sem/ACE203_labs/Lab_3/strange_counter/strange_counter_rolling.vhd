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

architecture behavioral of strange_counter is
signal qtemp : std_logic_vector(7 downto 0);
signal qvalid : std_logic;
begin
	process
	begin
		wait until clk'event and clk = '1';
		if rst = '1' then 
			qtemp <= X"00";
			qvalid <= '1';
			ovf <= '0';
			unf <= '0';
		else    
			if qvalid = '0' then 
				qtemp<=qtemp;
				qvalid<=qvalid;
			else    
				if control = 0 and qtemp < 5 then   
					qvalid<='0';
					unf<='1';
					ovf<='0';
					qtemp<= 255 - (4 - qtemp );
				elsif control = 0 then
					qvalid<='1';
					ovf<='0';
					unf<='0';
					qtemp<= qtemp - 5;
				elsif control = 1 and qtemp < 2 then 
					qvalid<='0';
					unf<='1';
					ovf<='0';
					qtemp<= 255 - (1 - qtemp);
				elsif control = 1 then
					qvalid<='1';
					ovf<='0';
					unf<='0';
					qtemp <= qtemp - 2;
				elsif control = 2 then
					qvalid<='1';
					qtemp<=qtemp;
					ovf<='0';
					unf<='0';
				elsif control = 3 and qtemp = 255 then
					qvalid<='0';
					ovf<='1';
					unf<='0';
					qtemp<= X"00";
				elsif control = 3 then
					qvalid<='1';
					ovf<='0';
					unf<='1';
					qtemp<= qtemp + 1;
				elsif control = 4 and qtemp > 253 then
					qvalid<='0';
					ovf<='1';
					unf<='0';
					qtemp<= qtemp - 254;
				elsif control = 4 then 
					qvalid<='1';
					ovf<='0';
					unf<='1';
					qtemp<= qtemp + 2;
				elsif control = 5 and qtemp > 250 then
					qvalid<='0';
					ovf <='1';
					unf<='0';
					qtemp<= qtemp - 251;
				elsif control = 5 then 
					qvalid<='1';
					ovf<='0';
					unf<='0';
					qtemp <= qtemp + 5;
				elsif control = 6 and qtemp > 249 then
					qvalid <= '0';
					ovf<='1';
					unf<='0';
					qtemp<= qtemp - 250;
				elsif control = 6 then 
					qvalid <= '1';
					ovf<='0';
					unf<='0';
					qtemp<=qtemp + 6;
				elsif control = 7 and qtemp > 243 then 
					qvalid <='0';
					ovf<='1';
					unf<='0';
					qtemp<= qtemp - 244;
				elsif control = 7 then 
					qvalid <='1';
					ovf<='0';
					unf<='0';
					qtemp<=qtemp+ 12;
				end if;
			end if;
		end if;
	end process;
	count <=qtemp;
	valid <=qvalid;
end behavioral;