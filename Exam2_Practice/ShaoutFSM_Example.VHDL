library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Detect sequence '0010'
entity seq_design is port( a, clock, reset:in std_logic; x: out std_logic );
end seq_design;
	
architecture FSM of seq_design is
    
    type state_type is (S0, S1, S2, S3); -- define the states of FSM model
    signal next_state, current_state: state_type;

begin

state_reg: process(clock, reset) -- cocurrent process#1: state registers
begin
	
	if (reset='1') then current_state <= S0;
		elsif (clock'event and clock='1') then current_state <= next_state;
	end if;
		
end process;					  

comb_logic: process(current_state, a)   -- cocurrent process#2: combinational logic
begin

	case current_state is -- use case statement to show the state transistion
	    when S0 =>	x <= '0';
			if a='0' then next_state <= S1;
				elsif a ='1' then next_state <= S0;
			end if;
	    when S1 =>	x <= '0';
			if a='0' then next_state <= S2;
				elsif a='1' then next_state <= S0;
			end if;
	    when S2 =>	x <= '0';
			if a='0' then next_state <= S2;
				elsif a='1' then next_state <= S3;
			end if;
	    when S3 =>	x <= '1';
			if a='0' then next_state <= S0;
				elsif a='1' then next_state <= S0;
			end if;
	    when others =>	x <= '0';
			next_state <= S0;
	end case;
    end process;
end FSM;
