-- CHANGES:
-- r2 is selected automatically from the module
-- also immed get processed here rather than relying on a control signal 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DECSTAGE is
	Port (
		Clk : in std_logic;
		Rst : in std_logic;
		
		-- Datapath inputs
		Instr : in std_logic_vector(31 downto 0);
		RF_WE : in std_logic;
		Data : in std_logic_vector(31 downto 0);
		RD_in : in std_logic_vector(4 downto 0);
		-- Datapath outputs
		
		Immed  : out std_logic_vector(31 downto 0);
		RF_A : out std_logic_vector(31 downto 0);
		RF_B : out std_logic_vector(31 downto 0)
--		RD_OUT : out std_logic_vector(4 downto 0);
--		RS_OUT : out std_logic_vector(4 downto 0);
--		RT_OUT : out std_logic_vector(4 downto 0)
		);
end DECSTAGE;

architecture Behavioral of DECSTAGE is 

component register_file is
  Port (
        clk     : in std_logic;
        rst     : in std_logic;
        we      : in std_logic;
        addr_1  : in std_logic_vector(4 downto 0);
        addr_2  : in std_logic_vector(4 downto 0);
        addr_w  : in std_logic_vector(4 downto 0);
        Dout_1  : out std_logic_vector(31 downto 0);
        Dout_2  : out std_logic_vector(31 downto 0);
        Din     : in std_logic_vector(31 downto 0)
        );
end component;

component immed_handlr is Port(  
		   immed : in STD_LOGIC_vector(15 downto 0);
           output : out STD_LOGIC_vector(31 downto 0);
           func : in std_logic_vector(1 downto 0));
end component;

signal rs : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal r2 : std_logic_vector(4 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal OP_code : std_logic_vector(5 downto 0);
signal ImmExt : std_logic_vector(1 downto 0);

begin
rs <= Instr(25 downto 21);
OP_code <= Instr(31 downto 26);
rt <= Instr(15 downto 11);
--rd_out <= Instr(20 downto 16);
--rs_out <= rs;
--rt_out <= rt;
imm <= Instr(15 downto 0);


-- RF_B_Sel and ImmExt deprecated and moved from control here. 
-- Indepentad of state 
r2 <= rt when OP_Code = "100000" else Instr(20 downto 16);

ImmExt <= "10" when (Op_code = "110010" or Op_code = "110011") else
			"01" when (Op_code = "000000" or Op_code = "000001" or Op_code="111111") else
			"00" when (Op_code = "111000" or Op_code = "110000" or Op_code = "000011" or Op_code = "011111" or Op_code = "001111" or Op_code = "000111" ) else
			"11" when (Op_code = "111001") else
			"10";

handle_immed : immed_handlr port map(
							immed => imm,
							func => ImmExt,
							output => Immed);

RF : register_file port map(
						clk => clk,
						rst => rst,
						we => RF_WE,
						addr_1 => rs,
						addr_2 => r2,
						addr_w => rd_in,
						Din => Data,
						Dout_1 => RF_A,
						Dout_2 => RF_B);

end Behavioral;
