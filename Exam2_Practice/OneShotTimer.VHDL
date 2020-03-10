library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity oneShotTimer is
    port(
          control_register : in std_logic_vector( 5 downto 0 ) := ( others => '0' );
          clk, start_pulse : in std_logic;
          output_pulse     : out std_logic
         );
end entity;

architecture arch of oneShotTimer is

    signal done_flag : boolean := FALSE;
    signal trigger_flag : boolean := FALSE;
    signal start_counter_flag : boolean := FALSE;

begin

    TRIGGER : process( clk ) begin

        if( trigger_flag = FALSE ) then wait on start_pulse;
        end if;

        trigger_flag <= TRUE;

    ene process TRIGGER;


    INIT : process

        variable TMP_CONTROL_REGISTER : std_logic_vector( 5 downto 0 ) := ( others => '0' );
        variable COUNT_TARGET : integer := 0;

    begin

        wait until trigger_flag = TRUE;

        TMP_CONTROL_REGISTER := control_register;
        COUNT_TARGET := conv_integer( TMP_CONTROL_REGISTER );

        for index in 0 to COUNT_TARGET loop

            if( rising_edge( clk ) ) then

                count := count + 1;
            end if;
        end loop;

        done_flag <= TRUE;

    end process INIT;


end arch;
