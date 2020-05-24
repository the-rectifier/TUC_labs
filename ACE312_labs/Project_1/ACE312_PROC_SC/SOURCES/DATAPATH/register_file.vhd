library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_file is
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
end register_file;

--Used python to generate 32 times the needed signals 
--R0's write enable is cut off hardwired to 0
--Clk is used only for writing to the register at the rising edge
--Everything else (decoding, multiplexing) happens asynchrosously
architecture Behavioral of register_file is

signal we_reg_0 : std_logic;
signal we_reg_1 : std_logic;
signal we_reg_2 : std_logic;
signal we_reg_3 : std_logic;
signal we_reg_4 : std_logic;
signal we_reg_5 : std_logic;
signal we_reg_6 : std_logic;
signal we_reg_7 : std_logic;
signal we_reg_8 : std_logic;
signal we_reg_9 : std_logic;
signal we_reg_10 : std_logic;
signal we_reg_11 : std_logic;
signal we_reg_12 : std_logic;
signal we_reg_13 : std_logic;
signal we_reg_14 : std_logic;
signal we_reg_15 : std_logic;
signal we_reg_16 : std_logic;
signal we_reg_17 : std_logic;
signal we_reg_18 : std_logic;
signal we_reg_19 : std_logic;
signal we_reg_20 : std_logic;
signal we_reg_21 : std_logic;
signal we_reg_22 : std_logic;
signal we_reg_23 : std_logic;
signal we_reg_24 : std_logic;
signal we_reg_25 : std_logic;
signal we_reg_26 : std_logic;
signal we_reg_27 : std_logic;
signal we_reg_28 : std_logic;
signal we_reg_29 : std_logic;
signal we_reg_30 : std_logic;
signal we_reg_31 : std_logic;

signal Dout_0 : std_logic_vector(31 downto 0);
signal Dout_01 : std_logic_vector(31 downto 0);
signal Dout_02 : std_logic_vector(31 downto 0);
signal Dout_3 : std_logic_vector(31 downto 0);
signal Dout_4 : std_logic_vector(31 downto 0);
signal Dout_5 : std_logic_vector(31 downto 0);
signal Dout_6 : std_logic_vector(31 downto 0);
signal Dout_7 : std_logic_vector(31 downto 0);
signal Dout_8 : std_logic_vector(31 downto 0);
signal Dout_9 : std_logic_vector(31 downto 0);
signal Dout_10 : std_logic_vector(31 downto 0);
signal Dout_11 : std_logic_vector(31 downto 0);
signal Dout_12 : std_logic_vector(31 downto 0);
signal Dout_13 : std_logic_vector(31 downto 0);
signal Dout_14 : std_logic_vector(31 downto 0);
signal Dout_15 : std_logic_vector(31 downto 0);
signal Dout_16 : std_logic_vector(31 downto 0);
signal Dout_17 : std_logic_vector(31 downto 0);
signal Dout_18 : std_logic_vector(31 downto 0);
signal Dout_19 : std_logic_vector(31 downto 0);
signal Dout_20 : std_logic_vector(31 downto 0);
signal Dout_21 : std_logic_vector(31 downto 0);
signal Dout_22 : std_logic_vector(31 downto 0);
signal Dout_23 : std_logic_vector(31 downto 0);
signal Dout_24 : std_logic_vector(31 downto 0);
signal Dout_25 : std_logic_vector(31 downto 0);
signal Dout_26 : std_logic_vector(31 downto 0);
signal Dout_27 : std_logic_vector(31 downto 0);
signal Dout_28 : std_logic_vector(31 downto 0);
signal Dout_29 : std_logic_vector(31 downto 0);
signal Dout_30 : std_logic_vector(31 downto 0);
signal Dout_31 : std_logic_vector(31 downto 0);

signal dec_out   : std_logic_vector(31 downto 0);

