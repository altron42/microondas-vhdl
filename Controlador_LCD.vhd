library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Controlador_LCD is
	port(
		clk_lcd : in std_logic;
		selecionaChar : out std_logic;
		endereco : out std_logic_vector (5 downto 0);
		caracter : out character
	);
end Controlador_LCD;

architecture controle_lcd of Controlador_LCD is
begin
	process(clk_lcd)
	   -- tamanho da string
		-- Guia de tamanho das linhas '                    ' '                    ' '                    ' '                    '
		constant nome: string := "Victor me ajuda";
		variable count: natural range 0 to nome'length := 0;
	begin
		if rising_edge(clk_lcd) then
			if count < nome'length then
				count := count + 1;
			else
				count := 0;
			end if;
			caracter <= nome(count+1);
			endereco <= std_logic_vector(to_unsigned(count,6));
			selecionaChar <= '1';
		end if;
	end process;
end controle_lcd;