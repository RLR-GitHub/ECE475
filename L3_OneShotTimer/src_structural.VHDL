----------------------------------------------------------------------------------
-- ONE-SHOT TIMER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity one_shot is 
    port( 
          control_register : in std_logic_vector( 5 downto 0 ) := "111011";
          clk, start_pulse : in std_logic; 
          output_pulse : out std_logic 
         );
end one_shot;
----------------------------------------------------------------------------------
architecture Structural of one_shot is

component MUXF8 port( i0, i1, s : in std_logic; o : out std_logic ); 
end component;

component AND3 port( i0, i1, i2 : in std_logic; o : out std_logic );
end component;

component AND2 port( i0, i1 : in std_logic; o : out std_logic );
end component;

component OR3 port( i0, i1, i2 : in std_logic; o : out std_logic );
end component;

component OR2 port( i0, i1 : in std_logic; o : out std_logic );
end component;

component INV port( i: in std_logic; o : out std_logic );
end component;

component FD port( c, d : in std_logic; q : out std_logic );
end component;

signal TIMER_REG : std_logic_vector( 5 downto 0 ) := "111011"; -- ( 59 )dec
signal FD_INPUT  : std_logic_vector( 5 downto 0 ) := "111011"; -- ( 59 )dec
signal FD_OUTPUT : std_logic_vector( 5 downto 0 ) := "111011"; -- ( 59 )dec
signal FD_OUTBAR : std_logic_vector( 5 downto 0 );

signal OUTPUT_FLAG, START_FLAG, STOP_FLAG, END_FLAG : std_logic := '0';
signal TRIGGER_TOGGLE_STOP_FLAG : std_logic := '0';
signal TOGGLE_STOP_FLAG : std_logic := '1';

signal or_w1, or_w2, or_w3 : std_logic;
signal and_w1, and_w2 : std_logic;

begin
    --============================================================================================================
    -- ASSERT DELAY FLAG WHEN START PULSE IS HIGH FOR 1 CLOCK CYCLE
    --============================================================================================================
    FLAG  : INV port map( i  => STOP_FLAG, o => TOGGLE_STOP_FLAG );
    START : FD  port map( c  => clk, d => start_pulse, q => START_FLAG );
    CHANGE: OR2 port map( i0 => START_FLAG, i1 => END_FLAG, o => TRIGGER_TOGGLE_STOP_FLAG );
    TOGGLE: FD  port map( c  => TRIGGER_TOGGLE_STOP_FLAG, d => TOGGLE_STOP_FLAG, q => STOP_FLAG );
    --============================================================================================================
    -- IF MUX SEL == 0 LOAD CONTROL REGISTER VALUES INTO D FLIP-FLOPS FOR TIMER INITIALIZATION; ELSE COUNTDOWN
    --============================================================================================================
    MUX_0: MUXF8 port map( i0 => TIMER_REG( 0 ), i1 => FD_OUTBAR( 0 ), s => STOP_FLAG, o => FD_INPUT( 0 ) );
    DFF_0: FD    port map( c  => clk, d  => FD_INPUT(  0 ), q => FD_OUTPUT( 0 ) );
    INV_0: INV   port map( i  => FD_OUTPUT( 0 ), o  => FD_OUTBAR( 0 ) );

    MUX_1: MUXF8 port map( i0 => TIMER_REG( 1 ), i1 => FD_OUTBAR( 1 ), s => STOP_FLAG, o => FD_INPUT( 1 ) );
    DFF_1: FD    port map( c  => FD_OUTPUT( 0 ), d  => FD_INPUT(  1 ), q => FD_OUTPUT( 1 ) );
    INV_1: INV   port map( i  => FD_OUTPUT( 1 ), o  => FD_OUTBAR( 1 ) );

    MUX_2: MUXF8 port map( i0 => TIMER_REG( 2 ), i1 => FD_OUTBAR( 2 ), s => STOP_FLAG, o => FD_INPUT( 2 ) );
    DFF_2: FD    port map(  c => FD_OUTPUT( 1 ), d  => FD_INPUT(  2 ), q => FD_OUTPUT( 2 ) );
    INV_2: INV   port map(  i => FD_OUTPUT( 2 ), o  => FD_OUTBAR( 2 ) );

    MUX_3: MUXF8 port map( i0 => TIMER_REG( 3 ), i1 => FD_OUTBAR( 3 ), s => STOP_FLAG, o => FD_INPUT( 3 ) );
    DFF_3: FD    port map( c  => FD_OUTPUT( 2 ), d  => FD_INPUT(  3 ), q => FD_OUTPUT( 3 ) );
    INV_3: INV   port map( i  => FD_OUTPUT( 3 ), o  => FD_OUTBAR( 3 ) );

    MUX_4: MUXF8 port map( i0 => TIMER_REG( 4 ), i1 => FD_OUTBAR( 4 ), s => STOP_FLAG, o => FD_INPUT( 4 ) );
    DFF_4: FD    port map( c  => FD_OUTPUT( 3 ), d  => FD_INPUT(  4 ), q => FD_OUTPUT( 4 ) );
    INV_4: INV   port map( i  => FD_OUTPUT( 4 ), o  => FD_OUTBAR( 4 ) );

    MUX_5: MUXF8 port map( i0 => TIMER_REG( 5 ), i1 => FD_OUTBAR( 5 ), s => STOP_FLAG, o => FD_INPUT( 5 ) );
    DFF_5: FD    port map( c  => FD_OUTPUT( 4 ), d  => FD_INPUT(  5 ), q => FD_OUTPUT( 5 ) );
    INV_5: INV   port map( i  => FD_OUTPUT( 5 ), o  => FD_OUTBAR( 5 ) );
    --============================================================================================================
    -- SET OUTPUT PULSE HIGH IF ANY OF THE FD OUTPUTS ARE HIGH
    --====================================================================================================================================
    OUT_1: OR3  port map( i0 => FD_OUTBAR( 0 ), i1 => FD_OUTBAR( 1 ), i2 => FD_OUTBAR( 2 ), o => or_w1 );
    OUT_2: OR3  port map( i0 => FD_OUTBAR( 3 ), i1 => FD_OUTBAR( 4 ), i2 => FD_OUTBAR( 5 ), o => or_w2 );
    OUT_3: OR2  port map( i0 =>          or_w1, i1 =>          or_w2,  o => or_w3 );
    AND_0: AND2 port map( i0 => STOP_FLAG, i1 => or_w3, o => OUTPUT_FLAG );
    PULSE: FD   port map( c  => clk, d => OUTPUT_FLAG, q => output_pulse );
    --====================================================================================================================================
    -- RESET FINISH FLAGS
    --====================================================================================================================================
    AND_1: AND3 port map( i0 => FD_INPUT( 0 ), i1 => FD_INPUT( 1 ), i2 => FD_INPUT( 2 ), o => and_w1 );
    AND_2: AND3 port map( i0 => FD_INPUT( 3 ), i1 => FD_INPUT( 4 ), i2 => FD_INPUT( 5 ), o => and_w2 );
    AND_3: AND2 port map( i0 => and_w1, i1 => and_w2, o => END_FLAG ); 
    --====================================================================================================================================
end Structural;
