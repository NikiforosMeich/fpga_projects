library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
use work.hardwiredlib.all;
entity hardwired is
port (
ir
: in std_logic_vector(3 downto 0);
clock, reset : in std_logic;
z
: in std_logic;
mOPs
: out std_logic_vector(26 downto 0)
);
end hardwired;
architecture arc of hardwired is
signal count_out : std_logic_vector(2 downto 0);
signal cnt_inc : std_logic;
signal cnt_clr : std_logic;
signal I_dec: std_logic_vector(15 downto 0); -- Instruction Signals
signal T_dec: std_logic_vector(7 downto 0); -- Time/State Signals
signal INOP, ILDAC, ISTAC, IMVAC, IMOVR, IJUMP, IJMPZ, IJPNZ : std_logic;signal IADD, ISUB, IINAC, ICLAC, IAND, IOR, IXOR, INOT
: std_logic;
signal T0, T1, T2, T3, T4, T5, T6, T7 : std_logic;
signal LDAC, STAC : std_logic_vector(4 downto 0);
signal MVAC, MOVR, NOP : std_logic;
signal FETCH, JUMP, JMPZY, JPNZY : std_logic_vector(2 downto 0);
signal JMPZN, JPNZN : std_logic_vector(1 downto 0);
signal ADD_OP, SUB_OP, INAC, CLAC, AND_OP, OR_OP, XOR_OP, NOT_OP : std_logic;
begin
-- 1. Instantiation of Components
block0: decoder4to16 port map (
Din => ir,
Dout => I_dec
);
block1: decoder3to8 port map (
Din => count_out,
Dout => T_dec
);
block2: counter3bit port map (
clock => clock,
rst => reset,
inc => cnt_inc,clr => cnt_clr,
count => count_out
);
INOP <= I_dec(0); ILDAC <= I_dec(1); ISTAC <= I_dec(2); IMVAC <= I_dec(3);
IMOVR <= I_dec(4); IJUMP <= I_dec(5); IJMPZ <= I_dec(6); IJPNZ <= I_dec(7);
IADD <= I_dec(8); ISUB <= I_dec(9); IINAC <= I_dec(10); ICLAC <= I_dec(11);
IAND <= I_dec(12); IOR <= I_dec(13); IXOR <= I_dec(14); INOT <= I_dec(15);
T0 <= T_dec(0); T1 <= T_dec(1); T2 <= T_dec(2); T3 <= T_dec(3);
T4 <= T_dec(4); T5 <= T_dec(5); T6 <= T_dec(6); T7 <= T_dec(7);
FETCH(0) <= T0;
FETCH(1) <= T1;
FETCH(2) <= T2;
NOP
<= INOP AND T3;
LDAC(0) <= ILDAC AND T3;
LDAC(1) <= ILDAC AND T4;
LDAC(2) <= ILDAC AND T5;
LDAC(3) <= ILDAC AND T6;
LDAC(4) <= ILDAC AND T7;
STAC(0) <= ISTAC AND T3;
STAC(1) <= ISTAC AND T4;
STAC(2) <= ISTAC AND T5;
STAC(3) <= ISTAC AND T6;STAC(4) <= ISTAC AND T7;
MVAC<= IMVAC AND T3;
MOVR<= IMOVR AND T3;
JUMP(0) <= IJUMP AND T3;
JUMP(1) <= IJUMP AND T4;
JUMP(2) <= IJUMP AND T5;
JMPZY(0) <= IJMPZ AND Z AND T3;
JMPZY(1) <= IJMPZ AND Z AND T4;
JMPZY(2) <= IJMPZ AND Z AND T5;
JMPZN(0) <= IJMPZ AND (NOT Z) AND T3;
JMPZN(1) <= IJMPZ AND (NOT Z) AND T4;
JPNZY(0) <= IJPNZ AND (NOT Z) AND T3;
JPNZY(1) <= IJPNZ AND (NOT Z) AND T4;
JPNZY(2) <= IJPNZ AND (NOT Z) AND T5;
JPNZN(0) <= IJPNZ AND Z AND T3;
JPNZN(1) <= IJPNZ AND Z AND T4;
ADD_OP <= IADD AND T3;
SUB_OP <= ISUB AND T3;
INAC <= IINAC AND T3;
CLAC <= ICLAC AND T3;
AND_OP <= IAND AND T3;
OR_OP <= IOR AND T3;XOR_OP <= IXOR AND T3;
NOT_OP <= INOT AND T3;
cnt_clr <= NOP OR LDAC(4) OR STAC(4) OR MVAC OR MOVR
OR JUMP(2) OR JMPZY(2) OR JMPZN(1)
OR JPNZY(2) OR JPNZN(1)
OR ADD_OP OR SUB_OP OR INAC OR CLAC
OR AND_OP OR OR_OP OR XOR_OP OR NOT_OP;
cnt_inc <= '1';
-- Based on Table 2
mOPs(26) <= FETCH(0) OR FETCH(2) OR LDAC(2) OR STAC(2); -- ARLOAD
mOPs(25) <= LDAC(0) OR STAC(0) OR JMPZY(0) OR JPNZY(0); -- ARINC
mOPs(24) <= JUMP(2) OR JMPZY(2) OR JPNZY(2); -- PCLOAD
mOPs(23) <= FETCH(1) OR LDAC(0) OR LDAC(1) OR STAC(0) OR STAC(1) OR JMPZN(0) OR JMPZN(1) OR
JPNZN(0) OR JPNZN(1); -- PCINC
mOPs(22) <= FETCH(1) OR LDAC(0) OR LDAC(1) OR LDAC(3) OR STAC(0) OR STAC(1) OR STAC(3) OR
JUMP(0) OR JUMP(1) OR JMPZY(0) OR JMPZY(1) OR JPNZY(0) OR JPNZY(1); -- DRLOAD
mOPs(21) <= LDAC(1) OR STAC(1) OR JUMP(1) OR JMPZY(1) OR JPNZY(1); -- TRLOAD
mOPs(20) <= FETCH(2); -- IRLOAD
mOPs(19) <= MVAC; -- RLOAD
mOPs(18) <= LDAC(4) OR MOVR OR ADD_OP OR SUB_OP OR INAC OR CLAC OR AND_OP OR OR_OP OR
XOR_OP OR NOT_OP; -- ACLOAD
mOPs(17) <= LDAC(4) OR MOVR OR ADD_OP OR SUB_OP OR INAC OR CLAC OR AND_OP OR OR_OP OR
XOR_OP OR NOT_OP; -- ZLOAD
mOPs(16) <= FETCH(1) OR LDAC(0) OR LDAC(1) OR LDAC(3) OR STAC(0) OR STAC(1) OR JUMP(0) OR
JUMP(1) OR JMPZY(0) OR JMPZY(1) OR JPNZY(0) OR JPNZY(1); -- READ
mOPs(15) <= STAC(4); -- WRITE
mOPs(14) <= FETCH(1) OR LDAC(0) OR LDAC(1) OR LDAC(3) OR STAC(0) OR STAC(1) OR JUMP(0) OR
JUMP(1) OR JMPZY(0) OR JMPZY(1) OR JPNZY(0) OR JPNZY(1); -- MEMBUSmOPs(13) <= STAC(4); -- BUSMEM
mOPs(12) <= FETCH(0) OR FETCH(2); -- PCBUS
mOPs(11) <= LDAC(1) OR LDAC(2) OR LDAC(4) OR STAC(1) OR STAC(2) OR STAC(4) OR JUMP(1) OR
JUMP(2) OR JMPZY(1) OR JMPZY(2) OR JPNZY(1) OR JPNZY(2); -- DRBUS
mOPs(10) <= LDAC(2) OR STAC(2) OR JUMP(2) OR JMPZY(2) OR JPNZY(2); -- TRBUS
mOPs(9) <= MOVR OR ADD_OP OR SUB_OP OR AND_OP OR OR_OP OR XOR_OP; -- RBUS
mOPs(8) <= STAC(3) OR MVAC; -- ACBUS
mOPs(7) <= AND_OP; -- ANDOP
mOPs(6) <= OR_OP; -- OROP
mOPs(5) <= XOR_OP; -- XOROP
mOPs(4) <= NOT_OP; -- NOTOP
mOPs(3) <= INAC; -- ACINC
mOPs(2) <= CLAC; -- ACZERO
mOPs(1) <= ADD_OP; -- PLUS
mOPs(0) <= SUB_OP; -- MINUS
end arc;