library IEEE;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

package FSM_LIBRARY is

--================================================================================================================================
-- VARIABLE_DECLARATIONS
--================================================================================================================================

    constant SEQUENCE_LENGTH : integer := ( 8 ); 
    constant SEQUENCE : bit_vector( ( SEQUENCE_LENGTH - 1 ) downto 0 ) := "00001010"; 
    
    constant K : integer := ( 4 ); -- NUMBER OF ROM INPUTS
    constant N : integer := ( 4 ); -- NUMBER OF ROM OUTPUTS 

    constant START_STATE : std_logic_vector( ( k - 1 ) downto 0 ) := ( others => '0' );
----------------------------------------------------------------------------------------------------------------------------------
-- TYPE DEFINITIONS 

    type STR is array( 0 to 1000 ) of std_logic;        
    type ROM is array( 0 to ( 15 ) ) of std_logic_vector( ( N - 1 ) downto 0 );   
      
    constant FSM_ROM : ROM := ( "0010", "0001", "0100", "0001", "0110", "0001", "1000", "0001", "1000", "1011", "1100", "0001", "0010", "1111", "0010", "0001" );
           
----------------------------------------------------------------------------------------------------------------------------------
    
    function load_rom_values return ROM;  
    function load_random_str return STR;  
    function load_next_state( vector_in : std_logic_vector ) return std_logic_vector;  
    
--================================================================================================================================

end package FSM_LIBRARY;

-----------------------------------------------------------------------------------------------------------------------------
package body FSM_LIBRARY is

--================================================================================================================================
-- FUNCTION_DEFINITIONS
--================================================================================================================================
    function load_rom_values return ROM is variable FSM_ROM : ROM;
    begin
        return( FSM_ROM );
    end function;
-----------------------------------------------------------------------------------------------------------------------------
    function load_random_str return STR is variable RANDOM_STR : STR;
        variable r_tmp_1 : real;
        variable seed1 : integer := 7;
        variable seed2 : integer := 7532;

    begin
        for index in 0 to 1000 loop
            uniform( seed1, seed2, r_tmp_1 ); -- returns pseudo-random number between 0.0 and 1.0
            if( r_tmp_1 > 0.5 ) then RANDOM_STR( index ) := '1';
                else RANDOM_STR( index ) := '0';
            end if;
        end loop;
        return( RANDOM_STR );
    end function; 
-----------------------------------------------------------------------------------------------------------------------------
    function load_next_state( vector_in : std_logic_vector ) return std_logic_vector is variable NEXT_STATE : std_logic_vector( ( k - 1 ) downto 0 );  
    begin
        case( vector_in ) is
        
            -- PS A
            when "0000" => NEXT_STATE := "0010";
            when "0001" => NEXT_STATE := "0000";
            
            -- PS B
            when "0010" => NEXT_STATE := "0100";
            when "0011" => NEXT_STATE := "0000";
            
            -- PS C
            when "0100" => NEXT_STATE := "0110";
            when "0101" => NEXT_STATE := "0000";   
                     
            -- PS D
            when "0110" => NEXT_STATE := "1000";
            when "0111" => NEXT_STATE := "0000";
            
            -- PS E
            when "1000" => NEXT_STATE := "1000";
            when "1001" => NEXT_STATE := "1010";
            
            -- PS F
            when "1010" => NEXT_STATE := "1100";
            when "1011" => NEXT_STATE := "0000";
            
            -- PS G
            when "1100" => NEXT_STATE := "0010";
            when "1101" => NEXT_STATE := "1110";
            
            -- PS H
            when "1110" => NEXT_STATE := "0011";
            when "1111" => NEXT_STATE := "0000";
            
            when others => NULL;-- => NEXT_STATE := "0000";
            
        end case;
        
        return( NEXT_STATE );
        
    end function;
--================================================================================================================================

end package body FSM_LIBRARY;
