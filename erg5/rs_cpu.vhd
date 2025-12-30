library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.cpulib.all;

entity rs_cpu is
    port (
        ARdata, PCdata : buffer std_logic_vector(15 downto 0);
        DRdata, ACdata : buffer std_logic_vector(7 downto 0);
        IRdata, TRdata : buffer std_logic_vector(7 downto 0);
        RRdata         : buffer std_logic_vector(7 downto 0);
        ZRdata         : buffer std_logic;
        clock, reset   : in std_logic;
        mOP            : buffer std_logic_vector(26 downto 0);
        addressBus     : buffer std_logic_vector(15 downto 0);
        dataBus        : buffer std_logic_vector(7 downto 0)
    );
end rs_cpu;

architecture arc of rs_cpu is
    
    -- Εσωτερικά σήματα (Ίδια με πριν)
    signal mem_q       : std_logic_vector(7 downto 0);
    signal alu_sel     : std_logic_vector(6 downto 0);
    signal alu_res     : std_logic_vector(7 downto 0);
    signal alu_z_out   : std_logic;
    
    -- Aliases για τα mOPs (Ίδια με πριν)
    alias ARLOAD : std_logic is mOP(26);
    alias ARINC  : std_logic is mOP(25);
    alias PCLOAD : std_logic is mOP(24);
    alias PCINC  : std_logic is mOP(23);
    alias DRLOAD : std_logic is mOP(22);
    alias TRLOAD : std_logic is mOP(21);
    alias IRLOAD : std_logic is mOP(20);
    alias RLOAD  : std_logic is mOP(19);
    alias ACLOAD : std_logic is mOP(18);
    alias ZLOAD  : std_logic is mOP(17);
    alias READ   : std_logic is mOP(16);
    alias WRITE  : std_logic is mOP(15);
    alias MEMBUS : std_logic is mOP(14);
    alias PCBUS  : std_logic is mOP(12);
    alias DRBUS  : std_logic is mOP(11);
    alias TRBUS  : std_logic is mOP(10);
    alias RBUS   : std_logic is mOP(9);
    alias ACBUS  : std_logic is mOP(8);
    -- ALU Ops Aliases
    alias ANDOP  : std_logic is mOP(7);
    alias OROP   : std_logic is mOP(6);
    alias XOROP  : std_logic is mOP(5);
    alias NOTOP  : std_logic is mOP(4);
    alias ACINC  : std_logic is mOP(3);
    alias ACZERO : std_logic is mOP(2);
    alias PLUS   : std_logic is mOP(1);
    alias MINUS  : std_logic is mOP(0);

begin

    -- 1. Control Unit (Hardwired)
    U_CU: hardwired port map (
        ir    => IRdata(3 downto 0),
        clock => clock,
        reset => reset,
        z     => ZRdata,
        mOPs  => mOP
    );

    -- 2. ALU Signal Generator
    U_ALUS: alus port map (
        rbus => RBUS, acload => ACLOAD, zload => ZLOAD, andop => ANDOP,
        orop => OROP, notop => NOTOP, xorop => XOROP, aczero => ACZERO,
        acinc => ACINC, plus => PLUS, minus => MINUS, drbus => DRBUS,
        alus_out => alu_sel
    );

    -- 3. ALU Core
    U_ALU_CORE: alu_core port map (
        A => ACdata,
        B => DRdata,
        sel => alu_sel,
        res => alu_res,
        zero => alu_z_out
    );

    -- 4. Registers (Αντικατάσταση με regnbit)
    
    -- AR (Address Register) - 16 bit
    U_AR: regnbit 
        generic map (n => 16)
        port map (
            din => "00000000" & dataBus, -- Padding 8 to 16 bits
            clk => clock, 
            rst => reset, 
            ld  => ARLOAD, 
            inc => ARINC, 
            dout => ARdata
        );
    
    -- PC (Program Counter) - 16 bit
    U_PC: regnbit 
        generic map (n => 16)
        port map (
            din => "00000000" & dataBus, -- Padding
            clk => clock, 
            rst => reset, 
            ld  => PCLOAD, 
            inc => PCINC, 
            dout => PCdata
        );
    
    -- DR (Data Register) - 8 bit
    U_DR: regnbit 
        generic map (n => 8)
        port map (
            din => dataBus, 
            clk => clock, 
            rst => reset, 
            ld  => DRLOAD, 
            inc => '0', -- Δεν έχει λειτουργία inc
            dout => DRdata
        );

    -- TR (Temporary Register) - 8 bit
    U_TR: regnbit 
        generic map (n => 8)
        port map (
            din => dataBus, 
            clk => clock, 
            rst => reset, 
            ld  => TRLOAD, 
            inc => '0', 
            dout => TRdata
        );

    -- IR (Instruction Register) - 8 bit
    U_IR: regnbit 
        generic map (n => 8)
        port map (
            din => dataBus, 
            clk => clock, 
            rst => reset, 
            ld  => IRLOAD, 
            inc => '0', 
            dout => IRdata
        );

    -- R (General Register) - 8 bit
    U_RR: regnbit 
        generic map (n => 8)
        port map (
            din => dataBus, 
            clk => clock, 
            rst => reset, 
            ld  => RLOAD, 
            inc => '0', 
            dout => RRdata
        );
    
    -- AC (Accumulator) - 8 bit
    -- Σημείωση: Η αύξηση του AC (ACINC) γίνεται μέσω της ALU (inp A + 1), όχι μέσω του καταχωρητή.
    -- Οπότε το inc του καταχωρητή είναι μόνιμα '0'.
    U_AC: regnbit 
        generic map (n => 8)
        port map (
            din => alu_res, 
            clk => clock, 
            rst => reset, 
            ld  => ACLOAD, 
            inc => '0', 
            dout => ACdata
        );

    -- Z Flag Register (Flip-Flop) - Παραμένει ως process
    process(clock, reset)
    begin
        if reset = '1' then
            ZRdata <= '0';
        elsif rising_edge(clock) then
            if ZLOAD = '1' then
                ZRdata <= alu_z_out;
            end if;
        end if;
    end process;

    -- 5. Memory
    U_MEM: external_ram port map (
        address => ARdata(7 downto 0),
        clock   => clock,
        data    => dataBus,
        wren    => WRITE,
        q       => mem_q
    );

    -- 6. Bus Logic
    U_BUS: data_bus_logic port map (
        mem_out => mem_q,
        dr_out  => DRdata,
        ac_out  => ACdata,
        tr_out  => TRdata,
        r_out   => RRdata,
        membus  => MEMBUS,
        drbus   => DRBUS,
        acbus   => ACBUS,
        trbus   => TRBUS,
        rbus    => RBUS,
        dbus_out => dataBus
    );

    -- 7. Address Bus Driver
    addressBus <= PCdata when PCBUS = '1' else ARdata;

end arc;