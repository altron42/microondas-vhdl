library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
   generic(
      tamanho_contador  :  integer := 19); --Tamanho do Contador (19 bits duram cerca de 10.5ms em 50MHz de clock)
   port (
      clk     : in  std_logic; 
      in_botao  : in  std_logic;  --Sinal de entrada do botão
      resultado  : out std_logic --Sinal de saida filtrado
	);
end debounce;

architecture logic of debounce is
   signal flipflops   : std_logic_vector(1 downto 0); -- flip flops de entrada
   signal counter_set : std_logic;                    -- reset sincrono para zero
   signal counter_out : std_logic_vector(tamanho_contador downto 0) := (others => '0'); -- saida contador
begin

   counter_set <= flipflops(0) xor flipflops(1);   --determina quando iniciar/zerar a contagem
   
   process (clk)
   begin
      if rising_edge(clk) then
         flipflops(0) <= not in_botao;
         flipflops(1) <= flipflops(0);
         if (counter_set = '1') then                  --zera a contagem porque o sinal do botão está variando
            counter_out <= (others => '0');
         elsif (counter_out(tamanho_contador) = '0') then --ruído do botão ainda ativo
            counter_out <= counter_out + 1;
         else                                        --ruído do botão terminou
            resultado <= flipflops(1);
         end if;    
      end if;
   end process;
end logic;