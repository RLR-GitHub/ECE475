library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity oneShotTimer is
    port(
          control_register : in std_logic_vector( 5 downto 0 ) := ( others => '0' );
          clk, rst, go, stop : in std_logic;
          pulse     : out std_logic
         );
end entity;

architecture arch of oneShotTimer is

    type TIMER_STATE is ( IDLE, COUNTING );
    signal PRES_STATE, NEXT_STATE : TIMER_STATE;
    signal COUNT_TARGET : integer := 0;
begin

    SET_PRESENT_REGISTER_STATE : process( clk, rst ) begin

        if( rst = '1' ) then PRES_STATE <= IDLE;
            elsif( rising_edge( clk ) ) then PRES_STATE <= NEXT_STATE;
        end if;

    end process SET_PRESENT_REGISTER_STATE;


    process( PRES_STATE, go, stop )


    begin
        COUNT_TARGET <= conv_integer( control_register );
        pulse <= '0';

        case( PRES_STATE ) is

            when idle =>

                if( go = '1' ) then NEXT_STATE <= COUNTING;
                    else NEXT_STATE <= IDLE;
                end if;

            when COUNTING =>


                for index in 0 to COUNT_TARGET loop

                    wait until rising_edge( clk );

                end loop;
                NEXT_STATE <= IDLE;


        end case;
    end process;
end arch;
