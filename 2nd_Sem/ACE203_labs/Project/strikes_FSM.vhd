-- it consists of an FSM with 3 states (s0 -> service state, s1 -> transition state, s2 -> critical position)
-- this module takes as input the pos from the court and the 2 push buttons
-- s0:
--    waits until the player servess
--    moves to s1 (transition)
-- s1:
--    the transition state is when the ball is moving from the one edge to the other (pos = 00)
--    if a player hit their button while in s1 then there is a point to the opponent and returns to s0 
--    if the ball reaches a critical position then it moves to s2
-- s2:
--    it counts for 700ms and then checks if in that period the player has hit his button 
--    if the player hit correctly then it returns to s1 (transition again)
--    else it outputs the serv and point and returns to s0
-- NOTE: 
--    Everytime we have a binary signal as HIGH on the next state we Pull it LOW (so we have a pulse for 1 clk cycle)
-- while we are at practice
-- the same principles apply but everytime there is a critical position on the CPU side the "hitB" signal is calculated by the system
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity 	STRIKES_fsm is Port
	(
      clk        : in  STD_LOGIC;
      rst        : in  STD_LOGIC;
      Strike1    : in  STD_LOGIC;
      Strike2    : in  STD_LOGIC;
      pos        : in  STD_LOGIC_VECTOR (1 downto 0);
      gamemode   : in  STD_LOGIC;
      gearup     : out STD_LOGIC;
      HitA       : out STD_LOGIC; --player A hit at correct moment
      HitB       : out STD_LOGIC; --player B hit at correct moment
      PntA       : out STD_LOGIC; --point to A
      PntB       : out STD_LOGIC; --point to B
      serv       : out std_logic
	);
end STRIKES_fsm;

