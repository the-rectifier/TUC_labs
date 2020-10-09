----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory is
	port
	(
	push 				: in std_logic;
	pop 				: in std_logic;
	clk				: in std_logic;
	rst 				: in std_logic;
	data_in			: in std_logic_vector(3 downto 0);
	data_out			: out std_logic_vector(3 downto 0);
	full				: out std_logic;
	empty				: out std_logic;
	almost_empty	: out std_logic;
	almost_full		: out std_logic
	);
	end memory;

architecture Behavioral of memory is
signal temp_addr : std_logic_vector (3 downto 0);
signal wen : std_logic_vector (0 downto 0);
--signal temp_push : std_logic;
--signal temp_pop : std_logic;
component control is port
(
	clk : in std_logic;
	rst : in std_logic;
	push : in std_logic;
	pop : in std_logic;
	almost_empty : out std_logic;
	almost_full : out std_logic;
	full : out std_logic;
	empty : out std_logic;
	addra : out std_logic_vector(3 downto 0);
	wen : out std_logic_vector(0 downto 0)
);
end component;

component stack is port
(
	clka : in std_logic;
	rsta : in std_logic;
	wea : in std_logic_vector (0 downto 0);
	addra : in std_logic_vector(3 downto 0);
	dina : in std_logic_vector(3 downto 0);
	douta : out std_logic_vector(3 downto 0)
);
end component;

--component singlepulsegen is port
--(
--	clk : in std_logic;
--	rst : in std_logic;
--	input : in std_logic;
--	output : out std_logic
--);
--end component;

attribute box_type : string; 
attribute box_type of stack : component is "black_box"; 

begin

--	pushit : singlepulsegen port map
--	(
--		clk => clk,
--		rst => rst,
--		input => push,
--		output => temp_push
--	);
--	popit : singlepulsegen port map
--	(
--		clk => clk,
--		rst => rst,
--		input => pop,
--		output => temp_pop
--	);
	memory_control : control port map
	(
		clk => clk,
		rst => rst,
--		push => temp_push,
--		pop => temp_pop,
		push => push,
		pop => pop,
		almost_empty => almost_empty,
		almost_full => almost_full,
		full => full,
		empty => empty,
		wen => wen,
		addra => temp_addr
	);
	memory_stack : stack port map
	(
		clka => clk,
		rsta => rst,
		wea => wen,
		addra => temp_addr,
		dina => data_in,
		douta => data_out
	);
end Behavioral;

