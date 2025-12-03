library ieee;
use ieee.std_logic_1164.all;

entity mux4_6bit is
    port (
        sel    : in  std_logic_vector(1 downto 0); --  S1, S0
        in0    : in  std_logic_vector(5 downto 0); --  +1
        in1    : in  std_logic_vector(5 downto 0); --  ADDR 
        in2    : in  std_logic_vector(5 downto 0); --  MAP
        in3    : in  std_logic_vector(5 downto 0); -- 
        output : out std_logic_vector(5 downto 0)
    );
end mux4_6bit;

architecture behavior of mux4_6bit is
begin
    with sel select
        output <= in0 when "00",
                  in1 when "01",
                  in2 when "10",
                  in3 when "11",
                  (others => '0') when others;
end behavior;