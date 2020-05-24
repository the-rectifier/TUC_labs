library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity ram is
  Port (
        clk  : in std_logic;
        data_we : in std_logic;
        inst_addr : in std_logic_vector(10 downto 0);
        inst_dout : out std_logic_vector(31 downto 0);
        data_addr : in std_logic_vector(10 downto 0);
        data_din  : in std_logic_vector(31 downto 0);
        data_dout : out std_logic_vector(31 downto 0));
end ram;

architecture Behavioral of ram is

type ram_type is array(2047 downto 0) of std_logic_vector(31 downto 0);

impure function Ram_init(RamFileName : in string) return ram_type is FILE ramfile : text is in RamFileName;
    variable RamFileLine : line;
    variable ram : ram_type;
    begin
        for i in 0 to 1023 loop
            readline(ramfile, RamFileLine);
            read(RamFileLine, ram(i));
        end loop;
        for i in 1024 to 2047 loop
          ram(i) := X"0000_0000";
        end loop;

    	return ram;
    end function;

signal RAM : ram_type := Ram_init("rom.data");

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if data_we = '1' then
                RAM(to_integer(unsigned(data_addr))) <= data_din;
            end if;
        end if;
    end process;
    
    --Ram slower than CPU cache and CPU registers
    data_dout <= RAM(to_integer(unsigned(data_addr))) after 12 ns;
    inst_dout <= RAM(to_integer(unsigned(inst_addr))) after 12 ns;

end Behavioral;