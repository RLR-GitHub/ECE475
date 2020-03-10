----------------------------------------------------------------------------------
-- ONE-SHOT TIMER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.all;

entity one_shot_beh is
    port(
          control_register : in std_logic_vector( 5 downto 0 ) := "111011";
          clk, start_pulse : in std_logic;
          output_pulse : out std_logic
         );
end one_shot_beh;
----------------------------------------------------------------------------------
architecture beh of one_shot_beh is

signal TIMER_REG, FD_INPUT, FD_OUTPUT : std_logic_vector( 5 downto 0 ) := control_register; 

signal STOP_FLAG : std_logic := '1';
signal CHANGE_FLAG : std_logic := '0';

begin
--================================================================================================================================
-- CLOCK
--================================================================================================================================
    process( clk, start_pulse, control_register ) 
    
        variable tmp_old : integer := to_integer( unsigned( FD_INPUT ) );
        variable tmp_new : integer := to_integer( unsigned( control_register ) );
        variable tmp_difference : integer := to_integer( unsigned( control_register ) ) - to_integer( unsigned( FD_INPUT ) );

    begin
    
        tmp_old := to_integer( unsigned( FD_INPUT ) );
        tmp_new := to_integer( unsigned( control_register ) );
        tmp_difference := to_integer( unsigned( control_register ) ) - to_integer( unsigned( FD_INPUT ) );
        
        if( start_pulse = '1' and clk = '0' ) then 
            
            FD_INPUT( 5 downto 0 ) <= TIMER_REG( 5 downto 0 );
            --
            CHANGE_FLAG <= '0';
            STOP_FLAG <= '0';
        
        end if; 
        
        if( control_register /= TIMER_REG and clk = '0' ) then
        
            CHANGE_FLAG <= '1';
            
            -- New_Time > Old_Time ==> TIMER_REG = NEW_TIME; FD_INPUT <= NEW_TIME - OLD_TIME
            if( tmp_new > tmp_old ) then FD_INPUT( 5 downto 0 ) <= std_logic_vector( to_unsigned( tmp_difference, TIMER_REG'length ) );
            
            -- New_Time < Old_Time ==> TIMER_REG = NEW_TIME; FD_INPUT <= NEW_TIME 
            elsif( tmp_new < tmp_old ) then FD_INPUT( 5 downto 0 ) <= std_logic_vector( to_unsigned( tmp_new, TIMER_REG'length ) );
            end if;
            
            TIMER_REG( 5 downto 0 ) <= control_register( 5 downto 0 );
    
            CHANGE_FLAG <= '0';
        
        end if;

        if( rising_edge( clk ) and STOP_FLAG = '0' and  change_flag = '0' ) then
                               
            if( FD_INPUT( 0 ) = '1' ) then 
            
                FD_INPUT( 0 ) <= '0';
                FD_OUTPUT( 0 ) <= '0';
                   
            elsif( FD_INPUT( 1 ) = '1' ) then 
            
                FD_INPUT( 1 downto 0 ) <= "01";
                FD_OUTPUT( 1 downto 0 ) <= "01";
                
            elsif( FD_INPUT( 2 ) = '1' ) then 
            
                FD_INPUT( 2 downto 0 ) <= "011";
                FD_OUTPUT( 2 downto 0 ) <= "011";
                
            elsif( FD_INPUT( 3 ) = '1' ) then 
            
                FD_INPUT( 3 downto 0 ) <= "0111";
                FD_OUTPUT( 3 downto 0 ) <= "0111";
                
            elsif( FD_INPUT( 4 ) = '1' ) then 
            
                FD_INPUT( 4 downto 0 ) <= "01111";
                FD_OUTPUT( 4 downto 0 ) <= "01111";
                
            elsif( FD_INPUT( 5 ) = '1' ) then 
            
                FD_INPUT( 5 downto 0 ) <= "011111";
                FD_OUTPUT( 5 downto 0 ) <= "011111";
        
            else

                FD_OUTPUT( 5 downto 0 ) <= TIMER_REG( 5 downto 0 );
                FD_INPUT( 5 downto 0 ) <= TIMER_REG( 5 downto 0 );

                STOP_FLAG <= '1';
                
            end if;

        end if;
            
        output_pulse <= not( STOP_FLAG );

    end process;

end beh;
