library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity FSM is
	Port
	(
		clk : in std_logic;
		rst : in std_logic;
		a 	: in std_logic;
		b	: in std_logic;
		control : out std_logic_vector(2 downto 0)
	);
end FSM;

architecture Behavioral of FSM is
Type state is(s0,s1,s2,s3,s4);
signal fsm_state : state;
begin
	process
	begin
		wait until clk'event and clk='1';
		if rst='1' then
			fsm_state <= s0;
		else
			case fsm_state is 
				when s0 => 
				if (a = '1' and b = '1') or (a = '0' and b = '0') then 
					fsm_state <= s0;
					control <= B"000";
				elsif (a = '1' and b = '0') then
					fsm_state <= s1; 
					control <= B"001";
				elsif (a = '0' and b = '1') then
					fsm_state <= s4;
					control <= B"100";
				end if;
				when s1 =>
				if (a = '1' and b = '1') or (a = '0' and b = '0') then 
					fsm_state <= s1;
					control <= B"001";
				elsif (a = '0' and b = '1') then
					fsm_state <= s0;
					control <= B"000";
				elsif (a = '1' and b = '0') then
					fsm_state <= s2;
					control <= B"010";
				end if;
				when s2 => 
				if (a = '1' and b = '1') or (a = '0' and b = '0') then 
					fsm_state <= s2;
					control <= B"010";
				elsif (a = '0' and b = '1') then
					fsm_state <= s1;
					control <= B"001";
				elsif (a = '1' and b = '0') then
					fsm_state <= s3;
					control <= B"011";
				end if;
				when s3 => 
				if (a = '1' and b = '1') or (a = '0' and b = '0') then 
					fsm_state <= s3;
					control <= B"011";
				elsif (a = '0' and b = '1') then
					fsm_state <= s2;
					control <= B"010";
				elsif (a = '1' and b = '0') then
					fsm_state <= s4;
					control <= B"100";
				end if;
				when s4 => 
				if (a = '1' and b = '1') or (a = '0' and b = '0') then 
					fsm_state <= s4;
					control <= B"100";
				elsif (a = '0' and b = '1') then
					fsm_state <= s3;
					control <= B"011";
				elsif (a = '1' and b = '0') then
					fsm_state <= s0;
					control<=B"000";
				end if;
				when others =>
					fsm_state <= s0;
					control<=B"000";
			end case;
		end if;
	end process;
end Behavioral;

