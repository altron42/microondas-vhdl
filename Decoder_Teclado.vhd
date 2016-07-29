library ieee;
use ieee.std_logic_1164.all;

entity Decoder_Teclado is
	port (
		saida : in std_logic_vector (7 downto 0);
		cod : out std_logic_vector (3 downto 0) 
	);
end Decoder_Teclado;

architecture f1 of Decoder_Teclado is
begin
	with saida select 
			cod <= "0000" when "11101011",
				    "0001" when "01110111",
				    "0010" when "01111011",
				    "0011" when "01111101",
				    "0100" when "10110111",
				    "0101" when "10111011",
				    "0110" when "10111101",
				    "0111" when "11010111",
				    "1000" when "11011011",
				    "1001" when "11011101",
				    --"01010" when "01111111",
				    --"01011" when "10111111",
				    --"01100" when "11011111",
				    --"01101" when "11101111",
				    --"01110" when "11100111",
				    --"01111" when "11101101",
				    "1111" when others;
end f1;