architecture behavioral of strikes_fsm is
Type state is(s0,s1,s2);
signal fsm_state           : state;
signal hit                 : std_logic;
constant hit_period_value  : std_logic_vector(22 downto 0) := B"11010101100111111000000"; -- 700 ms hit window 
signal buff                : std_logic;
signal hit_period          : std_logic_vector(22 downto 0);
signal hit_counter         : STD_LOGIC_VECTOR(1 downto 0) := B"00";
begin
   process
   begin
      wait until clk'event and clk = '1';
      if rst = '1' then
         gearup      <= '0';
         HitA        <= '0';
         HitB        <= '0';
         PntA        <= '0';
         PntB        <= '0';
         fsm_state   <= s0;
         serv        <= '0';
         hit         <= '0';
         buff        <= '0';
         hit_period  <= hit_period_value;
         hit_counter <= B"00";
      else
         if gamemode = '0' then --normal game
            case fsm_state is
            when s0 =>
                  buff  <= '0';
                  PntA  <= '0';
                  PntB  <= '0';
                  HitA  <= '0';
                  HitB  <= '0';
                  serv  <= '0';
                  hit   <= '0';
               if Strike1 = '1' and Strike2 = '0' and pos = B"10" then
                  buff  <= '0';
                  HitA  <= '1';
                  HitB  <= '0';
                  PntA  <= '0';
                  PntB  <= '0';
                  serv  <= '0';
                  hit   <= '0';
                  fsm_state <= s1;
               elsif Strike1 = '0' and Strike2 = '1' and pos = B"01" then
                  buff  <= '0';
                  HitA  <= '0';
                  HitB  <= '1';
                  PntA  <= '0';
                  PntB  <= '0';
                  serv  <= '0';
                  hit   <= '0';
                  fsm_state <= s1;
               end if;
            when s1 =>
               buff  <= '0';
               HitA  <= '0';
               HitB  <= '0';
               PntA  <= '0';
               PntB  <= '0';
               serv  <= '0';
               hit   <= '0';
               if pos = B"00" then
                  buff <= '1';
                  if Strike1 = '1' then
                     PntB  <= '1';
                     PntA  <= '0';
                     HitA  <= '0';
                     HitB  <= '0';
                     serv  <= '1';
                     hit   <= '0';
                     hit_counter <= B"00";
                     fsm_state <= s0;
                  elsif Strike2 = '1' then
                     PntB  <= '0';
                     PntA  <= '1';
                     HitA  <= '0';
                     HitB  <= '0';
                     serv  <= '1';
                     hit   <= '0';
                     hit_counter <= B"00";
                     fsm_state <= s0;
                  end if;
               elsif pos = B"10" and buff = '1' then
                  hit <= '0';
                  fsm_state <= s2;
               elsif pos = B"01" and buff = '1' then
                  hit <= '0';
                  fsm_state <= s2;
               end if;
            when s2 =>
               if pos = B"10" then
                  if Strike1 = '1' then
                     hit <= '1';
                  end if;
                  if hit_period = 0 then
                     if hit = '1' then
                        HitA  <= '1';
                        HitB  <= '0';
                        PntA  <= '0';
                        PntB  <= '0';
                        hit   <= '0';
                        fsm_state   <= s1;
                        hit_period  <= hit_period_value;
                        hit_counter <= hit_counter + 1;
                     else
                        PntB  <= '1';
                        PntA  <= '0';
                        HitA  <= '0';
                        HitB  <= '0';
                        serv  <= '1';
                        hit   <= '0';
                        hit_counter <= B"00";
                        fsm_state   <= s0;
                        hit_period  <= hit_period_value;
                     end if;
                  else
                     hit_period <= hit_period - 1;
                  end if;
               elsif pos = B"01" then
                  if Strike2 = '1' then
                     hit <= '1';
                  end if;
                  if hit_period = 0 then
                     if hit = '1' then
                        HitA  <= '0';
                        hitB  <= '1';
                        PntA  <= '0';
                        PntB  <= '0';
                        hit   <= '0';
                        fsm_state   <= s1;
                        hit_period  <= hit_period_value;
                        hit_counter <= hit_counter + 1;                    
                     else
                        PntB <= '0';
                        PntA <= '1';
                        HitA <= '0';
                        HitB <= '0';
                        serv <= '1';
                        hit <=  '0';
                        hit_counter <= B"00";
                        fsm_state   <= s0;
                        hit_period  <= hit_period_value;
                     end if;
                  else
                     hit_period <= hit_period - 1;
                  end if;
               end if;
            end case;
         else --practice
            case fsm_state is
            when s0 =>
                  buff  <= '0';
                  PntA  <= '0';
                  PntB  <= '0';
                  HitA  <= '0';
                  HitB  <= '0';
                  serv  <= '0';
                  hit   <= '0';
               if Strike1 = '1' and pos = B"10" then
                  buff  <= '0';
                  HitA  <= '1';
                  HitB  <= '0';
                  PntA  <= '0';
                  PntB  <= '0';
                  serv  <= '0';
                  hit   <= '0';
                  fsm_state <= s1;
               end if;
            when s1 =>
               buff  <= '0';
               HitA  <= '0';
               HitB  <= '0';
               PntA  <= '0';
               PntB  <= '0';
               serv  <= '0';
               hit   <= '0';
               if pos = B"00" then
                  buff <= '1';
                  if Strike1 = '1' then
                     PntB <= '1';
                     PntA <= '0';
                     HitA <= '0';
                     HitB <= '0';
                     serv <= '1';
                     hit  <= '0';
                     hit_counter <= B"00";
                     fsm_state   <= s0;
                  end if;
               elsif pos = B"10" and buff = '1' then
                  hit <= '0';
                  fsm_state <= s2;
               elsif pos = B"01" and buff = '1' then
                  if Strike1 = '1' then
                     PntB  <= '1';
                     PntA  <= '0';
                     HitA  <= '0';
                     HitB  <= '0';
                     serv  <= '1';
                     hit   <= '0';
                     hit_counter <= B"00";
                     fsm_state   <= s0;
                  else
                     hitB <= '1';
                     fsm_state <= s1;
                  end if;
               end if;
            when s2 =>
               if Strike1 = '1' then
                  hit <= '1';
               end if;
               if hit_period = 0 then
                  if hit = '1' then
                     HitA  <= '1';
                     HitB  <= '0';
                     PntA  <= '1';
                     PntB  <= '0';
                     hit   <= '0';
                     fsm_state   <= s1;
                     hit_period  <= hit_period_value;
                     hit_counter <= hit_counter + 1;
                  else
                     PntB  <= '1';
                     PntA  <= '0';
                     HitA  <= '0';
                     HitB  <= '0';
                     serv  <= '1';
                     hit   <= '0';
                     hit_counter <= B"00";
                     fsm_state   <= s0;
                     hit_period  <= hit_period_value;
                  end if;
               else
                  hit_period <= hit_period - 1;
               end if;
            end case;
         end if;
         if hit_counter = 3 then
            hit_counter <= B"00";
            gearup <= '1';
         else
            gearup <= '0';
         end if;
      end if;
   end process;
end behavioral;