library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity decoder_2 is
   port (
	   clk : in std_logic;
		clk_sys : in std_logic;
	   bt_3, bt_5 : in std_logic;
		rd_dec2 : in std_logic;
		rst_all : in std_logic;
		ready_dec2 : buffer std_logic := '0';
		bus_dec2 : out std_logic_vector (bus_max_width downto 0) := (others => 'Z')
	);
end decoder_2;

architecture rtl_decoder2 of decoder_2 is

   component debounce
      generic(
		   tamanho_contador : integer := 19);
      port (
         clk : in  std_logic; 
         in_botao : in  std_logic;
         resultado : out std_logic
		);
   end component;
	
	component registrador 
	   port (
			d   : in std_logic_vector (15 downto 0); -- dado
			ld  : in std_logic; -- enable
			rst : in std_logic; -- reset assisncrono
			clk : in std_logic; -- clock
			q   : out std_logic_vector (15 downto 0) -- saida
		);
	end component;

	signal dados_tempo : std_logic_vector (bus_max_width downto 0) := x"0000";
	shared variable registrador_tempo : std_logic_vector (bus_max_width downto 0);
	
	signal sinal_bt_3, sinal_bt_5 : std_logic;
	
	signal selecao : std_logic_vector (1 downto 0) := "00";
begin
   
	bt3Debounce : debounce port map (
	   clk => clk,
		in_botao => bt_3,
		resultado => sinal_bt_3
	);
	
	bt5Debounce : debounce port map (
	   clk => clk,
		in_botao => bt_5,
		resultado => sinal_bt_5
	);
	
	selecao <= sinal_bt_3 & sinal_bt_5;
	
	dados_tempo <=
	   x"0003" when selecao = "10" else
		x"0005" when selecao = "01" else
		x"0000";
	
	compRegistrador : registrador port map (
	   d => dados_tempo,
		ld => sinal_bt_3 or sinal_bt_5,
		rst => rst_all,
		clk => clk_sys,
		q => registrador_tempo
	);
	
	process (clk_sys)
	begin
	   if rising_edge(clk_sys) then
			ready_dec2 <= sinal_bt_3 or sinal_bt_5;
		   if rd_dec2 = '1' then
		      bus_dec2 <= registrador_tempo; -- ativa leitura do registrador
		   else
			   bus_dec2 <= (others => 'Z'); -- volta para estado de alta impedancia
			end if;
		end if;
	end process;
	
end rtl_decoder2;