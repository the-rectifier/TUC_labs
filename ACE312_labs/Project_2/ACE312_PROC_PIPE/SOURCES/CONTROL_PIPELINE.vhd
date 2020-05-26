library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- testing was done in the SINGLE CYCLE 
-- deprecated irrelevant signals like the extent function and the 2nd register selection moved to DECSTAGE
entity CONTROL_PIPELINE is
	Port (
		Instr : in std_logic_vector(31 downto 0);
		WB_flags : out std_logic_vector(1 downto 0);
		ALU_Flags: out std_logic_vector(4 downto 0);
		MEM_Flags: out std_logic_vector(1 downto 0);
		
		flush : in std_logic);
end CONTROL_PIPELINE;

architecture Behavioral of CONTROL_PIPELINE is
signal Op_code : std_logic_vector(5 downto 0);
signal ALU_B_Sel : std_logic;
signal ByteOp : std_logic; -- done
signal MEM_WE : std_logic; -- done
signal RF_WE : std_logic;
signal RF_WD_Sel: std_logic;
signal ALU_Func: std_logic_vector(3 downto 0);
begin
	Op_code <= Instr(31 downto 26);
	ALU_B_sel <= '0' when (Op_Code = "100000" or Op_Code = "111111" or Op_Code = "000000" or Op_Code = "000001") else
				'1';
			
	RF_WE <= '1' when ((Op_code = "100000") or (Op_code = "111000") or
				 	(Op_code = "111001") or (Op_code = "110000") or
				 	(Op_code = "110011") or (Op_code = "110010") or
				 	(Op_code = "000011") or (Op_code = "001111"))
				 	else '0';
				 	
	ByteOp <= '1' when (Op_code = "000011" or Op_code = "000111") else '0';

	--we writing? 
	-- sb, sw
	MEM_We <= '1' when (Op_code = "000111" or Op_code = "011111") else '0';
	
	--we writing from mem?
	-- lb, lw
	RF_WD_Sel <= '1' when (Op_code = "001111" or Op_code = "000011") else '0';
	
	
	
	ALU_Func <= Instr(3 downto 0) when Op_code = "100000" else
			"0000" when (Op_code = "110000" or Op_code = "000011" or Op_code = "000111" or
					Op_code = "011111" or Op_code = "001111") else
			"0011" when (Op_code = "110011" or Op_code = "111000" or Op_code = "111001") else
			"0011" when (Op_code = "000000" or Op_code = "000001") else 
			"0101" when (Op_code = "110010") else "1111";
			
			
	WB_flags(0) <= RF_WE when flush = '0' else '0';
	WB_flags(1) <= RF_WD_Sel when flush = '0' else '0';
	ALU_flags(4) <= ALU_B_Sel when flush = '0' else '0';
	ALU_flags(3 downto 0) <= ALU_Func when flush = '0' else "0000";
	mem_flags(0) <= MEM_WE when flush = '0' else '0';
	mem_flags(1) <= ByteOP when flush = '0' else '0';
				
end Behavioral;
