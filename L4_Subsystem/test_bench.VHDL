library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is end tb;
architecture arch of tb is

component subsystem is
    port(
          clock : in std_logic;

          new_cmd   : in std_logic;          
          op_code   : in std_logic_vector( 3 downto 0 );
          arg_1     : in std_logic_vector( 3 downto 0 );
          arg_2     : in std_logic_vector( 3 downto 0 );

          result    : out std_logic_vector( 7 downto 0 ) := "00000000";
          err_flag  : out std_logic := '0'
         );
 end component;

signal clock, new_cmd, err_flag  : std_logic := '0';
signal result : std_logic_vector( 7 downto 0 ) := "00000000";
signal arg_1, arg_2, op_code : std_logic_vector( 3 downto 0 ) := "0000";

begin

    arg_1 <= "0100";
    arg_2 <= "0011";
    
    clock <= not( clock ) after 7.5 ns;
    new_cmd <= not( new_cmd ) after 15 ns;

    op_code <= "1111", "0000" after 100 ns, "0010" after 200 ns, "0011" after 300 ns, "0101" after 400 ns, "1000" after 500 ns, "1011" after 600 ns;
    UUT: subsystem 
    port map( 
              clock => clock,
              new_cmd => new_cmd,
              op_code => op_code,
              arg_1 => arg_1,
              arg_2 => arg_2,
              result => result,
              err_flag => err_flag    
             );
end arch;

