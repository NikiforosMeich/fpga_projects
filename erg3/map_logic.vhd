library ieee;
use ieee.std_logic_1164.all;

entity map_logic is
    port (
        ir_opcode : in  std_logic_vector(3 downto 0);
        map_out   : out std_logic_vector(5 downto 0)
    );
end map_logic;

architecture behavior of map_logic is
begin
    map_out <= ir_opcode & "00";
end behavior;