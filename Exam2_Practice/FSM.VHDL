library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
  port ( clk, x : in std_logic := '0'; z : out std_logic );
end ROM;

architecture beh of ROM is

  type ROM is array( 15 downto 0 ) of std_logic_vector( 3 downto 0 ) := ( others => '0' );
  constant FSM_ROM : ROM := ( "1001", "1010", "0000", "0001",
                              "1001", "1010", "0000", "0001",
                              "1001", "1010", "0000", "0001",
                              "1001", "1010", "0000", "0001" );

  signal PRES_STATE, NEXT_STATE : std_logic_vector( 3 downto 0 ) := ( others => '0' );

begin

    CLOCK_IN : process( clk )

        variable TMP_PRES_STATE, TMP_NEXT_STATE : std_logic_vector( 3 downto 0 ) := ( others => '0' );

    begin

        TMP_PRES_STATE := PRES_STATE;
        TMP_PRES_STATE( 0 ) := x;
        PRES_STATE <= TMP_PRES_STATE;

        TMP_NEXT_STATE := FSM_ROM( conv_integer( PRES_STATE ) );
        z <= TMP_NEXT_STATE( 0 );
        NEXT_STATE <= TMP_NEXT_STATE;

        if( rising_edge( clk ) ) then PRES_STATE <= NEXT_STATE;
        end if;

    end process CLOCK_IN;

end beh;
