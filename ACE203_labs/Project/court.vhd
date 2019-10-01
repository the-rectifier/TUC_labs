library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity court is 
    port
    (
        clk                 : in std_logic; 
        rst                 : in std_logic;
        shift               : in std_logic; -- shift pulse for the registers
        hit_a               : in std_logic; -- correct hit from A/B
        hit_b               : in std_logic;
        serv                : in std_logic; -- there was a point, reset
        pos                 : out std_logic_vector(1 downto 0); -- to advertise critical positions and when we are shiftin
        led                 : out std_logic_vector(7 downto 0); -- the actuall court
        gamemode            : in std_logic; -- practice or not
        winner              : in std_logic_vector(1 downto 0) 
    );
end court;

architecture behavioral of court is
signal prev_serv    : std_logic_vector(1 downto 0); -- store the last service position
signal tmp_pos      : std_logic_vector(1 downto 0); -- we ought not to use inout
signal tmp_led      : std_logic_vector(7 downto 0);
signal en_r         : std_logic; -- shift register's enables
signal en_l         : std_logic;
begin
    process
    begin
        wait until clk'event and clk = '1';
        if rst = '1' then
            tmp_led <= X"80";
            tmp_pos <= B"10";
            prev_serv <= B"10";
            en_l <= '0';
            en_r <= '0';
        else
            if winner = B"11" then
                if gamemode = '0' then
                    -- we can have either hitA / hitB or a serv(point to each)
                    -- if we have a hit then we shift 7 times left/right accordingly
                    -- each time we get the serv signal we swap the service position 
                    if hit_a = '1' and hit_b = '0' and tmp_pos = B"10" then --hit a
                        en_r <= '1'; 
                        en_l <= '0';
                    elsif hit_b = '1' and hit_a = '0' and tmp_pos = B"01" then -- hit b
                        en_r <= '0';
                        en_l <= '1';
                    elsif serv = '1' then --no hits => point
                        if prev_serv = B"10" then
                            tmp_pos <= B"01";
                            tmp_led <= X"01";
                            prev_serv <= not prev_serv; -- swap the service 
                            en_r <= '0';
                            en_l <= '0'; -- we reset the enables
                        elsif prev_serv = B"01" then
                            tmp_pos <= B"10";
                            tmp_led <= X"80";
                            prev_serv <= not prev_serv;
                            en_r <= '0';
                            en_l <= '0';
                        end if;
                    end if;
                    -- as long as we have one of the two enables HIGH we shift until the critial position
                    -- we pull the enable LOW and we advertise our position
                    -- strikes module takes care of the rest and send the serv / hit signal accordingly and we reset / continue
                    if en_r = '1' then
                        if tmp_led = B"00000010" and shift = '1' then
                            tmp_pos <= B"01";
                            tmp_led <= X"01";
                            en_r <= '0';
                        elsif shift = '1' then 
                            tmp_led(6 downto 0) <= tmp_led(7 downto 1);
                            tmp_led(7) <= '0';
                            tmp_pos <= B"00";
                        end if;
                    elsif en_l = '1' then
                        if tmp_led = B"01000000" and shift = '1' then
                            tmp_pos <= B"10";
                            tmp_led <= X"80";
                            en_l <= '0';
                        elsif shift = '1' then
                            tmp_led(7 downto 1) <= tmp_led(6 downto 0);
                            tmp_led(0) <= '0';
                            tmp_pos <= B"00";
                        end if;
                    end if;   
                else -- practice
                -- same principles apply to practice mode 
                -- the only difference is that the player always serves 
                -- so every time there is the serv signal we reset to P1 pos
                    if hit_a = '1' and hit_b = '0' and tmp_pos = B"10" then --hit a
                        en_r <= '1';
                        en_l <= '0';
                    elsif hit_b = '1' and hit_a = '0' and tmp_pos = B"01" then -- hit b
                        en_r <= '0';
                        en_l <= '1';
                    elsif serv = '1' then
                        tmp_pos <= B"10";
                        tmp_led <= X"80";
                        en_r <= '0';
                        en_l <= '0';
                    end if;
                    if en_r = '1' then
                        if tmp_led = B"00000010" and shift = '1' then
                            tmp_pos <= B"01";
                            tmp_led <= X"01";
                            en_r <= '0';
                        elsif shift = '1' then 
                            tmp_led(6 downto 0) <= tmp_led(7 downto 1);
                            tmp_led(7) <= '0';
                            tmp_pos <= B"00";
                        end if;
                    elsif en_l = '1' then
                        if tmp_led = B"01000000" and shift = '1' then
                            tmp_pos <= B"10";
                            tmp_led <= X"80";
                            en_l <= '0';
                        elsif shift = '1' then
                            tmp_led(7 downto 1) <= tmp_led(6 downto 0);
                            tmp_led(0) <= '0';
                            tmp_pos <= B"00";
                        end if;
                    end if; 
                end if;
            else
                -- if there is a winner then we light up every led 
                tmp_pos <= B"11";
                tmp_led <= X"FF";
            end if;
        end if;
    end process;
pos <= tmp_pos;
led <= tmp_led;
end behavioral;