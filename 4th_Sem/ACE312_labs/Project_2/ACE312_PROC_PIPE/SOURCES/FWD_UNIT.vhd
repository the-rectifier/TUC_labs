library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FWD_UNIT is
	Port(
			OP_CODE_IDEX : in std_logic_vector(5 downto 0);
			IDEX_RD : in std_logic_vector(4 downto 0);
			IDEX_RT : in std_logic_vector(4 downto 0);
			IDEX_RS : in std_logic_vector(4 downto 0);
			IDEX_MEM_WE : in std_logic;
			
			OP_CODE_IFID: in std_logic_vector(5 downto 0);
			IFID_RD : in std_logic_vector(4 downto 0);
			IFID_RS : in std_logic_vector(4 downto 0);
			IFID_RT : in std_logic_vector(4 downto 0);
			
			EXMEM_RD : in std_logic_vector(4 downto 0);
			MEMWB_RD : in std_logic_vector(4 downto 0);
			
			EXMEM_RF_WE : in std_logic;
			MEMWB_RF_WE : in std_logic;
			
			INJECT_A_AFTER : out std_logic_vector(1 downto 0);
			INJECT_B_AFTER : out std_logic_vector(1 downto 0);
			
			INJECT_A_BEFORE : out std_logic;
			INJECT_B_BEFORE : out std_logic);
end FWD_UNIT;

architecture Behavioral of FWD_UNIT is

begin
	-- inject data into the output RF_A of the ID->EX module if EX_MEM RD is the RS (A operand) of the next
	-- in-pipe instruction
	-- inject EX_MEM output to ALU input (01) when 
	-- the next instruction is @ EXSTAGE and current instruction is after EX_MEM
	-- inject MEM_WB output to ALU input (10) when 
	-- the next instruction is @ EXSTAGE and current instruction is @ WB
	-- no injection needed elsewhere
	INJECT_A_AFTER <= "01" when (EXMEM_RF_WE = '1' and EXMEM_RD /= "00000" and EXMEM_RD=IDEX_RS) else
						"10" when (MEMWB_RF_WE = '1' and MEMWB_RD /= "00000" and MEMWB_RD=IDEX_RS) else
						"00";
	
	-- same logic applies w/ B path, however add checks for R-Type (because of RT's overlap w/ Immed)
	-- and also check whether the next instruction is a store, in that case we need to inject the DATA of RD
	-- (RD as operand rather than destination)  
	INJECT_B_AFTER <= "01" when (EXMEM_RF_WE = '1' and EXMEM_RD /= "00000") and ((EXMEM_RD=IDEX_RT and OP_CODE_IDEX="100000") or (IDEX_MEM_WE = '1' and EXMEM_RD = IDEX_RD)) else
						"10" when (MEMWB_RF_WE = '1' and MEMWB_RD /= "00000") and ((MEMWB_RD=IDEX_RT and OP_CODE_IDEX="100000") or (IDEX_MEM_WE = '1' and MEMWB_RD = IDEX_RD)) else
						"00";
						
						
	-- same logic as before, but never inject the ALU_OUT from EX_MEM
	INJECT_A_BEFORE <= '1' when (MEMWB_RF_WE = '1' and MEMWB_RD /= "00000" and MEMWB_RD = IFID_RS) else '0';
	
	INJECT_B_BEFORE <= '1' when (MEMWB_RF_WE = '1' and MEMWB_RD /= "00000") and ((MEMWB_RD = IFID_RT and OP_CODE_IFID="100000") or ((OP_CODE_IFID="000111" or OP_CODE_IFID="011111") and IFID_RD = MEMWB_RD)) else '0';
	
end Behavioral;
