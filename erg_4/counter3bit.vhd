library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter3bit is
    port (
        clock : in  std_logic;
        rst   : in  std_logic; 
        inc   : in  std_logic; 
        clr   : in  std_logic; 
        count : out std_logic_vector(2 downto 0)
    );
end counter3bit;

architecture behavior of counter3bit is
    signal temp_count : std_logic_vector(2 downto 0);
begin
    process(clock, rst)
    begin
        if rst = '1' then
            temp_count <= (others => '0');
        elsif rising_edge(clock) then
            if clr = '1' then
                temp_count <= (others => '0');
            elsif inc = '1' then
                temp_count <= temp_count + 1;
            end if;
        end if;
    end process;
    
    count <= temp_count;
end behavior;