component mux is 
    port(
      mux_in_0 : in std_logic_vector(31 downto 0);
      mux_in_1 : in std_logic_vector(31 downto 0);
      mux_in_2 : in std_logic_vector(31 downto 0);
      mux_in_3 : in std_logic_vector(31 downto 0);
      mux_in_4 : in std_logic_vector(31 downto 0);
      mux_in_5 : in std_logic_vector(31 downto 0);
      mux_in_6 : in std_logic_vector(31 downto 0);
      mux_in_7 : in std_logic_vector(31 downto 0);
      mux_in_8 : in std_logic_vector(31 downto 0);
      mux_in_9 : in std_logic_vector(31 downto 0);
      mux_in_10 : in std_logic_vector(31 downto 0);
      mux_in_11 : in std_logic_vector(31 downto 0);
      mux_in_12 : in std_logic_vector(31 downto 0);
      mux_in_13 : in std_logic_vector(31 downto 0);
      mux_in_14 : in std_logic_vector(31 downto 0);
      mux_in_15 : in std_logic_vector(31 downto 0);
      mux_in_16 : in std_logic_vector(31 downto 0);
      mux_in_17 : in std_logic_vector(31 downto 0);
      mux_in_18 : in std_logic_vector(31 downto 0);
      mux_in_19 : in std_logic_vector(31 downto 0);
      mux_in_20 : in std_logic_vector(31 downto 0);
      mux_in_21 : in std_logic_vector(31 downto 0);
      mux_in_22 : in std_logic_vector(31 downto 0);
      mux_in_23 : in std_logic_vector(31 downto 0);
      mux_in_24 : in std_logic_vector(31 downto 0);
      mux_in_25 : in std_logic_vector(31 downto 0);
      mux_in_26 : in std_logic_vector(31 downto 0);
      mux_in_27 : in std_logic_vector(31 downto 0);
      mux_in_28 : in std_logic_vector(31 downto 0);
      mux_in_29 : in std_logic_vector(31 downto 0);
      mux_in_30 : in std_logic_vector(31 downto 0);
      mux_in_31 : in std_logic_vector(31 downto 0);
      sel : in std_logic_vector(4 downto 0);
      mux_out : out std_logic_vector(31 downto 0)
      );
end component;

component dec is 
    port(
        dec_in : in std_logic_vector(4 downto 0);
        dec_out : out std_logic_vector(31 downto 0)
        );
end component;

component plain_reg is
    port(
        Data_in : in std_logic_vector(31 downto 0);
        WE  : in std_logic;
        Data_out : out std_logic_vector(31 downto 0);
        clk : in std_logic;
        rst : in std_logic 
        );
end component;

