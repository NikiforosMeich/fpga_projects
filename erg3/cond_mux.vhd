library ieee;
use ieee.std_logic_1164.all;

entity cond_mux is
    port (
        sel      : in  std_logic_vector(1 downto 0);
        in0, in1, in2, in3 : in std_logic;
        cond_out : out std_logic
    );
end cond_mux;

architecture behavior of cond_mux is
begin
    with sel select
        cond_out <= in0 when "00", -- '1'
                    in1 when "01", -- Z
                    in2 when "10", -- Not Z
                    in3 when "11", -- '0'
                    '0' when others;
end behavior;