library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_MEM is
	Port ( 
		clk : in std_logic;
		rst : in std_logic;
		
		-- WB_flags(0) = RF_WE
		-- WB_flags(1) = RF_WD_Sel
		WB_flags_in : in std_logic_vector(1 downto 0);
		WB_flags_out : out std_logic_vector(1 downto 0);
		
		-- MEM_flags(0) = MEM_WE
		-- MEM_flags(1) = ByteOP
		MEM_flags_in : in std_logic_vector(1 downto 0);
		
		MEM_WE : out std_logic;
		ByteOP : out std_logic;
		
		ALU_z_in : in std_logic;
		ALU_z_out : out std_logic;
		
		ALU_OUT_in : in std_logic_vector(31 downto 0);
		ALU_OUT_out : out std_logic_vector(31 downto 0);
		
		DATA_in : in std_logic_vector(31 downto 0);
		DATA_out : out std_logic_vector(31 downto 0);
		
		RD_IN : in std_logic_vector(4 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0));
end EX_MEM;

architecture Behavioral of EX_MEM is
signal s_WB_flags : std_logic_vector(1 downto 0);
signal s_MEM_flags : std_logic_vector(1 downto 0);
signal s_ALU_z : std_logic;
signal s_ALU_OUT: std_logic_vector(31 downto 0);
signal s_DATA : std_logic_vector(31 downto 0);
signal s_RD: std_logic_vector(4 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				s_WB_flags <= "00";
				s_MEM_flags <= "00";
				s_ALU_z <= '0';
				s_ALU_OUT <= X"0000_0000";
				s_DATA <= X"0000_0000";
				s_RD <= "00000";
			else
				s_WB_flags <= WB_flags_in;
				s_MEM_flags <= MEM_flags_in;
				s_ALU_z <= ALU_z_in;
				s_ALU_OUT <= ALU_OUT_in;
				s_DATA <= DATA_in;
				s_RD <= RD_IN;
			end if;
		end if;
	end process;
	
	WB_flags_out <= s_WB_flags;
	MEM_WE <= s_MEM_flags(0);
	ByteOP <= s_MEM_flags(1);
	ALU_z_out <= s_ALU_z;
	ALU_OUT_out <= s_ALU_OUT;
	DATA_out <= s_DATA;
	RD_OUT <= s_RD;
end Behavioral;
