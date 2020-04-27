library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MEMSTAGE_tb is
end;

architecture bench of MEMSTAGE_tb is

  component MEMSTAGE
    Port (
    		 ByteOp : in std_logic;
    		 Mem_WE : in std_logic;
    		 ALU_MEM_Addr : in std_logic_vector(31 downto 0);
    		 MEM_DataIn : in std_logic_vector(31 downto 0);
    		 MEM_DataOut : out std_logic_vector(31 downto 0);
    		 MM_Addr : out std_logic_vector(31 downto 0);
    		 MM_WE : out std_logic;
    		 MM_DataIn : out std_logic_vector(31 downto 0);
    		 MM_DataOut : in std_logic_vector(31 downto 0));
  end component;
  component ram
      Port (
            clk  : in std_logic;
            data_we : in std_logic;
            inst_addr : in std_logic_vector(10 downto 0);
            inst_dout : out std_logic_vector(31 downto 0);
            data_addr : in std_logic_vector(10 downto 0);
            data_din  : in std_logic_vector(31 downto 0);
            data_dout : out std_logic_vector(31 downto 0));
    end component;

  signal clk : std_logic;
  signal ByteOp: std_logic;
  signal Mem_WE: std_logic;
  signal ALU_MEM_Addr: std_logic_vector(31 downto 0);
  signal MEM_DataIn: std_logic_vector(31 downto 0);
  signal MEM_DataOut: std_logic_vector(31 downto 0);
  signal MM_Addr: std_logic_vector(31 downto 0);
  signal MM_WE: std_logic;
  signal MM_DataIn: std_logic_vector(31 downto 0);
  signal MM_DataOut: std_logic_vector(31 downto 0);
  constant clk_period: time := 100 ns;
  signal stop_the_clock : boolean := False;
  
begin

  uut: MEMSTAGE port map ( ByteOp       => ByteOp,
                           Mem_WE       => Mem_WE,
                           ALU_MEM_Addr => ALU_MEM_Addr,
                           MEM_DataIn   => MEM_DataIn,
                           MEM_DataOut  => MEM_DataOut,
                           MM_Addr      => MM_Addr,
                           MM_WE        => MM_WE,
                           MM_DataIn    => MM_DataIn,
                           MM_DataOut   => MM_DataOut );
  ramming: ram port map(
  						clk => clk,
  						data_we => MM_WE,
  						inst_addr => B"00000000000",
  						inst_dout => open,
  						data_addr => MM_Addr(12 downto 2),
  						data_din => MM_DataIn,
  						data_dout => MM_DataOut
  						);

  stimulus: process
  begin
	
	-- Store dead beef into the ram(0) (offsetted by 1000)
	ByteOp <= '0';
	MEM_DataIn <= x"DEAD_BEEF";
	ALU_MEM_Addr <= x"0000_0000";
	Mem_we <= '1';
	wait for clk_period;
	Mem_we <= '0';
	wait for clk_period;
	-- read each byte 
	ByteOp <= '1';
	ALU_MEM_Addr <= x"0000_0000";
	wait for clk_period;
	ALU_MEM_Addr <= x"0000_0001";
	wait for clk_period;
	ALU_MEM_Addr <= x"0000_0002";
	wait for clk_period;
	ALU_MEM_Addr <= x"0000_0003";
	wait for clk_period;
	ByteOp <= '0';
	-- Check weather we jump to the next address
	ALU_MEM_Addr <= x"0000_0004";
	wait for clk_period;
    wait;
  end process;

	clocking: process
      begin
        while not stop_the_clock loop
          clk <= '0', '1' after clk_period / 2;
          wait for clk_period;
        end loop;
        wait;
      end process;

end;