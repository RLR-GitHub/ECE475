library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is end tb;
architecture arch of tb is

component one_shot is 
    port( 
          control_register : in std_logic_vector( 5 downto 0 ) := "111011";
          clk, start_pulse : in std_logic; 
          output_pulse : out std_logic 
         );
 end component;

signal control_register : std_logic_vector( 5 downto 0 ) := "111011";
signal clk, start_pulse : std_logic := '0';
signal output_pulse : std_logic;

begin
    clk <= not( clk ) after 0.5 ns;
    start_pulse <= '1' after 0.5 ns,'0' after 1 ns, '1' after 100.5 ns, '0' after 101 ns;
    UUT: one_shot port map( control_register => control_register, clk => clk, start_pulse => start_pulse, output_pulse => output_pulse );
end arch;
