library ieee;
use ieee.std_logic_1164.all;

package hardwiredlib is

    component decoder4to16
        port (
            Din  : in  std_logic_vector(3 downto 0);
            Dout : out std_logic_vector(15 downto 0)
        );
    end component;

    component decoder3to8
        port (
            Din  : in  std_logic_vector(2 downto 0);
            Dout : out std_logic_vector(7 downto 0)
        );
    end component;

    component counter3bit
        port (
            clock : in  std_logic;
            rst   : in  std_logic;
            inc   : in  std_logic;
            clr   : in  std_logic;
            count : out std_logic_vector(2 downto 0)
        );
    end component;

end hardwiredlib;