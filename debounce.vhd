library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.constantes.all;

entity debounce is
   generic(
	   fclk : integer := deb_fclk;   -- frequencia do clock
      twindow : integer := deb_twindow   -- tamamnho da janela de clock que o sinal devera permanecer o mesmo para ser valido
	);
   port (
	   clk : in  std_logic; 
	   x : in std_logic;
      y : buffer  std_logic
	);
end debounce;

architecture debouncer of debounce is
   constant max : integer := fclk / twindow;
begin
   process (clk)
	   variable count : integer range 0 to max;
   begin
      if rising_edge(clk) then
         if not x /= y then
            count := count + 1;
				if count = max then
				   y <= not x;
					count := 0;
				end if;
			else
			   count := 0;
         end if;    
      end if;
   end process;
end debouncer;