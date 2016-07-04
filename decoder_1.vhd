library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity decoder_1 is
   port (
	   clk : in std_logic;
	   bt_pip, bt_piz, bt_las : in std_logic;
		rd_dec1 : in std_logic;
		ready_dec1 : out std_logic := '0';
		bus_dec1 : out std_logic_vector (bus_max_width downto 0) := (others => 'Z')
	);
end decoder_1;

architecture rtl_decoder1 of decoder_1 is
   signal registrador_tempo : std_logic_vector (bus_max_width downto 0) := x"0000";
	signal selecao : std_logic_vector (2 downto 0) := not bt_pip & not bt_piz & not bt_las;
begin
   ready_dec1 <= not bt_pip or not bt_piz or not bt_las; -- qualquer botao pressionado
	
	with selecao select registrador_tempo <=
	   pip_time when "100",
		piz_time when "010",
		las_time when "001",
		x"0000" when others;
	
	process (clk)
	begin
	   if rising_edge(clk) then
		   if rd_dec1 = '1' then
		      bus_dec1 <= registrador_tempo;
		   else
			   bus_dec1 <= (others => 'Z'); -- volta para estado de alta impedancia
			end if;
		end if;
	end process;
	
end rtl_decoder1;