library ieee;
use ieee.std_logic_1164.all;

entity Registrador_Teclado is

	port (
		cod: in std_logic_vector (3 downto 0);
		cod_reg : out std_logic_vector (3 downto 0);
		dav : in std_logic
	);
	end Registrador_Teclado;

architecture f1 of Registrador_Teclado is
begin
	
	process (dav)
	begin
		if (rising_edge(dav)) then
			cod_reg <= cod;
		end if;
	end process;
	
end f1;