library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_2bits is  -- create an entity with required inputs and outputs
	port(
		a : in std_logic_vector(1 downto 0);
		b : in std_logic_vector(1 downto 0);
		cin : in std_logic;
		sum : out std_logic_vector(1 downto 0);
		cout: out std_logic
	);
end full_adder_2bits;

architecture Behavioral of full_adder_2bits is --create an arch

signal temp : std_logic; --declare a signal

component full_adder is --use a component locaded in athorer module
 port 
 (
	a : in  STD_LOGIC; 
	b : in  STD_LOGIC;
	cin : in  STD_LOGIC;
   sum : out  STD_LOGIC;
   cout : out  STD_LOGIC
 );
end component;

begin
	FA2_1 : full_adder port map( --map the components inputs-outputs to the entity + signals
	a => a(0),
	b => b(0),
	cin => cin,
	sum => sum(0),
	cout => temp
	);
	FA2_2 : full_adder port map(
	a => a(1),
	b => b(1),
	cin => temp,
	sum => sum(1),
	cout => cout
	);
end Behavioral;

