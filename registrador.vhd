library ieee;
use ieee.std_logic_1164.all;

use work.constantes.all;

entity registrador is 
   port (
		d   : in std_logic_vector (bus_max_width downto 0); -- dado
		ld  : in std_logic; -- enable
		rst : in std_logic; -- reset assisncrono
		clk : in std_logic; -- clock
		q   : out std_logic_vector (bus_max_width downto 0) -- saida
   );
end registrador;

architecture descricao of registrador is
begin
   process (clk, rst)
	begin
	   if rst = '1' then
		   q <= x"0000";
		elsif rising_edge(clk) then
		   if ld = '1' then
			   q <= d;
			end if;
		end if;
	end process;
end descricao;
