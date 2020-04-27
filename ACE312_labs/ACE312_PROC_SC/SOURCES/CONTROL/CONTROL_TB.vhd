library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CONTROL_tb is
end;

architecture bench of CONTROL_tb is

  component CONTROL
  	Port (
  		Instr : in std_logic_vector(31 downto 0);
  		ALU_z : in std_logic;
  		ALU_Func: out std_logic_vector(3 downto 0);
  		PC_Sel : out std_logic;
  		RF_WD_Sel: out std_logic;
  		RF_B_Sel : out std_logic;
  		RF_WE : out std_logic;
  		ImmExt : out std_logic_vector(1 downto 0);
  		ALU_B_Sel : out std_logic;
  		ByteOp : out std_logic;
  		MEM_WE : out std_logic);
  end component;

  signal Instr: std_logic_vector(31 downto 0);
  signal ALU_z: std_logic;
  signal ALU_Func: std_logic_vector(3 downto 0);
  signal PC_Sel: std_logic;
  signal RF_WD_Sel: std_logic;
  signal RF_B_Sel: std_logic;
  signal RF_WE: std_logic;
  signal ImmExt: std_logic_vector(1 downto 0);
  signal ALU_B_Sel: std_logic;
  signal ByteOp: std_logic;
  signal MEM_WE: std_logic;

begin

  uut: CONTROL port map ( Instr     => Instr,
                          ALU_z     => ALU_z,
                          ALU_Func  => ALU_Func,
                          PC_Sel    => PC_Sel,
                          RF_WD_Sel => RF_WD_Sel,
                          RF_B_Sel  => RF_B_Sel,
                          RF_WE     => RF_WE,
                          ImmExt    => ImmExt,
                          ALU_B_Sel => ALU_B_Sel,
                          ByteOp    => ByteOp,
                          MEM_WE    => MEM_WE );

  stimulus: process
  begin
	Instr <= x"80440830";
--	add r4, r2, r1
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
	Instr <= x"80241031";
--	sub r4, r1, r2
--	Expecting:
--	ALU_Func = 0001
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80840032";
--  and r4, r4, r0
--	Expecting:
--	ALU_Func = 0010
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80040833";
--  or r4, r0, r1
--	Expecting:
--	ALU_Func = 0011
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80840034";
--  nor r4, r4
--	Expecting:
--	ALU_Func = 0100
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80241835";
--  nand r4, r1, r3
--	Expecting:
--	ALU_Func = 0101
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80242036";
--  nor r4, r1, r4
--	Expecting:
--	ALU_Func = 0110
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80640038";
--  sra r4, r3
--	Expecting:
--	ALU_Func = 1000
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"80640039";
--  srl r4, r3
--	Expecting:
--	ALU_Func = 1001
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"8064003a";
--  sll r4, r3
--	Expecting:
--	ALU_Func = 1010
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"8064003c";
--  rol r4, r3
--	Expecting:
--	ALU_Func = 1100
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"8064003d";
-- ror r4, r3
--	Expecting:
--	ALU_Func = 1101
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 0
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"e001000a";
--  li r1, 0xa
--	Expecting:
--	ALU_Func = 0011
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"e404ffff";
--  lui r4, 0xffff
--	Expecting:
--	ALU_Func = 0011
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 11
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"c024fff6";
--  addi r4, r1, 0xfff6
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"c8240000";
--  nandi r4, r1, 0x0
--	Expecting:
--	ALU_Func = 0101
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"cc240000";
--  ori r4, r1, 0x0
--	Expecting:
--	ALU_Func = 0011
--	PC_Sel   = 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 10
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"fc000001";
--  b 0x1
--	Expecting:
--	ALU_Func = 1111 aka dont care
--	PC_Sel   = 1
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 0
--	ImmExt    = 01
--	ALU_B_Sel = 0 (but don't care, ALU doenst extend the immed anw)
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"00000004";
    ALU_z <= '1';
--  beq r0, r0, 0x4
--	Expecting:
--	ALU_Func = 0001
--	PC_Sel   = 1 if ALU_Z = 1 else 0
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 0
--	ImmExt    = 01
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
	wait for 10 ns;
    Instr <= x"0440fffe";
    ALU_z <= '0';
--  bne r0, r2, 0xfffe
--	Expecting:
--	ALU_Func = 0001
--	PC_Sel   = 0 if ALU_Z = 1 else 1
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 0
--	ImmExt    = 01
--	ALU_B_Sel = 0
--	ByteOp    = 0
--	MEM_WE    = 0
    wait for 10 ns;
    Instr <= x"1c010000";
--  sb r1, 0x0(r0)
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0 
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 0
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 1
--	MEM_WE    = 1
    wait for 10 ns;
    Instr <= x"0c020000";
--  lb r2, 0x0(r0)
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0 
--	RF_WD_Sel = 1
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 1
--	MEM_WE    = 0
    wait for 10 ns;
    Instr <= x"3c4100ff";
--  lw r1, 0xff(r2)
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0 
--	RF_WD_Sel = 1
--	RF_B_Sel  = 1
--	RF_WE     = 1
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 0
    wait for 10 ns;
    Instr <= x"7c4200ff";
--  sw r2, 0xff(r0)
--	Expecting:
--	ALU_Func = 0000
--	PC_Sel   = 0 
--	RF_WD_Sel = 0
--	RF_B_Sel  = 1
--	RF_WE     = 0
--	ImmExt    = 00
--	ALU_B_Sel = 1
--	ByteOp    = 0
--	MEM_WE    = 1
    wait for 10 ns;
	wait;
	end process;
end;