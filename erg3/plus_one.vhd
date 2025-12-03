library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity plus_one is
    port (
        input_addr  : in  std_logic_vector(5 downto 0);
        output_addr : out std_logic_vector(5 downto 0)
    );
end plus_one;

architecture behavior of plus_one is
begin
    output_addr <= input_addr + 1;
end behavior;