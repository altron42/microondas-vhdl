library ieee;
use ieee.std_logic_1164.all;

entity Ripple_Clock is
   port (
	   clk_in: in std_logic;
	   clk_out: out std_logic
   );
end Ripple_Clock;

architecture DF of Ripple_Clock is
	-- O clock da placa (50MHz) eh dividido por um fator de 200 para termos uma frequancia de 250Khz
	constant fator: natural := 200;
begin
	process(clk_in)
		variable count: natural := 0;
	begin
		if rising_edge(clk_in) then
		   if count = fator/2 then
			   clk_out <= 0;
			elsif count = 0 then
			   clk_out <=1;
			end if;
		   if count < fator then
			   count := count + 1;
			else
			   count := 0;
			end if;
		end if;
	end process;
end DF;