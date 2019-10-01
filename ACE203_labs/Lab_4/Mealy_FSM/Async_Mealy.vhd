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
Type state is(s0,s1,s2,s3,s4,s5);
signal fsm_state : state;
begin
	process
	begin
	wait until clk'event and clk = '1';
		if rst = '1' then
			fsm_state <= s0;
		else
			case fsm_state is
				when s0 =>
					if ((a='1' and b='1') or (a='0' and b='0')) then
						fsm_state <= s5;
					elsif (a='1' and b='0') then
						fsm_state <= s1;
					elsif (a='0' and b='1') then
						fsm_state <= s4;
					end if;
				when s1 =>
					if ((a='1' and b='1') or (a='0' and b='0')) then
						fsm_state <= s1;
					elsif (a='1' and b='0') then
						fsm_state <= s2;
					elsif (a='0' and b='1') then
						fsm_state <= s0;
					end if;
				when s2 =>
					if ((a='1' and b='1') or (a='0' and b='0')) then
						fsm_state <= s2;
					elsif (a='1' and b='0') then
						fsm_state <= s3;
					elsif (a='0' and b='1') then
						fsm_state <= s1;
					end if;
				when s3 =>
					if ((a='1' and b='1') or (a='0' and b='0')) then
						fsm_state <= s3;
					elsif (a='1' and b='0') then
						fsm_state <= s4;
					elsif (a='0' and b='1') then
						fsm_state <= s2;
					end if;
				when s4 =>
					if ((a='1' and b='1') or (a='0' and b='0')) then
						fsm_state <= s4;
					elsif (a='1' and b='0') then
						fsm_state <= s0;
					elsif (a='0' and b='1') then
						fsm_state <= s3;
					end if;
				when s5 => 
						fsm_state <= s0;
				when others =>
					fsm_state <= fsm_state;
			end case;
		end if;
	end process;
	control(0) <= '1' when((fsm_state = s0 and (a='1' and b='0')) or (fsm_state = s1 and ((a='1' and b='1') or (a='0' and b='0'))) or (fsm_state = s2 and (a='0' and b='1')) or
							(fsm_state = s2 and (a='1' and b='0')) or (fsm_state = s3 and ((a='1' and b='1') or (a='0' and b='0'))) or (fsm_state = s4 and (a='0' and b='1'))) else '0';
	control(1) <= '1' when((fsm_state = s1 and (a='1' and b='0')) or (fsm_state = s2 and ((a='1' and b='1') or (a='0' and b='0'))) or (fsm_state = s2 and (a='1' and b='0')) or
							(fsm_state = s3 and (a='0' and b='1')) or (fsm_state = s3 and ((a='1' and b='1') or (a='0' and b='0'))) or (fsm_state = s4 and (a='0' and b='1'))) else '0';
	control(2) <= '1' when((fsm_state = s0 and (a='0' and b='1')) or (fsm_state = s4 and ((a='1' and b='1') or (a='0' and b='0'))) or (fsm_state = s3 and (a='1' and b='0'))) else '0';
end Behavioral;

