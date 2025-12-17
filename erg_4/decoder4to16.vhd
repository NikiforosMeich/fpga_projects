library ieee;
use ieee.std_logic_1164.all;

entity decoder4to16 is
    port (
        Din  : in  std_logic_vector(3 downto 0);
        Dout : out std_logic_vector(15 downto 0)
    );
end decoder4to16;

architecture behavior of decoder4to16 is
begin
    process(Din)
    begin
        case Din is
            when "0000" => Dout(0)  <= '1'; -- NOP
            when "0001" => Dout(1)  <= '1'; -- LDAC
            when "0010" => Dout(2)  <= '1'; -- STAC
            when "0011" => Dout(3)  <= '1'; -- MVAC
            when "0100" => Dout(4)  <= '1'; -- MOVR
            when "0101" => Dout(5)  <= '1'; -- JUMP
            when "0110" => Dout(6)  <= '1'; -- JMPZ
            when "0111" => Dout(7)  <= '1'; -- JPNZ
            when "1000" => Dout(8)  <= '1'; -- ADD
            when "1001" => Dout(9)  <= '1'; -- SUB
            when "1010" => Dout(10) <= '1'; -- INAC
            when "1011" => Dout(11) <= '1'; -- CLAC
            when "1100" => Dout(12) <= '1'; -- AND
            when "1101" => Dout(13) <= '1'; -- OR
            when "1110" => Dout(14) <= '1'; -- XOR
            when others => Dout(15) <= '1'; -- NOT
        end case;
    end process;
end behavior;