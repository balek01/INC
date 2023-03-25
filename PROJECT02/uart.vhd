-- uart.vhd: UART controller - receiving part
-- Author(s): Miroslav Bálek (xbalek02)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal clk_count : std_logic_vector(4 downto 0):= "00001";
signal bit_count : std_logic_vector(3 downto 0):= "0000";
signal bit_enable : std_logic := '0';
signal clk_reset : std_logic := '0';
signal clk_enable : std_logic := '0';	
begin

	FSM: entity work.UART_FSM(behavioral)
		port map(
		CLK 		=> CLK,
		RST 		=> RST,
		DIN 		=> DIN,
		BIT_COUNT 	=> bit_count,
		CLK_COUNT   => clk_count,
		BIT_ENABLE	=> bit_enable,
		CLK_ENABLE	=> clk_enable,

		CLK_RESET 	=> clk_reset
	);

		process(CLK) begin 
			if rising_edge(CLK) then 

			DOUT_VLD <= '0';

			if rst = '1' then 
				DOUT <= "00000000";
			end if;

			if clk_reset = '1' then
				clk_count <= "00001";
			end if;

			if clk_enable = '1' then
				clk_count <= clk_count + '1';
			end if;
			

			if bit_enable = '1' then
				if clk_count(4) = '1' then
					clk_count <= "00001";

					case bit_count is

						when "0000" => DOUT(0) <= DIN;
						when "0001" => DOUT(1) <= DIN;
						when "0010" => DOUT(2) <= DIN;
						when "0011" => DOUT(3) <= DIN;
						when "0100" => DOUT(4) <= DIN;
						when "0101" => DOUT(5) <= DIN;
						when "0110" => DOUT(6) <= DIN;
						when "0111" => DOUT(7) <= DIN;
						when others => null;

					end case;

					bit_count <= bit_count + '1';

				end if;
			end if;

			if bit_count = "1000" then
				if clk_count = "10000" then
					DOUT_VLD <= '1';
					bit_count <= "0000";
					clk_count <= "00001";
					
				end if;


			end if;
							
		end if;
	end process;
		



end behavioral;
