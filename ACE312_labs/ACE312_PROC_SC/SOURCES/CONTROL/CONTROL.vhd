library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL is
	Port (
		Instr : in std_logic_vector(31 downto 0);
		ALU_z : in std_logic;
		ALU_Func: out std_logic_vector(3 downto 0); --done 
		PC_Sel : out std_logic; --done
		RF_WD_Sel: out std_logic; --done
		RF_B_Sel : out std_logic; --done
		RF_WE : out std_logic; --done
		ImmExt : out std_logic_vector(1 downto 0); --done
		ALU_B_Sel : out std_logic; --done
		ByteOp : out std_logic; --done
		MEM_WE : out std_logic); --done
end CONTROL;

-- ALU_Z is an asynchrous signal provided by the ALU each time the operation results in 0

architecture Behavioral of CONTROL is
signal Op_code : std_logic_vector(5 downto 0);
begin
Op_code <= Instr(31 downto 26);

--immed function
-- 00 -> Sign Extend 
-- 01 -> Sign Extend << 2
-- 10 -> Zfill
-- 11 -> Zfill << 16 (lui)
ImmExt <= "10" when (Op_code = "111001") else
			"01" when (Op_code = "000000" or Op_code = "000001" or Op_code="111111") else
			"00" when (Op_code = "110010" or Op_code = "110011" or Op_code = "111000" or Op_code = "110000" or Op_code = "000011" or Op_code = "011111" or Op_code = "001111" or Op_code = "000111" ) else
			"11" when (Op_code = "111001") else
			"10";

-- second register for RF	
-- rt is used only for R instructions
-- brances and memory instructions need this HIGH for the 2nd register 
-- li, lui commands read r0 as rs any way
-- rd is hardwired to destination as well
RF_B_Sel <= '0' when Op_code = "100000" else '1';

--branch or not?	
-- b is unconditional while beq and bne depend on the ALU_Z signal
PC_sel <= '1' when ((Op_code = "111111") or 
					(ALU_z = '1' and Op_code = "000000") or
					(ALU_z = '0' and Op_code = "000001"))
					else '0';
					
--2nd operand of ALU	
--Rtypes and branches need 2 Registers going to ALU			
ALU_B_sel <= '0' when (Op_Code = "100000" or Op_Code = "111111" or 
					Op_Code = "000000" or Op_Code = "000001") else
					'1';

--write to register?
RF_WE <= '1' when ((Op_code = "100000") or (Op_code = "111000") or
				 	(Op_code = "111001") or (Op_code = "110000") or
				 	(Op_code = "110011") or (Op_code = "110010") or
				 	(Op_code = "000011") or (Op_code = "001111"))
				 	else '0';

--are we byting? 
-- lb, sb
ByteOp <= '1' when (Op_code = "000011" or Op_code = "000111") else '0';

--we writing? 
-- sb, sw
MEM_We <= '1' when (Op_code = "000111" or Op_code = "011111") else '0';

--we writing from mem?
-- lb, lw
RF_WD_Sel <= '1' when (Op_code = "001111" or Op_code = "000011") else '0';

--R Type is the last 4 bits of Func
--ALU ADD for non R-Types -> Memory instructions, addi
--ALU OR for non R-Types -> ori, lui, li
--ALU SUB for non R-Types -> bne, beq
--ALU NAND for non R-Types -> nandi

ALU_Func <= Instr(3 downto 0) when Op_code = "100000" else
			"0000" when (Op_code = "110000" or Op_code = "000011" or Op_code = "000111" or
					Op_code = "011111" or Op_code = "001111") else
			"0011" when (Op_code = "110011" or Op_code = "111000" or Op_code = "111001") else
			"0011" when (Op_code = "000000" or Op_code = "000001") else 
			"0101" when (Op_code = "110010") else "1111";
			


end Behavioral;
