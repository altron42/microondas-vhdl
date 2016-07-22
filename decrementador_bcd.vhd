library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity decrementador_bcd is
   generic ( clk_divider : integer := out_fclk/2 );
	port (
		clk, load, enable, rst : in std_logic;
		estouro : in std_logic := '0';
		din : in std_logic_vector (3 downto 0);
		dout : out std_logic_vector (3 downto 0);
		carry : out std_logic
	);
end decrementador_bcd;

architecture decrementador of decrementador_bcd is
   signal clk_d : std_logic := '0';
begin
   
   process(clk)
	   variable counta : integer := 0;
	begin
		if rising_edge(clk) then
			counta := counta + 1;
			if counta = clk_divider then
				clk_d <= not clk_d;
				counta := 0;
			end if;
		end if;
	end process;
	
   process(clk_d, rst, load)
	   variable count : std_logic_vector (3 downto 0) := "0000";
	begin
	   if rst = '1' then count := "0000";
		elsif load = '1' then count := din; 
	   elsif rising_edge(clk_d) and enable = '1' then
			count := count - "01";
			if count >= "1010" then
				if estouro = '1' then count := "0101"; else count := "1001"; end if;
			end if;
		end if;
		if count = "0000" then carry <= '1'; else carry <= '0'; end if;
		dout <= count;
	end process;
end decrementador;