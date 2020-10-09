library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity HAZARD_DETECT_tb is
end;

architecture bench of HAZARD_DETECT_tb is

  component HAZARD_DETECT
    Port (
    		IDEX_RD: in std_logic_vector(4 downto 0);
    		IDEX_RF_WE : in std_logic;
    		OP_CODE_IDEX : in std_logic_vector(5 downto 0);
    		OP_CODE_IFID: in std_logic_vector(5 downto 0);
    		IFID_RD : in std_logic_vector(4 downto 0);
    		IFID_RS : in std_logic_vector(4 downto 0);
    		IFID_RT : in std_logic_vector(4 downto 0);
    		PC_LD : out std_logic;
    		ultra_low_guttal_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain : out std_logic;
    		IFID_WE : out std_logic);
  end component;

  signal IDEX_RD: std_logic_vector(4 downto 0);
  signal IDEX_RF_WE: std_logic;
  signal OP_CODE_IDEX: std_logic_vector(5 downto 0);
  signal OP_CODE_IFID: std_logic_vector(5 downto 0);
  signal IFID_RD: std_logic_vector(4 downto 0);
  signal IFID_RS: std_logic_vector(4 downto 0);
  signal IFID_RT: std_logic_vector(4 downto 0);
  signal PC_LD: std_logic;
  signal ultra_low_guttal_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain: std_logic;
  signal IFID_WE: std_logic;

begin

  uut: HAZARD_DETECT port map ( IDEX_RD                                                                                                                                           => IDEX_RD,
                                IDEX_RF_WE                                                                                                                                        => IDEX_RF_WE,
                                OP_CODE_IDEX                                                                                                                                      => OP_CODE_IDEX,
                                OP_CODE_IFID                                                                                                                                      => OP_CODE_IFID,
                                IFID_RD                                                                                                                                           => IFID_RD,
                                IFID_RS                                                                                                                                           => IFID_RS,
                                IFID_RT                                                                                                                                           => IFID_RT,
                                PC_LD                                                                                                                                             => PC_LD,
                                ultra_low_guttal_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain => ultra_low_guttal_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain,
                                IFID_WE                                                                                                                                           => IFID_WE );

  stimulus: process
  begin
  
  	-- stall -> PC_LD = IFID_WE = 0 = not flush
    OP_CODE_IDEX <= "000011";
    
    IDEX_RD <= "00001";
    IFID_RS <= "00001";
    wait for 10 ns;
    IFID_RT <= "00001";
    OP_CODE_IFID <= "100000";
    wait for 10 ns;
    IFID_RD <= "00001";
    IDEX_RF_WE <= '1';
    wait for 10 ns;
	-- normal -> PC_LD = IFID_WE = 1 = not flush
	OP_CODE_IDEX <= "101010";
    IDEX_RD <= "00011";
    IFID_RS <= "00001";
    wait for 10 ns;
    IFID_RT <= "10001";
    OP_CODE_IFID <= "111000";
    wait for 10 ns;
    IFID_RD <= "01011";
    IDEX_RF_WE <= '1';
    wait for 10 ns;
    wait;
  end process;


end;