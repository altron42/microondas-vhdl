library ieee;
use ieee.std_logic_1164.all;

package constantes is
   constant bus_width : integer;
	constant bus_max_width : integer;
	
	constant pip_time : std_logic_vector;
	constant piz_time : std_logic_vector;
	constant las_time : std_logic_vector;
	
	constant in_fclk : integer;
	constant sys_clock_divider : integer;
	constant out_fclk : integer;
	
	constant deb_twindow : integer;
	
end constantes;

package body constantes is
   constant bus_width : integer := 16; -- Largura do barramento de dados
	constant bus_max_width : integer := bus_width-1; -- Tamanho maximo do vetor do barramento
	
	-- Constantes dos tempos pre programados
	constant pip_time : std_logic_vector (bus_max_width downto 0) := x"0007"; -- Tempo preprogramado do botao pipoca
	constant piz_time : std_logic_vector (bus_max_width downto 0) := x"0014"; -- Tempo preprogramado do botao pizza
	constant las_time : std_logic_vector (bus_max_width downto 0) := x"0103"; -- Tempo preprogramado do botao lasanha
	
	constant in_fclk : integer := 50e6;   -- frequencia de clock da placa: 50 Mhz
	constant sys_clock_divider : integer := 5e5;   -- fator divisor de frequencia
	constant out_fclk : integer := in_fclk/sys_clock_divider;   -- frequencia resultante
	
	constant deb_twindow : integer := 10;   -- quantidade de pulsos de clock
	
end constantes;