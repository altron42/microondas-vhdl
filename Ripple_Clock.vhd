library ieee;
use ieee.std_logic_1164.all;

entity Ripple_Clock is
   generic ( fator : integer := 100 );
   port (
	   clk_in: in std_logic;
	   clk_out: out std_logic
   );
end Ripple_Clock;

architecture DF of Ripple_Clock is
	-- O clock da placa (50MHz) eh dividido por um fator de 200 para termos uma frequancia de 250Khz
begin
	process(clk_in)
		variable count: natural := 0;
	begin
	   if count = 0 then
			clk_out <= '1';
		elsif count = fator/2 then
			clk_out <= '0';
		end if;
		if rising_edge(clk_in) then
			count := count + 1;
			if count >= fator then
				count := 0;
			end if;
		end if;
	end process;
end DF;