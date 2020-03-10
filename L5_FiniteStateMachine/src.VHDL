--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR4 is port( i1, i2, i3, i4 : in std_logic := '0'; o : inout std_logic );
end OR4;

architecture arch of OR4 is begin o <= i1 or i2 or i3 or i4;
end arch;
--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR5 is port( i1, i2, i3, i4, i5 : in std_logic := '0'; o : inout std_logic );
end OR5;

architecture arch of OR5 is begin o <= i1 or i2 or i3 or i4 or i5;
end arch;
--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR6 is port( i1, i2, i3, i4, i5, i6 : in std_logic := '0'; o : inout std_logic );
end OR6;

architecture arch of OR6 is begin o <= i1 or i2 or i3 or i4 or i5 or i6;
end arch;
--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is port( clk, d : in std_logic := '0'; q : inout std_logic );
end DFF;

architecture arch of DFF is begin
    process( clk ) begin
        if( rising_edge( clk ) ) then 
            if( d = '1' ) then q <= '1';
                else q <= '0';
            end if;
        end if;
    end process;
end arch;
--================================================================================================================================
library work;
library IEEE;

use work.FSM_LIBRARY.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DCD is port( input : in std_logic_vector( 3 downto 0 ) := "0000"; output : inout std_logic_vector( 15 downto 0 ) );
end DCD;
    

architecture arch of DCD is 

    signal cleared_reg : std_logic_vector( 15 downto 0 ) := ( others => '0' );
    
begin
    
    process( input ) begin

        cleared_reg <= ( others => '0' );
        cleared_reg( conv_integer( input ) ) <= '1';
               
   end process;
   
   output <= cleared_reg;

end arch;
--================================================================================================================================
library work;
library IEEE;

use work.FSM_LIBRARY.all;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is port( clk, x : in std_logic := '0'; z : out std_logic );
end FSM;
 
--================================================================================================================================

architecture beh of FSM is

    signal PRES_STATE : std_logic_vector( ( k - 1 ) downto 0 ) := START_STATE;
    signal NEXT_STATE : std_logic_vector( ( k - 1 ) downto 0 ) := load_next_state( START_STATE );

begin
    
    CLOCK_IN : process( clk, x, PRES_STATE ) 
    
        variable TMP_PRES_STATE, TMP_NEXT_STATE : std_logic_vector( ( k - 1 ) downto 0 );
        
    begin
        TMP_PRES_STATE := PRES_STATE;
        TMP_PRES_STATE( 0 ) := x;
        
        PRES_STATE <= TMP_PRES_STATE;

        TMP_NEXT_STATE := load_next_state( PRES_STATE );
        NEXT_STATE <= TMP_NEXT_STATE;
        z <= TMP_NEXT_STATE( 0 );
        
        if( rising_edge( clk ) ) then
        
            PRES_STATE <= NEXT_STATE;
            
        end if;
        
    end process CLOCK_IN;
    
end beh;
--================================================================================================================================
architecture struct of FSM is

    component DCD port( input : in std_logic_vector( 3 downto 0 ); output : inout std_logic_vector( 15 downto 0 ) );
    end component;
    
    component OR6 port( i1, i2, i3, i4, i5, i6 : in std_logic := '0'; o : inout std_logic );
    end component;

    component OR5 port( i1, i2, i3, i4, i5 : in std_logic := '0'; o : inout std_logic );
    end component;

    component OR4 port( i1, i2, i3, i4 : in std_logic := '0'; o : inout std_logic );
    end component;
    
    component DFF port( clk, d : in std_logic := '0'; q : inout std_logic := '0' );
    end component;

    signal PRES_STATE : std_logic_vector( ( k - 1 ) downto 0 ) := START_STATE;  
    signal OR_OUT, DFF_OUT : std_logic_vector( 1 to 3 ) := ( others => '0' );
    signal DCD_OUT : std_logic_vector( 15 downto 0 );
    
begin
   
    DCD_UNIT_0 : DCD port map( input => PRES_STATE, output => DCD_OUT );

    OR6_UNIT_1 : OR6 port map( i1 => DCD_OUT( 0 ), i2 => DCD_OUT( 4 ), i3 => DCD_OUT(  9 ), i4 => DCD_OUT( 12 ), i5 => DCD_OUT( 13 ), i6 => DCD_OUT( 14 ), o => OR_OUT( 1 ) );     
    OR4_UNIT_2 : OR4 port map( i1 => DCD_OUT( 2 ), i2 => DCD_OUT( 4 ), i3 => DCD_OUT( 10 ), i4 => DCD_OUT( 13 ), o => OR_OUT( 2 ) ); 
    OR5_UNIT_3 : OR5 port map( i1 => DCD_OUT( 6 ), i2 => DCD_OUT( 8 ), i3 => DCD_OUT(  9 ), i4 => DCD_OUT( 10 ), i5 => DCD_OUT( 13 ), o => OR_OUT( 3 ) ); 

    DETECTOR_Z : z <= DCD_OUT( 14 );
    DFF_UNIT_1 : DFF port map( clk => clk, d => OR_OUT( 1 ), q => DFF_OUT( 1 ) );
    DFF_UNIT_2 : DFF port map( clk => clk, d => OR_OUT( 2 ), q => DFF_OUT( 2 ) );
    DFF_UNIT_3 : DFF port map( clk => clk, d => OR_OUT( 3 ), q => DFF_OUT( 3 ) ); 

    ADDRLINE_0 : PRES_STATE( 0 ) <= x;  
    ADDRLINE_1 : PRES_STATE( 1 ) <= DFF_OUT( 1 );
    ADDRLINE_2 : PRES_STATE( 2 ) <= DFF_OUT( 2 );
    ADDRLINE_3 : PRES_STATE( 3 ) <= DFF_OUT( 3 );  
          
end struct;
--================================================================================================================================
