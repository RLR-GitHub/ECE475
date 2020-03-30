--================================================================================================================================
-- 4:1 Mux
--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
    port( select_lines : in std_logic_vector( 2 downto 0 ) := ( others => '0' ); 
          j0, j1, j2, j3, k0, k1, k2, k3 : in std_logic; 
          j, k : out std_logic );
end MUX;
    
architecture arch of MUX is begin

   -- process( select_lines ) begin

    process( select_lines, j0, j1, j2, j3, k0, k1, k2, k3 ) begin
    
        case( select_lines ) is 
            
            -- Dime input
            when "001" => 
                j <= j1;
                k <= k1;
                
            -- Quarter input
            when "010" => 
                j <= j2;
                k <= k2;
                
            -- Dollar bill input
            when "100" => 
                j <= j3;
                k <= k3;
                
            -- Default state    
            when others => 
                j <= j0;
                k <= k0;
            
        end case;
        
    end process;
    
end arch;
--================================================================================================================================
-- JK Flip-Flop
--================================================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JKFF is 
    port( clk, j, k : in std_logic := '0'; q : inout std_logic := '0' );
end JKFF;

architecture arch of JKFF is begin
    process( clk ) begin
        if( rising_edge( clk ) ) then 
            if( j = '0' and k ='0' ) then q <= q;
            end if;
            if( j = '0' and k ='1' ) then q <= '0';
            end if; 

            if( j = '1' and k ='0' ) then q <= '1';
            end if;

            if( j = '1' and k ='1' ) then q <= not( q );
            end if;

        end if;
    end process;
end arch;
--================================================================================================================================
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity OR_PLANE is 
    port( input : in std_logic_vector( 0 to 19 ); output : out std_logic_vector( 0 to 29 ) );
end OR_PLANE;
    

