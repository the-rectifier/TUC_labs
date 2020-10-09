library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_MC is
	Port (
		clk : in std_logic;
		rst : in std_logic;
		Instr : in std_logic_vector(31 downto 0);
		ALU_z : in std_logic;
		ALU_Func: out std_logic_vector(3 downto 0); -- done
		PC_Sel : out std_logic; -- done
		PC_LD : out std_logic; -- done
		IRWrite : out std_logic; -- done
		RF_WD_Sel: out std_logic;  -- done
		RF_B_Sel : out std_logic;  -- done
		RF_WE : out std_logic; -- done
		ImmExt : out std_logic_vector(1 downto 0); -- done
		ALU_A_Sel : out std_logic; -- done
		ALU_B_Sel : out std_logic_vector(1 downto 0); -- done 
		ByteOp : out std_logic; -- done
		MEM_WE : out std_logic); -- done
end CONTROL_MC;

-- ALU_Z is an asynchrous signal provided by the ALU each time the operation results in 0

architecture Behavioral of CONTROL_MC is
signal Op_code : std_logic_vector(5 downto 0);
type states is(i_fetch, i_dec, mem_addr, mem_read, mem_reg, mem_write, exec,i_exec, comp, b_comp);
signal state : states;
begin
	Op_code <= Instr(31 downto 26);
	process(clk)
	begin
		if rising_edge(clk) then
			if rst <= '0' then
				state <= i_fetch;
			else
				case state is
				when i_fetch => state <= i_dec;
				when i_dec =>
					if OP_code = "100000" then
						state <= exec;
					elsif OP_code = "000011" or OP_code = "000111" or OP_code = "001111" or OP_code = "011111" then
						state <= mem_addr;
					elsif OP_code = "111111" or OP_code = "000000" or OP_code = "000001" then
						state <= b_comp;
					elsif OP_code = "111000" or OP_code = "111001" or OP_code = "110000" or OP_code = "110010" or OP_code = "110011" then
						state <= i_exec;
					end if;
				when mem_addr =>
					if OP_code = "000011" or OP_code = "001111" then
						state <= mem_read;
					elsif OP_code = "000111" or OP_code = "011111" then
						state <= mem_write;
					end if;
				when i_exec => state <= comp;
				when mem_read => state <= mem_reg;
				when mem_reg => state <= i_fetch;
				when mem_write => state <= i_fetch;
				when exec => state <= comp;
				when comp => state <= i_fetch;
				when b_comp => state <= i_fetch;
				end case;
			end if;
		end if;
	end process;
	
	-- Not a function of the state
	--immed function
	-- 00 -> Sign Extend 
	-- 01 -> Sign Extend << 2
	-- 10 -> Zfill
	-- 11 -> Zfill << 16 (lui)
	ImmExt <= "10" when (Op_code = "110010" or Op_code = "110011")  else
			"01" when (Op_code = "000000" or Op_code = "000001" or Op_code="111111")  else
			"00" when (Op_code = "111000" or Op_code = "110000" or Op_code = "000011" or Op_code = "011111" or Op_code = "001111" or Op_code = "000111" ) else
			"11" when (Op_code = "111001") else
			"10";
			
	-- Select the PC only when fetching a new instruction and when decoding
	ALU_A_Sel <= '0' when state = i_fetch or state = i_dec else '1';
	
	-- Select:
	--		+4 only when fetching a new instruction
	--		Immed when executing immediate instruction or when decoding or when doing memory crap
	-- 		RF_B elsewhere
	ALU_B_Sel <= "01" when state = i_fetch else 
				 "10" when state = i_exec or state = i_dec or state = mem_addr else 
				 "00";
				 
	-- Write the Instruction to the register only when fetching it
	IRWrite <= '1' when state = i_fetch else '0';
	
	-- Write the new Instruction address only when in b_comp state AND is an unconditional branch or conditional
	PC_LD <= '1' when state = i_fetch or 
				(OP_code = "111111" and state = b_comp) or 
				(OP_code = "000000" and ALU_z = '1' and state = b_comp) or 
				(OP_code = "000001" and ALU_z = '0' and state = b_comp) else 
			'0';
			
	-- Select the new PC only when in b_comp state
	PC_Sel <= '1' when state = b_comp else '0';
	
	-- Enable register Writing only when finishing an R type instruction or I type or when reading from memory
	RF_WE <= '1' when state = comp or state = mem_reg else '0';
	
	-- Write from memory only when reading from it otherwise write from ALU
	RF_WD_Sel <= '1' when state = mem_reg else '0';
	
	-- Not a function of the state
	-- select 2nd registed as RT only on R types no need for state
	RF_B_Sel <= '0' when OP_code = "100000" else '1';
	
	-- Byte operation only when lb or sb in their respective states
	ByteOP <= '1' when (state = mem_read and OP_code = "000011") or (state = mem_write and OP_code = "000111") else '0'; 
	
	-- Write to memory only when in mem_write
	MEM_WE <= '1' when state = mem_write else '0';
	
	-- ALU Function
	--		ADDITION when fetching an instruction / decoding (calculate PC + 4 + SE(Immed))
	-- 		SUBTRACTION when instruction is beq or bne 
	--		Instr(3 downto 0) when R type 
	-- 		ADDITION for immediate addi
	-- 		OR for lui li and ori
	--		nand for nandi
	-- 	All cases are respective fucntions of the current state!
	ALU_Func <= "0000" when (state = i_fetch or state = i_dec or state = mem_addr) else
				"0001" when (state = b_comp and (OP_code = "000000" or OP_code = "000001")) else
				Instr(3 downto 0) when (state = exec) else
				"0000" when state = i_exec and OP_code = "110000" else
				"0011" when state = i_exec and (OP_code = "111000" or OP_code = "111001" or OP_code = "110011") else
				"0101" when state = i_exec and OP_code = "110010" else
				"0000";
				
	
end Behavioral;
