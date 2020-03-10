library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

entity subsystem is
    port(
          clock     : in std_logic;
          new_cmd   : in std_logic;          
          op_code   : in std_logic_vector( 3 downto 0 );
          arg_1     : in std_logic_vector( 3 downto 0 );
          arg_2     : in std_logic_vector( 3 downto 0 );

          result    : out std_logic_vector( 7 downto 0 ) := "00000000";
          err_flag  : out std_logic := '0'
         );
end subsystem;
----------------------------------------------------------------------------------
architecture beh of subsystem is

signal reg_1, reg_2, reg_3 : std_logic_vector( 7 downto 0 ) := "00000000"; 
signal clk_generator : std_ulogic_vector( 7 downto 0 ) := "00000001";
signal new_op_code : std_logic_vector( 3 downto 0 ) := "0000";

begin
   
    process( clock )  
    
        variable s_tmp_1, s_tmp_2, s_tmp_3 : signed(7 downto 0) := (others => '0');
        variable u_tmp_1, u_tmp_2, u_tmp_3 : unsigned(7 downto 0) := (others => '0');
        variable i_tmp_1, i_tmp_2, i_tmp_3 : integer := 0;

    begin
        
        -- Drive clock generator outputs at every clock period
        if( clock = '1' ) then
        
            clk_generator( 0 ) <= not( clk_generator( 7 ) );
            clk_generator( 1 ) <= not( clk_generator( 0 ) );
            clk_generator( 2 ) <= not( clk_generator( 1 ) );
            clk_generator( 3 ) <= not( clk_generator( 2 ) );
            clk_generator( 4 ) <= not( clk_generator( 3 ) );
            clk_generator( 5 ) <= not( clk_generator( 4 ) );
            clk_generator( 6 ) <= not( clk_generator( 5 ) );
            clk_generator( 7 ) <= not( clk_generator( 6 ) );
            
        end if;
             
        -- At T0 interval, arg_1 & Aag_2 are valid -- If new_cmd input is high, op_code is valid too
        if( clk_generator( 0 ) = '1' ) then reg_1 <= arg_1 & arg_2;
        
            reg_1 <= "0000" & arg_1;
            reg_2 <= "0000" & arg_2;
            
            if( new_cmd = '1' ) then new_op_code <= op_code;
            end if;        
             
        end if;
        
        -- At T7 interval, operation result is placed on output port
        if( clk_generator( 7 ) = '1' ) then result <= reg_3;
        end if;
        
       if( clk_generator( 1 ) = '1' ) then
        
            case( new_op_code ) is
            
                -- Copy1 : Result <-- ( Arg1 )
                when "0000" => reg_3 <= reg_1;
                err_flag <= '0';

                -- Copy2 : Result <-- ( Arg2 )
                when "0001" => reg_3 <= reg_2;
                err_flag <= '0';
    
                -- UnMinus1 : Result <-- ( -Arg1 )
                when "0010" => 
                err_flag <= '0';
                
                    u_tmp_1 := unsigned( not( reg_1 ) );        -- Get unsigned complment of arg_1
                    i_tmp_1 := to_integer( u_tmp_1 ) + 1;       -- Get integer of operation, add 1
                    u_tmp_2 := to_unsigned( i_tmp_1, 8 );       -- Get back to unsigned int
                    
                    -- Or with MSB = 1 for negative sign and store std_vec into reg 3
                    reg_3 <= std_logic_vector( ( u_tmp_2 or "10000000" ) );
    
                -- UnMinus2 : Result <-- ( -Arg2 )
                when "0011" => 
                err_flag <= '0';
                    
                    u_tmp_1 := unsigned( not( reg_2 ) );        -- Get unsigned complment of arg_2
                    i_tmp_1 := to_integer( u_tmp_1 ) + 1;       -- Get integer of operation, add 1
                    u_tmp_2 := to_unsigned( i_tmp_1, 8 );       -- Get back to unsigned int
                    
                    -- Or with MSB = 1 for negative sign and store std_vec into reg 3
                    reg_3 <= std_logic_vector( ( u_tmp_2 or "10000000" ) );
                    
                -- pow1 : Result <-- ( ( Arg1 ) *  2 ^ ( Arg2 ) )
                when "0100" => 
                err_flag <= '0';
                    
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                          
                    i_tmp_3 := ( i_tmp_1 * ( 2 ** i_tmp_2 ) );
                    u_tmp_3 := to_unsigned( i_tmp_3, 8 );
                    
                    reg_3 <= std_logic_vector( u_tmp_3 );
                    
                -- pow2 : Result <-- ( ( Arg2 ) *  2 ^ ( Arg1 ) )
                when "0101" => 
                err_flag <= '0';
    
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                          
                    i_tmp_3 := ( i_tmp_2 * ( 2 ** i_tmp_1 ) );
                    u_tmp_3 := to_unsigned( i_tmp_3, 8 );
                    
                    reg_3 <= std_logic_vector( u_tmp_3 );
                    
                -- add : Result <-- ( Arg1 + Arg2 )
                when "0110" => 
                err_flag <= '0';
                
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                               
                    i_tmp_3 := ( i_tmp_1 + i_tmp_2 );      
                    u_tmp_3 := to_unsigned( i_tmp_3, 8 ); 
                     
                    reg_3 <= std_logic_vector( u_tmp_3 );

                -- sub : Result <-- ( Arg1 - Arg2 )
                when "0111" => 
                err_flag <= '0';
                
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                               
                    i_tmp_3 := ( i_tmp_1 - i_tmp_2 );      
                    s_tmp_3 := to_signed( i_tmp_3, 8 ); 
                     
                    reg_3 <= std_logic_vector( s_tmp_3 );
    
                -- min : Result <-- ( min[ Arg1, Arg2 ] )
                when "1000" =>
                 err_flag <= '0';
   
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                  
                    if( i_tmp_1 <= i_tmp_2 ) then i_tmp_3 := i_tmp_1;
                    else i_tmp_3 := i_tmp_2;
                    end if;
                    
                   u_tmp_3 := to_unsigned( i_tmp_2, 8 ); 
                   reg_3 <= std_logic_vector( u_tmp_3 );

                -- max : Result <-- ( max[ Arg1, Arg2 ] )
                when "1001" => 
                err_flag <= '0';
               
                    u_tmp_1 := unsigned( reg_1 );  
                    i_tmp_1 := to_integer( u_tmp_1 );  
                        
                    u_tmp_2 := unsigned( reg_2 );       
                    i_tmp_2 := to_integer( u_tmp_2 ); 
                                  
                    if( i_tmp_1 >= i_tmp_2 ) then i_tmp_3 := i_tmp_1;
                    else i_tmp_3 := i_tmp_2;
                    end if;
                    
                   u_tmp_3 := to_unsigned( i_tmp_2, 8 ); 
                   reg_3 <= std_logic_vector( u_tmp_3 );
    
                -- BitInv1 : Result <-- ( ~Arg1 )
                when "1010" => reg_3 <= ( reg_1 xor reg_1 );
                err_flag <= '0';
    
                -- BitInv2 : Result <-- ( ~Arg2 )
                when "1011" => reg_3 <= ( reg_1 xor reg_2 );
                err_flag <= '0';
                    
                -- If wrong opcode entered, raise err flag
                when others => 
                
                    reg_3 <= "11111111";
                    err_flag <= '1';

            end case;
            
        end if;
        
    end process;
  
end beh;
