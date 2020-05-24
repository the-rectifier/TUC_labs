library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EX is
	Port(
		clk : in std_logic;
		rst : in std_logic;
		-- FLAGS
		WB_FLAGS_IN : in std_logic_vector(1 downto 0);
		WB_FLAGS_OUT : out std_logic_vector(1 downto 0);
		
		MEM_FLAGS_IN : in std_logic_vector(1 downto 0);
		MEM_FLAGS_OUT : out std_logic_vector(1 downto 0);
		
		ALU_FLAGS_IN : in std_logic_vector(4 downto 0);
		ALU_Func : out std_logic_vector(3 downto 0);
		ALU_B_Sel : out std_logic;
		
		OP_CODE_IN : in std_logic_vector(5 downto 0);
		OP_CODE_OUT : out std_logic_vector(5 downto 0);
		
		RF_A_IN : in std_logic_vector(31 downto 0);
		RF_B_IN : in std_logic_vector(31 downto 0);
		
		RF_A_OUT : out std_logic_vector(31 downto 0);
		RF_B_OUT : out std_logic_vector(31 downto 0);
		
		IMMED_IN : in std_logic_vector(31 downto 0);
		IMMED_OUT : out std_logic_vector(31 downto 0);
		
		REGS_IN : in std_logic_vector(14 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0);
		RS_OUT : out std_logic_vector(4 downto 0);
		RT_OUT : out std_logic_vector(4 downto 0));
end ID_EX;

architecture Behavioral of ID_EX is

signal WB_FLAGS_HOLDER : std_logic_vector(1 downto 0);
signal MEM_FLAGS_HOLDER : std_logic_vector(1 downto 0);
signal ALU_FLAGS_HOLDER : std_logic_vector(4 downto 0);
signal RF_A_HOLDER : std_logic_vector(31 downto 0);
signal RF_B_HOLDER : std_logic_vector(31 downto 0);
signal IMMED_HOLDER : std_logic_vector(31 downto 0);
signal REGS_HOLDER : std_logic_vector(14 downto 0);
signal OP_CODE_HOLDER : std_logic_vector(5 downto 0);
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				WB_FLAGS_HOLDER <= "00";
				MEM_FLAGS_HOLDER <= "00";
				ALU_FLAGS_HOLDER <= "00000";
				RF_A_HOLDER <= X"0000_0000";
				RF_B_HOLDER <= X"0000_0000";
				IMMED_HOLDER <= X"0000_0000";
				REGS_HOLDER <= (14 downto 0 => '0');
				OP_CODE_HOLDER <= "000000";
			else
				WB_FLAGS_HOLDER <= WB_FLAGS_IN;
				MEM_FLAGS_HOLDER <= MEM_FLAGS_IN;
				ALU_FLAGS_HOLDER <= ALU_FLAGS_IN;
				RF_A_HOLDER <= RF_A_IN;
				RF_B_HOLDER <= RF_B_IN;
				IMMED_HOLDER <= IMMED_IN;
				REGS_HOLDER <= REGS_IN;
				OP_CODE_HOLDER <= OP_CODE_IN;
			end if;
		end if;
	end process;
	
	WB_FLAGS_OUT <= WB_FLAGS_HOLDER;
	MEM_FLAGS_OUT <= MEM_FLAGS_HOLDER;
	ALU_Func <= ALU_FLAGS_HOLDER(3 downto 0);
	ALU_B_Sel <= ALU_FLAGS_HOLDER(4);
	RF_A_OUT <= RF_A_HOLDER;
	RF_B_OUT <= RF_B_HOLDER;
	IMMED_OUT <= IMMED_HOLDER;
	RS_OUT <= REGS_HOLDER(14 downto 10);
	RD_OUT <= REGS_HOLDER(9 downto 5);
	RT_OUT <= REGS_HOLDER(4 downto 0);
	OP_CODE_OUT <= OP_CODE_HOLDER;
end Behavioral;
