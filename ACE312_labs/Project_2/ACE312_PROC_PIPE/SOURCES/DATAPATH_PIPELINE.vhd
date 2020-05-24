library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity DATAPATH_PIPELINE is
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		flush : out std_logic;
		WB_flags : in std_logic_vector(1 downto 0); -- mapped
		MEM_flags : in std_logic_vector(1 downto 0); -- mapped
		Alu_flags: in std_logic_vector(4 downto 0); -- mapped
		Instr : in std_logic_vector(31 downto 0); -- mapped 
		Instr_control : out std_logic_vector(31 downto 0);
		Instr_addr : out std_logic_vector(31 downto 0); -- mapped
		MM_Addr : out std_logic_vector(31 downto 0);
		MM_WE : out std_logic;
		MM_DataIn : out std_logic_vector(31 downto 0);
		MM_DataOut : in std_logic_vector(31 downto 0));
end DATAPATH_PIPELINE;

architecture Behavioral of DATAPATH_PIPELINE is

component IF_ID is port(
		clk : in std_logic;
		rst : in std_logic;
		
		IFID_WE : in std_logic;
		Instr_in : in std_logic_vector(31 downto 0);
		Instr_out : out std_logic_vector(31 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0);
		RS_OUT : out std_logic_vector(4 downto 0);
		RT_OUT : out std_logic_vector(4 downto 0));
end component;

signal Instr_IFID : std_logic_vector(31 downto 0);
signal RD_IFID : std_logic_vector(4 downto 0);
signal RT_IFID : std_logic_vector(4 downto 0);
signal RS_IFID : std_logic_vector(4 downto 0);
signal IFID_WE : std_logic;

component IFSTAGE is Port(  
	 		PC_LD : in std_logic;
	 		clk	: in std_logic;
	 		rst : in std_logic;
	 		PC : out std_logic_vector(31 downto 0));
end component;
signal PC_LD : std_logic;
component ID_EX is
	Port(
		clk : in std_logic;
		rst : in std_logic;
		-- FLAGS
		WB_FLAGS_IN : in std_logic_vector(1 downto 0);
		WB_FLAGS_OUT : out std_logic_vector(1 downto 0);
		
		MEM_FLAGS_IN : in std_logic_vector(1 downto 0);
		MEM_FLAGS_OUT : out std_logic_vector(1 downto 0);
		
		ALU_FLAGS_IN : in std_logic_vector(4 downto 0);
		ALU_Func : out std_logic_vector(3 downto 0);
		ALU_B_Sel : out std_logic;
		
		-- DATA
		
		OP_CODE_IN : in std_logic_vector(5 downto 0);
		OP_CODE_OUT : out std_logic_vector(5 downto 0);
		
		RF_A_IN : in std_logic_vector(31 downto 0);
		RF_B_IN : in std_logic_vector(31 downto 0);
		
		RF_A_OUT : out std_logic_vector(31 downto 0);
		RF_B_OUT : out std_logic_vector(31 downto 0);
		
		IMMED_IN : in std_logic_vector(31 downto 0);
		IMMED_OUT : out std_logic_vector(31 downto 0);
		
		REGS_IN : in std_logic_vector(14 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0);
		RS_OUT : out std_logic_vector(4 downto 0);
		RT_OUT : out std_logic_vector(4 downto 0));
end component;

