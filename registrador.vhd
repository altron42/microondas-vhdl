library ieee;
use ieee.std_logic_1164.all;

use work.constantes.all;

entity registrador is 
   port (
		dt_i   : in std_logic_vector (bus_max_width downto 0); -- dado
		ld  : in std_logic; -- enable
		rst : in std_logic; -- reset assisncrono
		clk : in std_logic; -- clock
		dt_o   : out std_logic_vector (bus_max_width downto 0) -- saida
   );
end registrador;

architecture descricao of registrador is
begin
   process (clk, rst)
	begin
	   if rst = '1' then
		   dt_o <= x"0000";
		elsif rising_edge(clk) then
		   if ld = '1' then
			   dt_o <= dt_i;
			end if;
		end if;
	end process;
end descricao;
