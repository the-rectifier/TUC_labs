-- this module counts the points and as soon as one player reaches 15 points
-- it advertises (internally) the winner and feeds it into the display module
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity score is Port
   (
      CLK      : in STD_LOGIC;
      RST      : in STD_LOGIC;
      PntA     : in  STD_LOGIC;
      PntB     : in  STD_LOGIC;
      GameMode : in  STD_LOGIC;
      Apoints  : out  STD_LOGIC_VECTOR (3 downto 0);
      Bpoints  : out  STD_LOGIC_VECTOR (3 downto 0);
      winner   : out  STD_LOGIC_VECTOR (1 downto 0);
      gear0    : out  STD_LOGIC
	);
end score;

architecture behavioral of score is
signal tmp_Apoints   : STD_LOGIC_VECTOR(3 downto 0);
signal tmp_Bpoints   : STD_LOGIC_VECTOR(3 downto 0);
signal tmp_gear0     : STD_LOGIC;
begin
   process
   begin
      wait until clk'event and clk = '1';
      if rst = '1' then -- we reset everything
         tmp_Apoints <= X"0";
         tmp_Bpoints <= X"0";
         winner      <= B"11";
         tmp_gear0   <= '0';
      else
         if gamemode = '0' then
            if PntA = '1' then 
               if tmp_Apoints = 14 then
                  winner <= B"10";
                  tmp_Apoints <= X"F";
               else
                  tmp_Apoints <= tmp_Apoints + 1;
                  winner <= B"11";
               end if;
            elsif PntB = '1' then 
               if tmp_Bpoints = 14 then
                  winner <= B"01";
                  tmp_Bpoints <= X"F";
               else
                  winner <= B"11";
                  tmp_Bpoints <= tmp_Bpoints + 1;
               end if;
            end if;
            if (PntA = '1' or PntB = '1') then 
               tmp_gear0 <= '1';
            else
               tmp_gear0 <= '0';
            end if;
         elsif gamemode = '1' then 
         -- if we are in practice mode then we get points for every time we hit correcty the opponents ball
         -- we loose on the first ball we misshit
            if PntA = '1' then
               if tmp_Apoints = 14 then
                  winner <= B"10";
                  tmp_Apoints <= X"F";
               else
                  tmp_Apoints <= tmp_Apoints + 1;
                  winner <= B"11";
               end if;
            elsif PntB = '1' then
                  winner <= B"00";
                  tmp_Apoints <= X"0";
                  tmp_Bpoints <= X"0";
            end if;
         end if;
      end if;
   end process;
   Apoints  <= tmp_Apoints;
   Bpoints  <= tmp_Bpoints;
   gear0    <= tmp_gear0;
end behavioral;
