library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
use work.mseqlib.all;

entity mseq is
    port( ir           : in std_logic_vector(3 downto 0);
          clock, reset : in std_logic;
          z            : in std_logic;
          code         : out std_logic_vector(35 downto 0);
          mOPs         : out std_logic_vector(26 downto 0));
end mseq;

architecture arc of mseq is

    signal cur_address : std_logic_vector(5 downto 0);
    signal nxt_address : std_logic_vector(5 downto 0);
    signal inc_address : std_logic_vector(5 downto 0);
    signal map_address : std_logic_vector(5 downto 0);
    
    -- rom signals
    signal microinstruction : std_logic_vector(35 downto 0);
    signal cond             : std_logic_vector(1 downto 0);
    signal BT               : std_logic;
    signal ADDR             : std_logic_vector(5 downto 0);
    
    signal S1, S0           : std_logic;
    signal S_vector         : std_logic_vector(1 downto 0);
    
    signal mux_cond_out     : std_logic; 
    signal not_Z            : std_logic; 

begin

    -- Instruction splitting
    code <= microinstruction;

    cond <= microinstruction(35 downto 34);
    BT   <= microinstruction(33);
    mOPs <= microinstruction(32 downto 6);
    ADDR <= microinstruction(5 downto 0);

    not_Z <= not z;

    -- Control Logic
    S1 <= BT;
    S0 <= not mux_cond_out;

    S_vector <= S1 & S0;

    block_0: mseq_rom port map (
        address => cur_address,
        clock   => clock,
        q       => microinstruction
    );

    block_1: reg6 port map (
        clk   => clock,
        reset => reset,
        d     => nxt_address,
        q     => cur_address
    );

    -- Incrementer
    block_2: plus_one port map (
        input_addr  => cur_address,
        output_addr => inc_address
    );

    block_3: map_logic port map (
        ir_opcode => ir,
        map_out   => map_address
    );

    block_4: cond_mux port map (
        sel      => cond,
        in0      => '1',      
        in1      => z,        
        in2      => not_Z,    
        in3      => '0',      
        cond_out => mux_cond_out
    );

    block_5: mux4_6bit port map (
        sel    => S_vector,
        in0    => inc_address,
        in1    => ADDR,
        in2    => map_address,
        in3    => (others => '0'),
        output => nxt_address
    );

end arc;