begin
    -- decoder
    decoder : dec port map(dec_in => addr_w, dec_out => dec_out);

    -- decorer's output
    we_reg_0 <= '0';
	 --we_reg_0 <= dec_out(0) and we after 2 ns;
    we_reg_1 <= dec_out(1) and we after 2 ns;
    we_reg_2 <= dec_out(2) and we after 2 ns;
    we_reg_3 <= dec_out(3) and we after 2 ns;
    we_reg_4 <= dec_out(4) and we after 2 ns;
    we_reg_5 <= dec_out(5) and we after 2 ns;
    we_reg_6 <= dec_out(6) and we after 2 ns;
    we_reg_7 <= dec_out(7) and we after 2 ns;
    we_reg_8 <= dec_out(8) and we after 2 ns;
    we_reg_9 <= dec_out(9) and we after 2 ns;
    we_reg_10 <= dec_out(10) and we after 2 ns;
    we_reg_11 <= dec_out(11) and we after 2 ns;
    we_reg_12 <= dec_out(12) and we after 2 ns;
    we_reg_13 <= dec_out(13) and we after 2 ns;
    we_reg_14 <= dec_out(14) and we after 2 ns;
    we_reg_15 <= dec_out(15) and we after 2 ns;
    we_reg_16 <= dec_out(16) and we after 2 ns;
    we_reg_17 <= dec_out(17) and we after 2 ns;
    we_reg_18 <= dec_out(18) and we after 2 ns;
    we_reg_19 <= dec_out(19) and we after 2 ns;
    we_reg_20 <= dec_out(20) and we after 2 ns;
    we_reg_21 <= dec_out(21) and we after 2 ns;
    we_reg_22 <= dec_out(22) and we after 2 ns;
    we_reg_23 <= dec_out(23) and we after 2 ns;
    we_reg_24 <= dec_out(24) and we after 2 ns;
    we_reg_25 <= dec_out(25) and we after 2 ns;
    we_reg_26 <= dec_out(26) and we after 2 ns;
    we_reg_27 <= dec_out(27) and we after 2 ns;
    we_reg_28 <= dec_out(28) and we after 2 ns;
    we_reg_29 <= dec_out(29) and we after 2 ns;
    we_reg_30 <= dec_out(30) and we after 2 ns;
    we_reg_31 <= dec_out(31) and we after 2 ns;

    -- 32 registers
    reg_0 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_0, Data_out => Dout_0, Data_in => Din);
    reg_1 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_1, Data_out => Dout_01, Data_in => Din);
    reg_2 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_2, Data_out => Dout_02, Data_in => Din);
    reg_3 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_3, Data_out => Dout_3, Data_in => Din);
    reg_4 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_4, Data_out => Dout_4, Data_in => Din);
    reg_5 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_5, Data_out => Dout_5, Data_in => Din);
    reg_6 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_6, Data_out => Dout_6, Data_in => Din);
    reg_7 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_7, Data_out => Dout_7, Data_in => Din);
    reg_8 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_8, Data_out => Dout_8, Data_in => Din);
    reg_9 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_9, Data_out => Dout_9, Data_in => Din);
    reg_10 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_10, Data_out => Dout_10, Data_in => Din);
    reg_11 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_11, Data_out => Dout_11, Data_in => Din);
    reg_12 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_12, Data_out => Dout_12, Data_in => Din);
    reg_13 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_13, Data_out => Dout_13, Data_in => Din);
    reg_14 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_14, Data_out => Dout_14, Data_in => Din);
    reg_15 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_15, Data_out => Dout_15, Data_in => Din);
    reg_16 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_16, Data_out => Dout_16, Data_in => Din);
    reg_17 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_17, Data_out => Dout_17, Data_in => Din);
    reg_18 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_18, Data_out => Dout_18, Data_in => Din);
    reg_19 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_19, Data_out => Dout_19, Data_in => Din);
    reg_20 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_20, Data_out => Dout_20, Data_in => Din);
    reg_21 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_21, Data_out => Dout_21, Data_in => Din);
    reg_22 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_22, Data_out => Dout_22, Data_in => Din);
    reg_23 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_23, Data_out => Dout_23, Data_in => Din);
    reg_24 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_24, Data_out => Dout_24, Data_in => Din);
    reg_25 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_25, Data_out => Dout_25, Data_in => Din);
    reg_26 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_26, Data_out => Dout_26, Data_in => Din);
    reg_27 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_27, Data_out => Dout_27, Data_in => Din);
    reg_28 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_28, Data_out => Dout_28, Data_in => Din);
    reg_29 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_29, Data_out => Dout_29, Data_in => Din);
    reg_30 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_30, Data_out => Dout_30, Data_in => Din);
    reg_31 : plain_reg port map(clk => clk, rst => rst, WE => we_reg_31, Data_out => Dout_31, Data_in => Din);

    -- 2 muxes
    mux1 : mux port map(
      sel => addr_1,
		
      mux_out => Dout_1,
      mux_in_0 => Dout_0,
      mux_in_1 => Dout_01,
      mux_in_2 => Dout_02,
      mux_in_3 => Dout_3,
      mux_in_4 => Dout_4,
      mux_in_5 => Dout_5,
      mux_in_6 => Dout_6,
      mux_in_7 => Dout_7,
      mux_in_8 => Dout_8,
      mux_in_9 => Dout_9,
      mux_in_10 => Dout_10,
      mux_in_11 => Dout_11,
      mux_in_12 => Dout_12,
      mux_in_13 => Dout_13,
      mux_in_14 => Dout_14,
      mux_in_15 => Dout_15,
      mux_in_16 => Dout_16,
      mux_in_17 => Dout_17,
      mux_in_18 => Dout_18,
      mux_in_19 => Dout_19,
      mux_in_20 => Dout_20,
      mux_in_21 => Dout_21,
      mux_in_22 => Dout_22,
      mux_in_23 => Dout_23,
      mux_in_24 => Dout_24,
      mux_in_25 => Dout_25,
      mux_in_26 => Dout_26,
      mux_in_27 => Dout_27,
      mux_in_28 => Dout_28,
      mux_in_29 => Dout_29,
      mux_in_30 => Dout_30,
      mux_in_31 => Dout_31
		);
 
	mux2 : mux port map(
      sel => addr_2,
		
      mux_out => Dout_2,
		
      mux_in_0 => Dout_0,
      mux_in_1 => Dout_01,
      mux_in_2 => Dout_02,
      mux_in_3 => Dout_3,
      mux_in_4 => Dout_4,
      mux_in_5 => Dout_5,
      mux_in_6 => Dout_6,
      mux_in_7 => Dout_7,
      mux_in_8 => Dout_8,
      mux_in_9 => Dout_9,
      mux_in_10 => Dout_10,
      mux_in_11 => Dout_11,
      mux_in_12 => Dout_12,
      mux_in_13 => Dout_13,
      mux_in_14 => Dout_14,
      mux_in_15 => Dout_15,
      mux_in_16 => Dout_16,
      mux_in_17 => Dout_17,
      mux_in_18 => Dout_18,
      mux_in_19 => Dout_19,
      mux_in_20 => Dout_20,
      mux_in_21 => Dout_21,
      mux_in_22 => Dout_22,
      mux_in_23 => Dout_23,
      mux_in_24 => Dout_24,
      mux_in_25 => Dout_25,
      mux_in_26 => Dout_26,
      mux_in_27 => Dout_27,
      mux_in_28 => Dout_28,
      mux_in_29 => Dout_29,
      mux_in_30 => Dout_30,
      mux_in_31 => Dout_31
		);
		
		--Data_out0 <= "0";
		
		
end Behavioral;