architecture arch of OR_PLANE is begin
    
    -- Set of 10 JK flip flop inputs ( j4k4, j3,k3, j2k2, j1k1, j0k0 ) for DIME input state
    output(  0 ) <= input( 14 ) or input( 15 ); -- J4
    output(  1 ) <= '0'; -- K4
    output(  2 ) <= input( 6 ) or input( 7 ); -- J3
    output(  3 ) <= input( 14 ) or input( 15 ); -- K3
    output(  4 ) <= input( 2 ) or input( 3 ) or input( 10 ) or input( 11 ); -- J2
    output(  5 ) <= input( 6 ) or input( 7 ) or input( 14 ) or input( 15 ); -- K2
    output(  6 ) <= input( 1 ) or input( 4 ) or input( 5 ) or input( 8 ) or input( 9 ) or input( 12 ) or input( 13 ) or input( 16 ) or input( 17 ); -- J1
    output(  7 ) <= input( 2 ) or input( 3 ) or input( 6 ) or input( 7 ) or input( 10 ) or input( 11 ) or input( 14 ) or input( 15 ); -- K1
    output(  8 ) <= input( 0 ) or input( 18 ); -- J0
    output(  9 ) <= input( 1 ); -- K0

    -- Set of 10 JK flip flop inputs ( j4k4, j3,k3, j2k2, j1k1, j0k0 ) for QUARTER input state
    output( 10 ) <= input( 11 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- J4
    output( 11 ) <= '0'; -- K4
    output( 12 ) <= input( 3 ) or input( 4 ) or input( 5 ) or input( 6 ) or input( 7 ); -- J3
    output( 13 ) <= input( 11 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- K3
    output( 14 ) <= input( 1 ) or input( 2 ) or input( 8 ) or input( 9 ) or input( 10 ); -- J2
    output( 15 ) <= input( 4 ) or input( 5 ) or input( 6 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- K2
    output( 16 ) <= input( 0 ) or input( 5 ) or input( 9 ) or input( 16 ) or input( 17 ); -- J1
    output( 17 ) <= input( 3 ) or input( 7 ) or input( 11 ); -- K1
    output( 18 ) <= input( 0 ) or input( 2 ) or input( 4 ) or input( 6 ) or input( 8 ) or input( 10 ) or input( 12 ) or input( 14 ) or input( 16 ) or input( 18 ); -- J0
    output( 19 ) <= input( 3 ) or input( 5 ) or input( 7 ) or input( 9 ) or input( 11 ); -- K0
    
    -- Set of 10 JK flip flop inputs ( j4k4, j3,k3, j2k2, j1k1, j0k0 ) for DOLLAR BILL input state
    output( 20 ) <= input( 0 ) or input( 1 ) or input( 2 ) or input( 3 ) or input( 4 ) or input( 5 ) or input( 6 ) or input( 7 ) or input( 8 ) or input( 9 ) or input( 10 ) or input( 11 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- J4
    output( 21 ) <= '0'; -- K4
    output( 22 ) <= '0'; -- J3
    output( 23 ) <= input( 8 ) or input( 9 ) or input( 10 ) or input( 11 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- K3
    output( 24 ) <= '0'; -- J2
    output( 25 ) <= input( 4 ) or input( 5 ) or input( 6 ) or input( 7 ) or input( 12 ) or input( 13 ) or input( 14 ) or input( 15 ); -- K2
    output( 26 ) <= input( 0 ) or input( 1 ) or input( 4 ) or input( 5 ) or input( 8 ) or input( 9 ) or input( 12 ) or input( 13 ) or input( 16 ) or input( 17 ); -- J1
    output( 27 ) <= '0'; -- K1
    output( 28 ) <= input( 2 ) or input( 4 ) or input( 6 ) or input( 8 ) or input( 10 ) or input( 12 ) or input( 14 ) or input( 16 ) or input( 18 ); -- J0
    output( 29 ) <= '0'; -- K0

end arch;
--================================================================================================================================
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DCD is 
    port( input : in std_logic_vector( 4 downto 0 ) := ( others => '0' ); output : inout std_logic_vector( 0 to 19 ) );
end DCD;
    

architecture arch of DCD is 

    signal cleared_reg : std_logic_vector( 0 to 19 ) := ( others => '0' );
    
begin
    
    process( input ) begin

        cleared_reg <= ( others => '0' );
        cleared_reg( conv_integer( input ) ) <= '1';
               
   end process;
   
   output <= cleared_reg;

end arch;
--================================================================================================================================
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RETURN_STATE is 
    port( select_lines : in std_logic_vector( 2 downto 0 ) := ( others => '0' ); 
          vm_state : in std_logic_vector( 4 downto 0 ); 
          dispense : out boolean;
          change : out integer );
end RETURN_STATE;
    

architecture arch of RETURN_STATE is 

    type CHANGE_ROM is array( 0 to 11 ) of integer;
    constant CHANGE_VECTOR : CHANGE_ROM := ( 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 55, 55 );
    
    signal CURRENCY_INPUT_STATE_INDEX : integer := 0; 
    signal RETURN_STATE_INDEX : integer := 0;
    signal dispense_item : boolean := False;
    
begin
    
    process( select_lines, vm_state ) begin

        CURRENCY_INPUT_STATE_INDEX <= conv_integer( vm_state );

        -- If currency input state is less than 8, not enough money to buy any item -- return state zero
        if( CURRENCY_INPUT_STATE_INDEX < 8 ) then RETURN_STATE_INDEX <= 0;
        
            
            -- Else look at item select lines 
            else
        
                case( select_lines ) is
        
                    -- Item 1 selected ( cost = $0.45 )
                    when "001" =>
                        RETURN_STATE_INDEX <= CURRENCY_INPUT_STATE_INDEX - 8;
                        dispense_item <= True;
                        
                    -- Item 2 selected ( cost = $0.75 )                        
                    when "010" =>
                        if( CURRENCY_INPUT_STATE_INDEX > 13 ) then 
                            RETURN_STATE_INDEX <= CURRENCY_INPUT_STATE_INDEX - 13;
                            dispense_item <= True;
                        end if;
                         
                    -- Item 3 selected ( cost = $0.80 )                    
                    when "011" =>
                        if( CURRENCY_INPUT_STATE_INDEX < 14 ) then 
                            RETURN_STATE_INDEX <= CURRENCY_INPUT_STATE_INDEX - 14;
                            dispense_item <= True;
                        end if; 
                    
                    when "100" =>
                        if( CURRENCY_INPUT_STATE_INDEX > 17 ) then 
                            dispense_item <= True;
                        end if;
                        
                        RETURN_STATE_INDEX <= 0;
                        
                    -- Default to return value state zero ( $0.00 )
                    when others =>
                        RETURN_STATE_INDEX <= 0;
                        dispense_item <= False;
                        
                end case;
                
        end if;

                     
   end process;

    dispense <= dispense_item;
    change <= CHANGE_VECTOR( RETURN_STATE_INDEX );
    
end arch;
--================================================================================================================================



--================================================================================================================================

--================================================================================================================================

-- MAX INPUT: $1.9 -- max input that vending machine may take in at any given time is 1.9 dollars... This would be the case
-- where a user puts in 90 cents into the vending machine, followed by a one-dollar bill, to top the one-dollar value for
-- the most expensive item
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending_machine is
    port( CLK : in std_logic; 
          CURRENCY_INPUT_SELECT_LINES, ITEM_INPUT_SELECT_LINES : in std_logic_vector( 2 downto 0 ) := ( others => '0' );
          DISPENSE : inout boolean;
          CHANGE : out integer );
end vending_machine;

architecture arch of vending_machine is

    component DCD 
        port( input : in std_logic_vector( 4 downto 0 ); output : inout std_logic_vector( 0 to 19 ) );
    end component;
    
    component OR_PLANE 
        port( input : in std_logic_vector( 0 to 19 ); output : out std_logic_vector( 0 to 29 ) );
    end component;

    component MUX is 
        port( select_lines : in std_logic_vector( 2 downto 0 ) := ( others => '0' ); 
              j0, j1, j2, j3, k0, k1, k2, k3 : in std_logic; 
              j, k : out std_logic );
    end component;
    
    component JKFF
        port( clk, j, k : in std_logic := '0'; q : inout std_logic );
    end component;
    
    component RETURN_STATE is
        port( select_lines : in std_logic_vector( 2 downto 0 ) := ( others => '0' ); 
              vm_state : in std_logic_vector( 4 downto 0 ); 
              dispense : out boolean;
              change : out integer );
    end component;
    
    --signal RETURN_STATE_INDEX : integer := 0;
    
    signal DCD_OUT : std_logic_vector( 0 to 19 ); 
    signal OR_PLANE_OUT : std_logic_vector( 0 to 29 ); 
    signal PRESENT_STATE : std_logic_vector( 4 downto 0 ) := ( others => '0' ); 
    signal FF_INPUT_J, FF_INPUT_K, FF_OUTPUT : std_logic_vector( 4 downto 0 );
    
begin

    DCD_UNIT_0 : DCD port map( input => PRESENT_STATE, output => DCD_OUT );
    OR_PLANE_0 : OR_PLANE port map( input => DCD_OUT, output => OR_PLANE_OUT );

    --MUX ports to jk flip flop for MSB -- J4, K4
    MUX_PORT_4 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
                               j0 =>  FF_OUTPUT(     4 ), k0 =>  FF_OUTPUT(  4 ),
                               j1 =>  OR_PLANE_OUT(  0 ), k1 =>  OR_PLANE_OUT(  1 ),
                               j2 =>  OR_PLANE_OUT( 10 ), k2 =>  OR_PLANE_OUT( 11 ),
                               j3 =>  OR_PLANE_OUT( 20 ), k3 =>  OR_PLANE_OUT( 21 ),
                               j  =>    FF_INPUT_J(  4 ), k  =>    FF_INPUT_K(  4 ) );
    
        -- MUX ports to jk flip flop -- J3, K3
    MUX_PORT_3 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
                               j0 =>  FF_OUTPUT(     3 ), k0 =>  FF_OUTPUT(  3 ),
                               j1 =>  OR_PLANE_OUT(  2 ), k1 =>  OR_PLANE_OUT(  3 ),
                               j2 =>  OR_PLANE_OUT( 12 ), k2 =>  OR_PLANE_OUT( 13 ),
                               j3 =>  OR_PLANE_OUT( 22 ), k3 =>  OR_PLANE_OUT( 23 ),
                               j  =>    FF_INPUT_J(  3 ), k  =>    FF_INPUT_K(  3 ) );
                               
        -- MUX ports to jk flip flop -- J2, K2
    MUX_PORT_2 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
                               j0 =>  FF_OUTPUT(     2 ), k0 =>  FF_OUTPUT(  2 ),
                               j1 =>  OR_PLANE_OUT(  4 ), k1 =>  OR_PLANE_OUT(  5 ),
                               j2 =>  OR_PLANE_OUT( 14 ), k2 =>  OR_PLANE_OUT( 15 ),
                               j3 =>  OR_PLANE_OUT( 24 ), k3 =>  OR_PLANE_OUT( 25 ),
                               j  =>    FF_INPUT_J(  2 ), k  =>    FF_INPUT_K(  2 ) );                             

        -- MUX ports to jk flip flop -- J1, K1
    MUX_PORT_1 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
                               j0 =>  FF_OUTPUT(     1 ), k0 =>  FF_OUTPUT(  1 ),
                               j1 =>  OR_PLANE_OUT(  6 ), k1 =>  OR_PLANE_OUT(  7 ),
                               j2 =>  OR_PLANE_OUT( 16 ), k2 =>  OR_PLANE_OUT( 17 ),
                               j3 =>  OR_PLANE_OUT( 26 ), k3 =>  OR_PLANE_OUT( 27 ),
                               j  =>    FF_INPUT_J(  1 ), k  =>    FF_INPUT_K(  1 ) );   
   
        -- MUX ports to jk flip flop -- J0, K0
    MUX_PORT_0 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
                               j0 =>  FF_OUTPUT(     0 ), k0 =>  FF_OUTPUT(  0 ),
                               j1 =>  OR_PLANE_OUT(  8 ), k1 =>  OR_PLANE_OUT(  9 ),
                               j2 =>  OR_PLANE_OUT( 18 ), k2 =>  OR_PLANE_OUT( 19 ),
                               j3 =>  OR_PLANE_OUT( 28 ), k3 =>  OR_PLANE_OUT( 29 ),
                               j  =>    FF_INPUT_J(  0 ), k  =>    FF_INPUT_K(  0 ) );  
                             
    JK_OUT_4: JKFF port map( clk => clk, j => FF_INPUT_J( 4 ), k => FF_INPUT_K( 4 ), q => FF_OUTPUT( 4 ) );                                                          
    JK_OUT_3: JKFF port map( clk => clk, j => FF_INPUT_J( 3 ), k => FF_INPUT_K( 3 ), q => FF_OUTPUT( 3 ) );                                                          
    JK_OUT_2: JKFF port map( clk => clk, j => FF_INPUT_J( 2 ), k => FF_INPUT_K( 2 ), q => FF_OUTPUT( 2 ) );                                                          
    JK_OUT_1: JKFF port map( clk => clk, j => FF_INPUT_J( 1 ), k => FF_INPUT_K( 1 ), q => FF_OUTPUT( 1 ) );                                                          
    JK_OUT_0: JKFF port map( clk => clk, j => FF_INPUT_J( 0 ), k => FF_INPUT_K( 0 ), q => FF_OUTPUT( 0 ) );                                                          

    RETURN_0 : RETURN_STATE port map( select_lines => ITEM_INPUT_SELECT_LINES, vm_state => PRESENT_STATE, dispense => DISPENSE, change => CHANGE );
    --PRESENT_STATE <= FF_OUTPUT;
    process( clk ) begin
        if( DISPENSE = True and rising_edge( CLK ) ) then PRESENT_STATE <= "00000";
            else PRESENT_STATE <= FF_OUTPUT;
        end if;
    end process;
