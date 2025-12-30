library ieee;
use ieee.std_logic_1164.all;

entity data_bus_logic is
    port (
        mem_out : in std_logic_vector(7 downto 0);
        dr_out  : in std_logic_vector(7 downto 0); 
        ac_out  : in std_logic_vector(7 downto 0); 
        tr_out  : in std_logic_vector(7 downto 0); 
        r_out   : in std_logic_vector(7 downto 0); -- from register
        
        -- control signals
        membus  : in std_logic; -- mOPs(14)
        drbus   : in std_logic; -- mOPs(11)
        acbus   : in std_logic; -- mOPs(8)
        trbus   : in std_logic; -- mOPs(10)
        rbus    : in std_logic; -- mOPs(9)
        
        dbus_out : out std_logic_vector(7 downto 0)
    );
end data_bus_logic;

architecture behavioral of data_bus_logic is
begin
    dbus_out <= mem_out when membus = '1' else
                dr_out  when drbus  = '1' else
                ac_out  when acbus  = '1' else
                tr_out  when trbus  = '1' else
                r_out   when rbus   = '1' else
                (others => 'Z'); -- High Impedance
end behavioral;