library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DATAPATH_tb is
end;

architecture bench of DATAPATH_tb is

  component DATAPATH
    Port ( 
    		Clk : in std_logic;
    		Rst : in std_logic;
    		ByteOp: in std_logic;
    		Mem_We: in std_logic;
    		MM_Dout : in std_logic_vector(31 downto 0);
    		MM_Addr: out std_logic_vector(31 downto 0);
    		MM_We: out std_logic;
    		MM_Din : out std_logic_vector(31 downto 0);
    		ALU_B_sel : in std_logic;
    		ALU_Func : in std_logic_vector(3 downto 0);
    		ALU_z : out std_logic;
    		PC_Sel : in std_logic;
    		PC_LD : in std_logic;
    		PC : out std_logic_vector(31 downto 0);
    		RF_WE: in std_logic;
    		RF_WD_Sel : in std_logic;
    		RF_B_Sel : in std_logic;
    		ImmExt : in std_logic_vector(1 downto 0);
    		Instr : in std_logic_vector(31 downto 0));
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
 
  signal Clk: std_logic;
  signal Rst: std_logic;
  signal ByteOp: std_logic;
  signal Mem_We: std_logic;
  signal MM_Dout: std_logic_vector(31 downto 0);
  signal MM_Addr: std_logic_vector(31 downto 0);
  signal MM_We: std_logic;
  signal MM_Din: std_logic_vector(31 downto 0);
  signal ALU_B_sel: std_logic;
  signal ALU_Func: std_logic_vector(3 downto 0);
  signal ALU_z: std_logic;
  signal PC_Sel: std_logic;
  signal PC_LD: std_logic;
  signal PC: std_logic_vector(31 downto 0);
  signal RF_WE: std_logic;
  signal RF_WD_Sel: std_logic;
  signal RF_B_Sel: std_logic;
  signal ImmExt: std_logic_vector(1 downto 0);
  signal Instr: std_logic_vector(31 downto 0);
  signal stop_the_clock : boolean := False;
  constant clk_period : time := 100 ns;

begin

  uut: DATAPATH port map ( Clk       => Clk,
                           Rst       => Rst,
                           ByteOp    => ByteOp,
                           Mem_We    => Mem_We,
                           MM_Dout   => MM_Dout,
                           MM_Addr   => MM_Addr,
                           MM_We     => MM_We,
                           MM_Din    => MM_Din,
                           ALU_B_sel => ALU_B_sel,
                           ALU_Func  => ALU_Func,
                           ALU_z     => ALU_z,
                           PC_Sel    => PC_Sel,
                           PC_LD     => PC_LD,
                           PC        => PC,
                           RF_WE     => RF_WE,
                           RF_WD_Sel => RF_WD_Sel,
                           RF_B_Sel  => RF_B_Sel,
                           ImmExt    => ImmExt,
                           Instr     => Instr );
   rammit : ram port map(Clk => Clk,
   						data_we => MM_We,
   						inst_addr => PC(12 downto 2),
   						inst_dout => Instr,
   						data_addr => MM_Addr(12 downto 2),
   						data_din => MM_Din,
   						data_dout => MM_Dout);

  stimulus: process
  begin
  -- USE CHARIS_4 FOR THIS TB!!
  -- The Control Signals Are derived specifically for that rom!
  -- wont test every instruction in the ISE
  -- testing core instructions to siumulate 
  -- the different paths data can flow thgrough 
  -- the DATAPATH
  -- By acting as the control module the instructions 
  -- would complete normaly
  	PC_LD <= '1';
  	ByteOp <= '0';
  	Mem_We <= '0';
  	ALU_B_Sel <= '0';
  	ALU_Func <= "0000";
  	PC_Sel <= '0';
  	RF_WE <= '0';
  	RF_WD_Sel <= '0';
  	RF_B_Sel <= '0';
  	ImmExt <= "00";
  	wait for clk_period;
  	
  	rst <= '0';
  	wait for clk_period;
  	rst <= '1';
--  We acting control
--  li r1, 0xa
	ALU_Func <= "0011";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '1';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '0';
	MEM_WE    <= '0';
  	wait for clk_period;
--  add r4, r2, r1
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '0';
	RF_WE     <= '1';
	ImmExt    <= "10";
	ALU_B_Sel <= '0';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  lui r4, 0xffff
	ALU_Func <= "0011";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '1';
	ImmExt    <= "11";
	ALU_B_Sel <= '1';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  addi r4, r1, 0xfff6
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '1';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  sw r1, 0x2(r2)
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '0';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '0';
	MEM_WE    <= '1';
	wait for clk_period;
--  lw r2, 0x2(r2)
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '1';
	RF_B_Sel  <= '1';
	RF_WE     <= '1';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  sb r1, 0x0(r0)
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '0';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '1';
	MEM_WE    <= '1';
	wait for clk_period;
--  lb r2, 0x0(r0)
	ALU_Func <= "0000";
	PC_Sel   <= '0';
	RF_WD_Sel <= '1';
	RF_B_Sel  <= '1';
	RF_WE     <= '1';
	ImmExt    <= "00";
	ALU_B_Sel <= '1';
	ByteOp    <= '1';
	MEM_WE    <= '0';
	wait for clk_period;
--  beq r0, r0, 0x4
	ALU_Func <= "0001";
	PC_Sel   <= '1';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '0';
	ImmExt    <= "01";
	ALU_B_Sel <= '0';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  b 0x1
	ALU_Func <= "0000";
	PC_Sel   <= '1';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '0';
	ImmExt    <= "01";
	ALU_B_Sel <= '0';
	ByteOp    <= '0';
	MEM_WE    <= '0';
	wait for clk_period;
--  bne r0, r2, 0xfffe
  	ALU_Func <= "0001";
	PC_Sel   <= '1';
	RF_WD_Sel <= '0';
	RF_B_Sel  <= '1';
	RF_WE     <= '0';
	ImmExt    <= "01";
	ALU_B_Sel <= '0';
	ByteOp    <= '0';
	MEM_WE    <= '0';
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