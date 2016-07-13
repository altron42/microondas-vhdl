library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bcd_adder is
   port(
      a, b  : in  std_logic_vector (3 downto 0); -- entradas.
      cin : in std_logic; -- carry in
		estouro : in std_logic; -- indica se eh soma dos minutos
      sum : out std_logic_vector (3 downto 0); -- soma
      cout : out std_logic  -- carry out
   );
end bcd_adder;

architecture funcionamento of bcd_adder is
begin
   process(a,b,cin)
   variable soma_temp : std_logic_vector (4 downto 0);
   begin
      soma_temp := ('0' & a) + ('0' & b) + ("0000" & cin);
		if estouro = '1' and soma_temp > 5 then
		   cout <= '1';
			sum <= std_logic_vector(resize(unsigned(soma_temp + "01010"),4));
      elsif (soma_temp > 9) then
         cout <= '1';
         sum <= std_logic_vector(resize(unsigned(soma_temp + "00110"),4));
      else
         cout <= '0';
         sum <= soma_temp(3 downto 0);
      end if; 
   end process;
end funcionamento;