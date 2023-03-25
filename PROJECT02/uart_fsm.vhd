-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): Miroslav Bálek (xbalek02)
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   	CLK 		: in 	std_logic;
   	RST 		: in 	std_logic;
	DIN 		: in 	std_logic;
	BIT_COUNT 	: in 	std_logic_vector(3 downto 0);
	CLK_COUNT 	: in 	std_logic_vector(4 downto 0);
	CLK_RESET	: out	std_logic;
	BIT_ENABLE	: out 	std_logic;
	CLK_ENABLE	: out 	std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type STATE_TYPE is (AWAIT, WAIT_FOR_DATA, DATA, IS_STOP_BIT, VALID);
signal state : STATE_TYPE := AWAIT;
begin

	CLK_RESET <= '1' when state = AWAIT
	else '0';


	CLK_ENABLE <= '1' when state = WAIT_FOR_DATA or state = DATA or state = IS_STOP_BIT
	else '0';

	BIT_ENABLE <= '1' when state = DATA
	else '0';
	
	
	
	process (CLK) begin 
		if rising_edge(CLK) then
			if RST = '1' then
				state <= AWAIT;
				else 
				case state is 
				--AWIAT STATE
				when AWAIT => if DIN = '0' then 
											state <= WAIT_FOR_DATA;
										end if;

				-- WAIT_FOR_DATA
				when WAIT_FOR_DATA => if CLK_COUNT ="10110" then
											state <= DATA;
											end if;
				-- DATA
				when DATA => if BIT_COUNT = "1000" then 
											state <= IS_STOP_BIT;
											end if;
				when IS_STOP_BIT => if CLK_COUNT = "10000" then 
											state <= VALID;
											end if;
				when VALID => state <= AWAIT;
				
				when others => null;
				end case;
				
			end if;
		end if;
	end process;
end behavioral;
