-- timer module is divided into 2 processes
-- multiplexin:
--      generates a pulse of a 2 bit signal with a frequensy of 470Hz
--      every 470 ticks the 2 bit signal increses by 1 so we got 
--      00 -> 01 -> 10 -> 11 -> 00 with 1/470 sec interval 
--      this signal "plex" feeds as control singal into the multiplexing 
--      470 / 4 (displays) = 120 
--      120 / 2 (half time ON half time OFF) = 60 blinks / sec
--      60 FPS 
-- gearbox:
--      FSM with 3 states: g0, g1, g2
--      all gears are simple down-counting coutners 
--      g0: outputs the "shift" signal for the court 4 leds / sec
--      g1: outputs the "shift" signal for the court 5 leds / sec
--      g2: outputs the "shift" signal for the court 6 leds / sec
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity timer is
    port
    (
        clk     : in std_logic;
        rst     : in std_logic;
        gear0   : in std_logic;
        gearup  : in std_logic;
        shift   : out std_logic;
        plex    : out std_logic_vector(1 downto 0)
    );
end timer;

architecture behavioral of timer is
type state is(g0, g1, g2);
signal gear_state : state;
signal gear_box         : std_logic_vector(23 downto 0);
constant gear_0         : std_logic_vector(23 downto 0) := B"110001100101110101000000";
constant gear_1         : std_logic_vector(23 downto 0) := B"100110001001011010000000";
constant gear_2         : std_logic_vector(23 downto 0) := B"011110100001001000000000";
constant plexi_value    : std_logic_vector(17 downto 0) := B"110010110111001101";
--constant plexi_value    : std_logic_vector(17 downto 0) := B"110011111000010100";
signal plexi_count      : std_logic_vector(17 downto 0);
signal temp_plex        : std_logic_vector(1 downto 0) := B"00";
begin
    multiplexin: process
    begin
        wait until clk'event and clk = '1';
        if rst = '1' then
            plexi_count <= plexi_value;
            temp_plex<= B"00";
        else
            if plexi_count = 0 then
                if temp_plex = 3 then
                    temp_plex <= B"00";
                else
                    temp_plex <= temp_plex + 1;
                end if;
                plexi_count <= plexi_value;
            else
                plexi_count <= plexi_count - 1;
            end if;
        end if;
        plex <= temp_plex;
    end process;

    gearbox : process
    begin
        wait until clk'event and clk = '1';
        if rst = '1' then
            gear_box <= gear_0;
        else
            case gear_state is
                when g0 =>
                    if gear0 = '1' then
                        gear_state <= g0;
                    end if;
                    if gear_box = 0 then
                        gear_box <= gear_0;
                        shift <= '1';
                    else
                        gear_box <= gear_box - 1;
                        shift <= '0';
                    end if;
                    if gearup = '1' then
                        gear_state <= g1;
                    end if;
                when g1 =>
                if gear0 = '1' then
                    gear_state <= g0;
                end if;
                if gear_box = 0 then
                    gear_box <= gear_1;
                    shift <= '1';
                else
                    gear_box <= gear_box - 1;
                    shift <= '0';
                end if;
                if gearup = '1' then
                    gear_state <= g2;
                end if;
                when g2 =>
                if gear0 = '1' then
                    gear_state <= g0;
                end if;
                if gear_box = 0 then
                    gear_box <= gear_2;
                    shift <= '1';
                else
                    gear_box <= gear_box - 1;
                    shift <= '0';
                end if;
            end case;
          end if;
    end process;
end behavioral;