end arch;

    --FF_INPUTS : for i in 4 downto 0 generate   
    --    JKFF_INPUT : JKFF port map( clk => clk, j => FF_INPUT_J( i ), k => FF_INPUT_K( i ), q => PRESENT_STATE( i ) );                                                          
    --end generate FF_INPUTS;

    -- MUX ports to jk flip flop for MSB -- J4, K4
   -- MUX_PORT_4 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
   --                            j0 => PRESENT_STATE(  4 ), k0 => PRESENT_STATE(  4 ),
   --                            j1 =>  OR_PLANE_OUT(  0 ), k1 =>  OR_PLANE_OUT(  1 ),
   --                            j2 =>  OR_PLANE_OUT( 10 ), k2 =>  OR_PLANE_OUT( 11 ),
   --                            j3 =>  OR_PLANE_OUT( 20 ), k3 =>  OR_PLANE_OUT( 21 ),
   --                            j  =>    FF_INPUT_J(  4 ), k  =>    FF_INPUT_K(  4 ) );
    
        -- MUX ports to jk flip flop -- J3, K3
    --MUX_PORT_3 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
    --                           j0 => PRESENT_STATE(  3 ), k0 => PRESENT_STATE(  3 ),
    --                           j1 =>  OR_PLANE_OUT(  2 ), k1 =>  OR_PLANE_OUT(  3 ),
    --                           j2 =>  OR_PLANE_OUT( 12 ), k2 =>  OR_PLANE_OUT( 13 ),
    --                           j3 =>  OR_PLANE_OUT( 22 ), k3 =>  OR_PLANE_OUT( 23 ),
    --                           j  =>    FF_INPUT_J(  3 ), k  =>    FF_INPUT_K(  3 ) );
                               
        -- MUX ports to jk flip flop -- J2, K2
    --MUX_PORT_2 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
    --                           j0 => PRESENT_STATE(  2 ), k0 => PRESENT_STATE(  2 ),
    --                           j1 =>  OR_PLANE_OUT(  2 ), k1 =>  OR_PLANE_OUT(  5 ),
    --                           j2 =>  OR_PLANE_OUT( 14 ), k2 =>  OR_PLANE_OUT( 15 ),
    --                           j3 =>  OR_PLANE_OUT( 25 ), k3 =>  OR_PLANE_OUT( 25 ),
    --                           j  =>    FF_INPUT_J(  2 ), k  =>    FF_INPUT_K(  2 ) );                             

        -- MUX ports to jk flip flop -- J1, K1
    --MUX_PORT_1 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
    --                           j0 => PRESENT_STATE(  1 ), k0 => PRESENT_STATE(  1 ),
    --                           j1 =>  OR_PLANE_OUT(  6 ), k1 =>  OR_PLANE_OUT(  7 ),
     --                          j2 =>  OR_PLANE_OUT( 16 ), k2 =>  OR_PLANE_OUT( 17 ),
      --                         j3 =>  OR_PLANE_OUT( 26 ), k3 =>  OR_PLANE_OUT( 27 ),
       --                        j  =>    FF_INPUT_J(  1 ), k  =>    FF_INPUT_K(  1 ) );   
   
        -- MUX ports to jk flip flop -- J0, K0
    --MUX_PORT_0 : MUX port map( select_lines => CURRENCY_INPUT_SELECT_LINES,
    --                           j0 => PRESENT_STATE(  0 ), k0 => PRESENT_STATE(  0 ),
    --                           j1 =>  OR_PLANE_OUT(  8 ), k1 =>  OR_PLANE_OUT(  9 ),
    --                           j2 =>  OR_PLANE_OUT( 18 ), k2 =>  OR_PLANE_OUT( 19 ),
    --                           j3 =>  OR_PLANE_OUT( 28 ), k3 =>  OR_PLANE_OUT( 29 ),
     --                          j  =>    FF_INPUT_J(  0 ), k  =>    FF_INPUT_K(  0 ) );  
                    
    --MUX_PORTS : for i in 4 downto 0 generate
    --    MUX_PORT : MUX port map( 
    --        select_lines => CURRENCY_INPUT_SELECT_LINES, 
   --         j0 => PRESENT_STATE( i ), k0 => PRESENT_STATE( i ),
   --         j1 => DCD_OR_PLANE(  8 - ( i * 2 ) ), k1 => DCD_OR_PLANE(  9 - ( i * 2 ) ),
    --        j2 => DCD_OR_PLANE( 18 - ( i * 2 ) ), k2 => DCD_OR_PLANE( 19 - ( i * 2 ) ),
    --        j3 => DCD_OR_PLANE( 28 - ( i * 2 ) ), k3 => DCD_OR_PLANE( 29 - ( i * 2 ) ),
     --       j  => FF_INPUT_J( i ), k  => FF_INPUT_K( i ) );
    --end generate MUX_PORTS;
