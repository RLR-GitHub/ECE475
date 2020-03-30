library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is end tb;

architecture tb_arch of tb is

    component vending_machine 
        port( CLK : in std_logic; 
              CURRENCY_INPUT_SELECT_LINES, ITEM_INPUT_SELECT_LINES : in std_logic_vector( 2 downto 0 ) := ( others => '0' );
              DISPENSE : inout boolean;
              CHANGE : out integer );
    end component;
    
    signal CLK : std_logic := '0';
    signal CURRENCY_INPUT_SELECT_LINES, ITEM_INPUT_SELECT_LINES : std_logic_vector( 2 downto 0 ) := ( others => '0' );
    signal DISPENSE : boolean;
    signal CHANGE : integer;
    
begin

    UUT : vending_machine port map
    (
        CLK => CLK,
        CURRENCY_INPUT_SELECT_LINES => CURRENCY_INPUT_SELECT_LINES,
        ITEM_INPUT_SELECT_LINES => ITEM_INPUT_SELECT_LINES,
        DISPENSE => DISPENSE,
        CHANGE => CHANGE 
    );
    
    CLK <= not( CLK ) after 0.5 ns;
     
    CURRENCY_INPUT_SELECT_LINES <= "100" after 10 ns, "000" after 25 ns, "010" after 50 ns, "000" after 56 ns;
    ITEM_INPUT_SELECT_LINES <= "100" after 20 ns, "000" after 25 ns, "001" after 55 ns, "000" after 60 ns;

        
end tb_arch;
