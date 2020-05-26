library ieee;
use ieee.std_logic_1164.all;

entity tb_FWD_UNIT is
end tb_FWD_UNIT;

architecture tb of tb_FWD_UNIT is

    component FWD_UNIT
        port (OP_CODE_IDEX    : in std_logic_vector (5 downto 0);
              IDEX_RD         : in std_logic_vector (4 downto 0);
              IDEX_RT         : in std_logic_vector (4 downto 0);
              IDEX_RS         : in std_logic_vector (4 downto 0);
              IDEX_MEM_WE     : in std_logic;
              OP_CODE_IFID    : in std_logic_vector (5 downto 0);
              IFID_RD         : in std_logic_vector (4 downto 0);
              IFID_RS         : in std_logic_vector (4 downto 0);
              IFID_RT         : in std_logic_vector (4 downto 0);
              EXMEM_RD        : in std_logic_vector (4 downto 0);
              MEMWB_RD        : in std_logic_vector (4 downto 0);
              EXMEM_RF_WE     : in std_logic;
              MEMWB_RF_WE     : in std_logic;
              INJECT_A_AFTER  : out std_logic_vector (1 downto 0);
              INJECT_B_AFTER  : out std_logic_vector (1 downto 0);
              INJECT_A_BEFORE : out std_logic;
              INJECT_B_BEFORE : out std_logic);
    end component;

    signal OP_CODE_IDEX    : std_logic_vector (5 downto 0);
    signal IDEX_RD         : std_logic_vector (4 downto 0);
    signal IDEX_RT         : std_logic_vector (4 downto 0);
    signal IDEX_RS         : std_logic_vector (4 downto 0);
    signal IDEX_MEM_WE     : std_logic;
    signal OP_CODE_IFID    : std_logic_vector (5 downto 0);
    signal IFID_RD         : std_logic_vector (4 downto 0);
    signal IFID_RS         : std_logic_vector (4 downto 0);
    signal IFID_RT         : std_logic_vector (4 downto 0);
    signal EXMEM_RD        : std_logic_vector (4 downto 0);
    signal MEMWB_RD        : std_logic_vector (4 downto 0);
    signal EXMEM_RF_WE     : std_logic;
    signal MEMWB_RF_WE     : std_logic;
    signal INJECT_A_AFTER  : std_logic_vector (1 downto 0);
    signal INJECT_B_AFTER  : std_logic_vector (1 downto 0);
    signal INJECT_A_BEFORE : std_logic;
    signal INJECT_B_BEFORE : std_logic;

begin

    dut : FWD_UNIT
    port map (OP_CODE_IDEX    => OP_CODE_IDEX,
              IDEX_RD         => IDEX_RD,
              IDEX_RT         => IDEX_RT,
              IDEX_RS         => IDEX_RS,
              IDEX_MEM_WE     => IDEX_MEM_WE,
              OP_CODE_IFID    => OP_CODE_IFID,
              IFID_RD         => IFID_RD,
              IFID_RS         => IFID_RS,
              IFID_RT         => IFID_RT,
              EXMEM_RD        => EXMEM_RD,
              MEMWB_RD        => MEMWB_RD,
              EXMEM_RF_WE     => EXMEM_RF_WE,
              MEMWB_RF_WE     => MEMWB_RF_WE,
              INJECT_A_AFTER  => INJECT_A_AFTER,
              INJECT_B_AFTER  => INJECT_B_AFTER,
              INJECT_A_BEFORE => INJECT_A_BEFORE,
              INJECT_B_BEFORE => INJECT_B_BEFORE);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        OP_CODE_IDEX <= (others => '0');
        IDEX_RD <= (others => '0');
        IDEX_RT <= (others => '0');
        IDEX_RS <= (others => '0');
        IDEX_MEM_WE <= '0';
        OP_CODE_IFID <= (others => '0');
        IFID_RD <= (others => '0');
        IFID_RS <= (others => '0');
        IFID_RT <= (others => '0');
        EXMEM_RD <= (others => '0');
        MEMWB_RD <= (others => '0');
        EXMEM_RF_WE <= '0';
        MEMWB_RF_WE <= '0';
        wait for 10 ns;
        
--         check inject A after
        EXMEM_RF_WE <= '1';
        EXMEM_RD <= "01010";
        IDEX_RS <= "01010";
        wait for 10 ns;
		EXMEM_RF_WE <= '0';
		MEMWB_RF_WE <= '1';
        MEMWB_RD <= "01010";
        IDEX_RT <= "01010";
        wait for 10 ns;
		MEMWB_RD <= "00010";
		wait for 10 ns;
		
		-- check inject A before
		MEMWB_RF_WE <= '1';
		MEMWB_RD <= "01010";
		IFID_RS <= "01010";
		wait for 10 ns;
		IFID_RS <= "00010";
		wait for 10 ns;
		
		-- check inject b after
--		 01
		exmem_rf_we <= '1';
		exmem_rd <= "00001";
		memwb_rf_we <= '0';
		memwb_rd <= "11111";
		idex_rt <= "00001";
		op_code_idex <= "100000";
		wait for 10 ns;
		idex_rt <= "00101";
		op_code_idex <= "000000";
		idex_mem_we <= '1';
		idex_rd <= "00001";
		wait for 10 ns;
		-- 10
		exmem_rf_we <= '0';
		exmem_rd <= "00011";
		memwb_rf_we <= '1';
		memwb_rd <= "00001";
		idex_rt <= "00001";
		op_code_idex <= "100000";
		wait for 10 ns;
		idex_rt <= "00101";
		op_code_idex <= "000000";
		idex_mem_we <= '1';
		idex_rd <= "00001";
		wait for 10 ns;
		-- 00
		exmem_rf_we <= '0';
		exmem_rd <= "00001";
		memwb_rf_we <= '0';
		memwb_rd <= "11111";
		idex_rt <= "00101";
		op_code_idex <= "100000";
		wait for 10 ns;
		idex_rt <= "10101";
		op_code_idex <= "000000";
		idex_mem_we <= '1';
		idex_rd <= "00001";
		wait for 10 ns;
		
		-- check inject b before
		-- 1
		memwb_RF_we <= '1';
		memwb_RD <= "00001";
		ifid_rt <= "00001";
		op_code_ifid <= "100000";
		wait for 10 ns;
		OP_CODE_IFID<="000111";
		memwb_rf_we <= '1';
		ifid_rd <= "00001";
		wait for 10 ns;
		-- 0
		ifid_rd <= "00101";
		wait for 10 ns;
		ifid_rt <= "01111";
		wait for 10 ns;
        wait;
    end process;

end tb;