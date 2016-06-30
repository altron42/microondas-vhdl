library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity decrementador_bcd
	port (
		clk, load, enable, rst, ate5 : in std_logic;
		din : in std_logic_vector (3 downto 0);
		dout : out std_logic_vector (3 downto 0);
		carry : out std_logic;
	);
end decrementador_bcd;

architecture decrementador of decrementador_bcd is

begin

end decrementador;