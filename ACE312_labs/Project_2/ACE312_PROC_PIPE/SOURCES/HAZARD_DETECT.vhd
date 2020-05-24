library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity HAZARD_DETECT is
  Port (
  		IDEX_RD: in std_logic_vector(4 downto 0);
  		IDEX_RF_WE : in std_logic;
  		OP_CODE_IDEX : in std_logic_vector(5 downto 0);
  		
  		OP_CODE_IFID: in std_logic_vector(5 downto 0);
  		IFID_RD : in std_logic_vector(4 downto 0);
  		IFID_RS : in std_logic_vector(4 downto 0);
  		IFID_RT : in std_logic_vector(4 downto 0);
		
		
  		PC_LD : out std_logic;
  		-- flush signal
  		ultra_low_guttural_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain : out std_logic;
  		IFID_WE : out std_logic);
end HAZARD_DETECT;

architecture Behavioral of HAZARD_DETECT is
signal MEM_READ : std_logic;
signal cont : std_logic;
begin
	
	-- check whether the instruction is reading from memory
	MEM_READ <= '1' when OP_CODE_IDEX = "000011" or OP_CODE_IDEX = "001111" else '0';	
	-- evaluate contition for stalling is needed to align data for injection
	-- (Load and Use we need to wait until we read from ram)
	cont <= '0' when MEM_READ = '1' and ((IDEX_RD=IFID_RS) or (IDEX_RD=IFID_RT and OP_CODE_IFID = "100000") or (IDEX_RD = IFID_RD and IDEX_RF_WE = '1')) else '1';
	
	-- halt the IFSTAGE (no next instruction)
	PC_LD <= cont;
	-- half the IF_ID (dont write)
	IFID_WE <= cont;
	-- flush the pipe 
	ultra_low_guttural_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain <= not cont;

end Behavioral;
