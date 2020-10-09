library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MEMSTAGE is
  Port (
  		-- Datapath inputs
  		 ByteOp : in std_logic;
  		 Mem_WE : in std_logic;
  		 
  		 ALU_MEM_Addr : in std_logic_vector(31 downto 0);
  		 MEM_DataIn : in std_logic_vector(31 downto 0);
  		 -- Datapath outputs
  		 MEM_DataOut : out std_logic_vector(31 downto 0);
  		 
  		 
  		 -- Module crap
  		 MM_Addr : out std_logic_vector(31 downto 0);
  		 MM_WE : out std_logic;
  		 MM_DataIn : out std_logic_vector(31 downto 0);
  		 MM_DataOut : in std_logic_vector(31 downto 0));
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is
signal byte : std_logic_vector(1 downto 0);
begin

	byte <= ALU_MEM_Addr(1 downto 0);
	MM_Addr <= std_logic_vector(unsigned(ALU_MEM_Addr) + 4096);
	MM_WE <= MEM_WE;
	
	--Write Byte or word depending
	--While storing a byte the byte is stores an unsigned Byte
	--From ISA: MEM[RF[rs]+SignExtend(Immed)] <-- ZeroFill(31 downto 8) & (7 downto 0)RF[rd]
	MM_DataIn <= (31 downto 8 => '0') & MEM_DataIn(7 downto 0) when (ByteOP = '1') else 
				MEM_DataIn;
	
	--Same Applies for reading a byte
	--From ISA: RF[rd] <-- ZeroFill(31 downto 8) & (7 downto 0)MEM[RF[rs] + SignExtend(Immed)]
	MEM_DataOut <= (31 downto 8 => '0') & MM_DataOut(7 downto 0) when (ByteOp = '1' and byte = "00") else
					(31 downto 8 => '0') & MM_DataOut(15 downto 8) when (ByteOp = '1' and byte = "01") else
					(31 downto 8 => '0') & MM_DataOut(23 downto 16) when (ByteOp = '1' and byte = "10") else
					(31 downto 8 => '0') & MM_DataOut(31 downto 24) when (ByteOp = '1' and byte = "11") else
					MM_DataOut;
end Behavioral;
