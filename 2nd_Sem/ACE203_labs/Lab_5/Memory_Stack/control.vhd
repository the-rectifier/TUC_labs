library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity control is
	port
	(
		clk 				: in std_logic;
		rst 				: in std_logic;
		push 				: in std_logic;
		pop 				: in std_logic;
		almost_empty 	: out std_logic;
		almost_full 	: out std_logic;
		full 				: out std_logic;
		empty 			: out std_logic;
		addra				: out std_logic_vector (3 downto 0);
		wen				: out std_logic_vector(0 downto 0)
	);
end control;

architecture Behavioral of control is
type state is (idle, st_push, st_pop);
signal ctrl_state :state;
signal temp_addra : std_logic_vector (3 downto 0) := X"0";
begin
	process
	begin
		wait until clk'event and clk = '1';
		if rst = '1' then
			ctrl_state <= idle;
			temp_addra <= X"0";
			empty<= '1';
			almost_empty <= '0';
			almost_full <= '0';
			full <='0';
			wen(0) <= '0';
		else
			case ctrl_state is
				when idle =>
					wen(0) <= '0';
					if push = '1' and pop = '0' then
						if temp_addra = 10 then
							full <= '1';
							almost_full <= '0';
							empty <='0';
							almost_empty <='0';
						elsif temp_addra <= 2 then
							temp_addra <= temp_addra + 1;
							almost_full <= '0';
							almost_empty <= '1';
							empty<='0';
							full<='0';
							ctrl_state <= st_push;
						elsif temp_addra >= 8 then
							temp_addra <= temp_addra + 1;
							almost_full <= '1';
							full <= '0';
							empty<='0';
							almost_empty<='0';
							ctrl_state <= st_push;
						else
							temp_addra <= temp_addra + 1;
							almost_full <= '0';
							full <= '0';
							almost_empty<='0';
							almost_full <='0';
							ctrl_state <= st_push;
						end if;
					elsif pop = '1' and push = '0' then
						if temp_addra = 0 then
							empty <= '1';
							almost_empty <= '0';
							full<='0';
							almost_full<='0';
						elsif temp_addra >= 9 then
							almost_full <= '1';
							empty <='0';
							almost_empty<='0';
							full<='0';
							ctrl_state <= st_pop;
						elsif temp_addra <= 3 then
							almost_empty <= '1';
							empty <='0';
							full<='0';
							almost_full <='0';
							ctrl_state <= st_pop;
						else
							almost_empty <= '0';
							empty <='0';
							full<='0';
							almost_full <='0';
							ctrl_state <= st_pop;
						end if;
					end if;
				when st_push => -- PUSH
					wen(0) <= '1';
					ctrl_state <= idle;
				when st_pop => -- POP
					temp_addra <= temp_addra - 1;
					wen(0) <= '0';
					ctrl_state <= idle;
			end case;
		end if;
	end process;
	addra <= temp_addra;
end Behavioral;

