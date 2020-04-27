library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
            A    : in  std_logic_vector(31 downto 0);
            B   : in  std_logic_vector(31 downto 0);
            OP  : in std_logic_vector(3 downto 0);
            alu_out : out std_logic_vector(31 downto 0);
            zero : out std_logic;
            cout : out std_logic;
            ovf  : out std_logic
            );
end ALU;

architecture Behavioral of ALU is
signal temp_res_add : std_logic_vector(32 downto 0):= B"0_0000_0000_0000_0000_0000_0000_0000_0000";
signal temp_res_sub : std_logic_vector(32 downto 0):= B"0_0000_0000_0000_0000_0000_0000_0000_0000";
signal temp_out : std_logic_vector(31 downto 0) := X"0000_0000";
begin

-- no sign extention so the 33rd bit is the carry out
-- cout is the carry in for the MSB of temp_res

	temp_res_add <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
	temp_res_sub <= std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
				
	ovf <= '1' when (A(31) = B(31) and A(31) /= temp_res_add(31) and OP = "0000") or
					(A(31) /= B(31) and A(31) /= temp_res_sub(31) and OP = "0001")
					else '0';
	
	temp_out <= temp_res_add(31 downto 0) when OP = "0000" else
				temp_res_sub(31 downto 0) when OP = "0001" else
				A and B when OP = "0010" else
				A or B when OP = "0011" else
				not A when OP = "0100" else
				A nand B when OP = "0101" else
				A nor B when OP = "0110" else
				A(31) & A(31 downto 1) when OP = "1000" else
				'0' & A(31 downto 1) when OP = "1001" else
				A(30 downto 0) & '0' when OP = "1010" else
				A(30 downto 0) & A(31) when OP = "1100" else
				A(0) & A(31 downto 1) when OP = "1101";
						
	zero <= '1' when unsigned(temp_out) = 0 else '0';
	alu_out <= temp_out after 10 ns;
	
	cout <= temp_res_add(32) when OP = "0000" else
			temp_res_sub(32) when OP = "0001";
			
end Behavioral;
