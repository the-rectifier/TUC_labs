library IEEE;
use ieee.std_logic_1164.all;

entity MEM_WB is port(
			clk : in std_logic; 
			rst : in std_logic;
			
			WB_flags_in : in std_logic_vector(1 downto 0);
			
			RF_WE : out std_logic;
			RF_WD_Sel : out std_logic;
			
			MEM_DATA_in : in std_logic_vector(31 downto 0);
			MEM_DATA_out : out std_logic_vector(31 downto 0);
			
			R_DATA_in : in std_logic_vector(31 downto 0);
			R_DATA_out : out std_logic_vector(31 downto 0);
			
			RD_IN : in std_logic_vector(4 downto 0);
			RD_out : out std_logic_vector(4 downto 0));
end MEM_WB;


architecture behav of MEM_WB is
signal s_WB_flags : std_logic_vector(1 downto 0);
signal s_MEM_DATA : std_logic_vector(31 downto 0);
signal s_R_DATA : std_logic_vector(31 downto 0);
signal s_RD: std_logic_vector(4 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				s_WB_flags <= "00";
				s_MEM_DATA <= X"0000_0000";
				s_R_DATA <= X"0000_0000";
				s_RD <= "00000";
			else
				s_WB_flags <= WB_flags_in;
				s_MEM_DATA <= MEM_DATA_in;
				s_R_DATA <= R_DATA_in;
				s_RD <= RD_IN;
			end if;
		end if;
	end process;
	
	RF_WE <= s_WB_flags(0);
	RF_WD_Sel <= s_WB_flags(1);
	
	MEM_DATA_out <= s_MEM_DATA;
	R_DATA_out <= s_R_DATA;
	RD_OUT <= s_RD;
end;