signal RF_A_IDEX: std_logic_vector(31 downto 0);
signal RF_B_IDEX: std_logic_vector(31 downto 0);
signal Immed_IDEX: std_logic_vector(31 downto 0);
signal WB_FLAGS_IDEX : std_logic_vector(1 downto 0);
signal MEM_FLAGS_IDEX : std_logic_vector(1 downto 0);
signal ALU_Func : std_logic_vector(3 downto 0);
signal ALU_B_Sel : std_logic;
signal RD_IDEX: std_logic_vector(4 downto 0);
signal RS_IDEX: std_logic_vector(4 downto 0);
signal RT_IDEX: std_logic_vector(4 downto 0);
signal OP_CODE_IDEX : std_logic_vector(5 downto 0);
component DECSTAGE is Port (
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
end component;

signal RF_WE : std_logic;
signal DATA_W: std_logic_vector(31 downto 0);
signal RD_IN : std_logic_vector(4 downto 0);
signal Immed_DEC: std_logic_vector(31 downto 0);
signal RF_A_DEC : std_logic_vector(31 downto 0);
signal RF_B_DEC : std_logic_vector(31 downto 0);
--signal RD_DEC : std_logic_vector(4 downto 0);
--signal RS_DEC : std_logic_vector(4 downto 0);
--signal RT_DEC : std_logic_vector(4 downto 0);
signal REGS_IFID : std_logic_vector(14 downto 0);

component EXSTAGE is
	Port (
			-- Datapath Inputs
			RF_A : in std_logic_vector(31 downto 0);
			RF_B : in std_logic_vector(31 downto 0);
			Immed  : in std_logic_vector(31 downto 0);
			
			ALU_B_Sel : in std_logic;
			ALU_Func : in std_logic_vector(3 downto 0);
			
			-- Datapath Outputs
			ALU_OUT : out std_logic_vector(31 downto 0);
			ALU_z : out std_logic);
end component;

signal ALU_OUT_EX: std_logic_vector(31 downto 0);
signal ALU_Z_EX: std_logic;
signal DATA_EX: std_logic_vector(31 downto 0);

component EX_MEM is
	Port ( 
		clk : in std_logic;
		rst : in std_logic;
		
		-- WB_flags(0) = RF_WE
		-- WB_flags(1) = RF_WD_Sel
		WB_flags_in : in std_logic_vector(1 downto 0);
		WB_flags_out : out std_logic_vector(1 downto 0);
		
		-- MEM_flags(0) = MEM_WE
		-- MEM_flags(1) = ByteOP
		MEM_flags_in : in std_logic_vector(1 downto 0);
		
		MEM_WE : out std_logic;
		ByteOP : out std_logic;
		
		ALU_z_in : in std_logic;
		ALU_z_out : out std_logic;
		
		ALU_OUT_in : in std_logic_vector(31 downto 0);
		ALU_OUT_out : out std_logic_vector(31 downto 0);
		
		DATA_in : in std_logic_vector(31 downto 0);
		DATA_out : out std_logic_vector(31 downto 0);
		
		RD_IN : in std_logic_vector(4 downto 0);
		RD_OUT : out std_logic_vector(4 downto 0));
end component;

signal WB_FLAGS_EXMEM : std_logic_vector(1 downto 0);
signal MEM_WE : std_logic;
signal ByteOP : std_logic;
signal ALU_Z_EXMEM : std_logic;
signal ALU_OUT_EXMEM : std_logic_vector(31 downto 0);
signal DATA_EXMEM : std_logic_vector(31 downto 0);
signal RD_EXMEM : std_logic_vector(4 downto 0);

component MEMSTAGE is
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
  		 
end component;  		 

signal MEM_DATAOUT_MEM : std_logic_vector(31 downto 0);

component MEM_WB is port(
			clk : in std_logic; 
			rst : in std_logic;
			
			-- WB_flags(0) = RF_WE
			-- WB_flags(1) = RF_WD_Sel
			WB_flags_in : in std_logic_vector(1 downto 0);
			
			RF_WE : out std_logic;
			RF_WD_Sel : out std_logic;
			
			MEM_DATA_in : in std_logic_vector(31 downto 0);
			MEM_DATA_out : out std_logic_vector(31 downto 0);
			
			R_DATA_in : in std_logic_vector(31 downto 0);
			R_DATA_out : out std_logic_vector(31 downto 0);
			
			RD_IN : in std_logic_vector(4 downto 0);
			RD_out : out std_logic_vector(4 downto 0));
end component;

signal RF_WD_Sel : std_logic;
signal MEM_DATA_MEMWB : std_logic_vector(31 downto 0);
signal R_DATA_MEMWB : std_logic_vector(31 downto 0);		
signal RD_MEMWB : std_logic_vector(4 downto 0);	

component mux_3_1 is Port ( 
		   sel: in std_logic_vector(1 downto 0);
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           c : in std_logic_vector(31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_2_1 is Port ( 
		   sel: in std_logic;
    	   a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal FW_A_AFTER_IDEX: std_logic_vector(1 downto 0);
signal FW_B_AFTER_IDEX: std_logic_vector(1 downto 0);
signal FW_A_BEFORE_IDEX: std_logic;
signal FW_B_BEFORE_IDEX: std_logic;
signal FWED_A_AFTER_IDEX: std_logic_vector(31 downto 0);
signal FWED_B_AFTER_IDEX: std_logic_vector(31 downto 0);
signal FWED_A_BEFORE_IDEX: std_logic_vector(31 downto 0);
signal FWED_B_BEFORE_IDEX: std_logic_vector(31 downto 0);

component FWD_UNIT is
	Port(
			OP_CODE_IDEX : in std_logic_vector(5 downto 0);
			IDEX_RD : in std_logic_vector(4 downto 0);
			IDEX_RT : in std_logic_vector(4 downto 0);
			IDEX_RS : in std_logic_vector(4 downto 0);
			IDEX_MEM_WE : in std_logic;
			
			OP_CODE_IFID: in std_logic_vector(5 downto 0);
			IFID_RD : in std_logic_vector(4 downto 0);
			IFID_RS : in std_logic_vector(4 downto 0);
			IFID_RT : in std_logic_vector(4 downto 0);
			
			EXMEM_RD : in std_logic_vector(4 downto 0);
			MEMWB_RD : in std_logic_vector(4 downto 0);
			
			EXMEM_RF_WE : in std_logic;
			MEMWB_RF_WE : in std_logic;
			
			INJECT_A_AFTER : out std_logic_vector(1 downto 0);
			INJECT_B_AFTER : out std_logic_vector(1 downto 0);
			
			INJECT_A_BEFORE : out std_logic;
			INJECT_B_BEFORE : out std_logic);
end component;

component  HAZARD_DETECT is
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
			
begin
	
	radioactive : HAZARD_DETECT port map(IDEX_RD=>RD_IDEX,
										IDEX_RF_WE=>WB_FLAGS_IDEX(0),
										OP_CODE_IDEX=>OP_CODE_IDEX,
										OP_CODE_IFID=>INSTR_IFID(31 downto 26),
										IFID_RD=>RD_IFID,
										IFID_RT=>RT_IFID,
										IFID_RS=>RS_IFID,
										PC_LD=>PC_LD,
										IFID_WE=>IFID_WE,
										ultra_low_guttal_like_the_one_CJ_did_in_this_http_www_youtube_com_watch_v_iIkDH0985Fc_at_3_mins_and_15_sec_he_left_the_water_go_down_in_the_drain=>flush);
										
	
	DATA_W <= MEM_DATA_MEMWB when RF_WD_Sel = '1' else R_DATA_MEMWB;
	REGS_IFID <= RS_IFID & RD_IFID & RT_IFID;
	
	
	a_after_idex : mux_3_1 port map(sel=>FW_A_AFTER_IDEX,
									a=>RF_A_IDEX,
									b=>ALU_OUT_EXMEM,
									c=>DATA_W,
									q=>FWED_A_AFTER_IDEX);
									
					
	b_after_idex : mux_3_1 port map(sel=>FW_B_AFTER_IDEX,
									a=>RF_B_IDEX,
									b=>ALU_OUT_EXMEM,
									c=>DATA_W,
									q=>FWED_B_AFTER_IDEX);
									
	a_before_idex : mux_2_1 port map(sel=>FW_A_BEFORE_IDEX,
									a=>RF_A_DEC,
									b=>DATA_W,
									q=>FWED_A_BEFORE_IDEX);
									
	b_before_idex : mux_2_1 port map(sel=>FW_B_BEFORE_IDEX,
									a=>RF_B_DEC,
									b=>DATA_W,
									q=>FWED_B_BEFORE_IDEX);
	
	MEMWB : MEM_WB port map(clk=>clk, rst=>rst,
					WB_FLAGS_IN=>WB_FLAGS_EXMEM,
					RF_WE=>RF_WE, RF_WD_Sel=>RF_WD_Sel,
					MEM_DATA_IN=>MEM_DATAOUT_MEM,
					MEM_DATA_OUT=>MEM_DATA_MEMWB,
					R_DATA_IN=>ALU_OUT_EXMEM,
					R_DATA_OUT=>R_DATA_MEMWB,
					RD_IN=>RD_EXMEM,
					RD_OUT=>RD_MEMWB);
	
	
	save : MEMSTAGE port map(ByteOP=>ByteOP,
					MEM_WE=>MEM_WE,
					ALU_MEM_ADDR=>ALU_OUT_EXMEM,
					MEM_DATAIN=>DATA_EXMEM,
					MEM_DATAOUT=>MEM_DATAOUT_MEM,
					MM_Addr=>MM_Addr,
					MM_WE=>MM_WE,
					MM_DATAIN=>MM_DATAIN,
					MM_DATAOUT=>MM_DATAOUT);
	
	fetch : IFSTAGE port map(clk=>clk, rst=>rst, 
					PC_LD=>PC_LD, 
					PC=>Instr_Addr);
					
	IFID: IF_ID port map(clk=>clk, rst=>rst,
					IFID_WE => IFID_WE,
					Instr_in=>Instr, 
					Instr_out=>Instr_IFID,
					RD_OUT=>RD_IFID,
					RS_OUT=>RS_IFID,
					RT_OUT=>RT_IFID);
					
	decode: DECSTAGE port map(clk=>clk, rst=>rst, 
					Instr=>Instr_IFID, RF_WE=>RF_WE, 
					DATA=>DATA_W, RD_IN=>RD_MEMWB, 
					Immed=>Immed_DEC, 
					RF_A=>RF_A_DEC, 
					RF_B=>RF_B_DEC); 
--					RD_OUT=>RD_DEC, 
--					RS_OUT=>RS_DEC, 
--					RT_OUT=>RT_DEC);
				
	IDEX: ID_EX port map(clk=>clk, rst=>rst,
					OP_CODE_IN=>INSTR_IFID(31 downto 26),
					OP_CODE_OUT=>OP_CODE_IDEX,
					WB_FLAGS_IN=>WB_FLAGS,
					WB_FLAGS_OUT=>WB_FLAGS_IDEX,
					MEM_FLAGS_IN=>MEM_FLAGS,
					MEM_FLAGS_OUT=>MEM_FLAGS_IDEX,
					ALU_FLAGS_IN=>ALU_FLAGS,
					ALU_B_Sel=>ALU_B_Sel,
					ALU_Func=>ALU_Func,
					RF_A_IN=>FWED_A_BEFORE_IDEX,
					RF_A_OUT=>RF_A_IDEX,
					RF_B_IN=>FWED_B_BEFORE_IDEX,
					RF_B_OUT=>RF_B_IDEX,
					IMMED_IN=>IMMED_DEC,
					IMMED_OUT=>IMMED_IDEX,
					REGS_IN=>REGS_IFID,
					RS_OUT=>RS_IDEX,
					RD_OUT=>RD_IDEX,
					RT_OUT=>RT_IDEX);
					
	do_it: EXSTAGE port map(
					RF_A=>FWED_A_AFTER_IDEX,
					RF_B=>FWED_B_AFTER_IDEX,
					IMMED=>IMMED_IDEX,
					ALU_B_Sel=>ALU_B_Sel,
					ALU_Func=>ALU_Func,
					ALU_OUT=>ALU_OUT_EX,
					ALU_Z=>ALU_Z_EX);
					
	EXMEM: EX_MEM port map(clk=>clk, rst=>rst,
					WB_FLAGS_IN=>WB_FLAGS_IDEX,
					WB_FLAGS_OUT=>WB_FLAGS_EXMEM,
					MEM_FLAGS_IN=>MEM_FLAGS_IDEX,
					MEM_WE=>MEM_WE, ByteOP=>ByteOP,
					ALU_Z_IN=>ALU_Z_EX,
					ALU_Z_OUT=>ALU_Z_EXMEM,
					ALU_OUT_IN=>ALU_OUT_EX,
					ALU_OUT_OUT=>ALU_OUT_EXMEM,
					DATA_IN=>FWED_B_AFTER_IDEX,
					DATA_OUT=>DATA_EXMEM,
					RD_IN=>RD_IDEX,
					RD_OUT=>RD_EXMEM);		
					
	injection: FWD_UNIT port map(OP_CODE_IDEX=>OP_CODE_IDEX,
								IDEX_RD=>RD_IDEX,
								IDEX_RT=>RT_IDEX,
								IDEX_RS=>RS_IDEX,
								IDEX_MEM_WE=>MEM_FLAGS_IDEX(0),
								OP_CODE_IFID=>INSTR_IFID(31 downto 26),
								IFID_RD=>RD_IFID,
								IFID_RT=>RT_IFID,
								IFID_RS=>RS_IFID,
								EXMEM_RD=>RD_EXMEM,
								MEMWB_RD=>RD_MEMWB,
								EXMEM_RF_WE=>WB_FLAGS_EXMEM(0),
								MEMWB_RF_WE=>RF_WE,
								INJECT_A_AFTER=>FW_A_AFTER_IDEX,
								INJECT_B_AFTER=>FW_B_AFTER_IDEX,
								INJECT_A_BEFORE=>FW_A_BEFORE_IDEX,
								INJECT_B_BEFORE=>FW_B_BEFORE_IDEX);
	Instr_control <= Instr_IFID;
end;