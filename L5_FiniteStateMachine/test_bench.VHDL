--================================================================================================================================
library work;
library IEEE;

use work.FSM_LIBRARY.all;
use IEEE.STD_LOGIC_1164.ALL;
--================================================================================================================================

entity tb is end tb;
architecture tb_architecture of tb is

component FSM
    port( clk, x : in std_logic := '0'; z : out std_logic );
end component;

    signal z_beh, z_struct : std_logic;
    signal clk, x_beh, x_struct : std_logic := '0';
    constant RND_STR : STR := load_random_str;
    
    for UUT_BEH : FSM use entity work.FSM( beh );
    for UUT_STRUCT : FSM use entity work.FSM( struct );

begin

    UUT_STRUCT: FSM port map( clk => clk, x => x_struct, z => z_struct );
    UUT_BEH: FSM port map( clk => clk, x => x_beh, z => z_beh );
    
    clk <= not( clk ) after 0.5 ns;
    
    process( clk )
    
        variable count : integer := 0;
        variable RND_BIT : std_logic;
    
    begin
        if( rising_edge( clk ) ) then
            RND_BIT := RND_STR( count mod 999 );
            x_struct <= RND_BIT;
            x_beh <= RND_BIT;
            count := count + 1;
        end if;
    end process;
    
end tb_architecture;
