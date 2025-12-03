library ieee;
use ieee.std_logic_1164.all;

package mseqlib is

    component reg6
        port ( 
            clk, reset : in std_logic; 
            d : in std_logic_vector(5 downto 0); 
            q : out std_logic_vector(5 downto 0)
        );
    end component;

    component mux4_6bit
        port ( 
            sel : in std_logic_vector(1 downto 0); 
            in0, in1, in2, in3 : in std_logic_vector(5 downto 0); 
            output : out std_logic_vector(5 downto 0)
        );
    end component;
    
    component plus_one
        port ( 
            input_addr : in std_logic_vector(5 downto 0); 
            output_addr : out std_logic_vector(5 downto 0)
        );
    end component;

    component map_logic
        port ( 
            ir_opcode : in std_logic_vector(3 downto 0); 
            map_out : out std_logic_vector(5 downto 0)
        );
    end component;
    
    component cond_mux
        port ( 
            sel : in std_logic_vector(1 downto 0); 
            in0, in1, in2, in3 : in std_logic; 
            cond_out : out std_logic
        );
    end component;

    component mseq_rom
        port ( 
            address : in std_logic_vector(5 downto 0); 
            clock : in std_logic; 
            q : out std_logic_vector(35 downto 0)
        );
    end component;

end mseqlib;