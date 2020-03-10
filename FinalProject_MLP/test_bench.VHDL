library work;
use work.functions.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is end tb;
architecture arch of tb is

component main_trial is port( clk, go : in std_logic; D, Y : out bit_vector( M downto 0 ); TRAINING_TESTING_FINISHED_FLAG : out std_logic );
end component;

constant t1 : time := 1 ns;
signal clk, go : std_logic := '0';

signal D, Y : bit_vector( M downto 0 ) := ( others => '0' );
signal target_row, actual_row : bit_vector( ( SIDE_LENGTH - 1 ) downto 0 ) := ( others => '0' );
signal TRAINING_TESTING_FINISHED_FLAG : std_logic;

begin
    go <= '1' after 1 ns;
    clk <= not( clk ) after 0.5 ns;
    
    UUT: main_trial  
    port map( go => go, clk => clk, D => D, Y => Y, TRAINING_TESTING_FINISHED_FLAG => TRAINING_TESTING_FINISHED_FLAG );

    process
    begin

        wait on TRAINING_TESTING_FINISHED_FLAG;

        for r in 0 to ( SIDE_LENGTH - 1 ) loop

            wait for t1;

            for c in 0 to ( SIDE_LENGTH - 1 ) loop

                target_row( c ) <= D( r * SIDE_LENGTH + c ); --after ( c * t1 );
                actual_row( c ) <= Y( r * SIDE_LENGTH + c ); --after ( c * t1 );
                
            end loop;

        end loop;                                                               
     
        wait;

    end process;

end arch;
