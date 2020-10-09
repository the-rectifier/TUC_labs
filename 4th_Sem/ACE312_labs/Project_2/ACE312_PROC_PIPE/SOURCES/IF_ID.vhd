library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is port
	(
		clk : in std_logic;
		rst : in std_logic;
		
		IFID_WE : in std_logic;
		Instr_in : in std_logic_vector(31 downto 0);
		Instr_out : out std_logic_vector(31 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0);
		RS_OUT : out std_logic_vector(4 downto 0);
		RT_OUT : out std_logic_vector(4 downto 0));
end IF_ID;

architecture behav of IF_ID is
signal instr_holder : std_logic_vector(31 downto 0);
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				instr_holder <= X"0000_0000";
			elsif IFID_WE = '1' then
				instr_holder <= Instr_in;
			end if;
		end if;
	end process;
	Instr_out <= instr_holder;
	RD_OUT <= instr_holder(20 downto 16);
	RS_OUT <= instr_holder(25 downto 21);
	RT_OUT <= instr_holder(15 downto 11);
end;