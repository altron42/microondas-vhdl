library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity decoder_1 is
   port (
	   clk : in std_logic;
		clk_sys : in std_logic;
	   bt_pip, bt_piz, bt_las : in std_logic;
		rd_dec1 : in std_logic;
		rst_all : in std_logic;
		ready_dec1 : buffer std_logic := '0';
		bus_dec1 : out std_logic_vector (bus_max_width downto 0) := (others => 'Z')
	);
end decoder_1;

architecture rtl_decoder1 of decoder_1 is

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
	
	signal sinal_bt_pip, sinal_bt_piz, sinal_bt_las : std_logic;
	
	signal selecao : std_logic_vector (2 downto 0) := "000";
begin
   
	pipDebounce : debounce port map (
	   clk => clk,
		in_botao => bt_pip,
		resultado => sinal_bt_pip
	);
	
	pizDebounce : debounce port map (
	   clk => clk,
		in_botao => bt_piz,
		resultado => sinal_bt_piz
	);
	
	lasDebounce : debounce port map (
	   clk => clk,
		in_botao => bt_las,
		resultado => sinal_bt_las
	);
	
	selecao <= sinal_bt_pip & sinal_bt_piz & sinal_bt_las;
	
	dados_tempo <=
	   pip_time when selecao = "100" else
		piz_time when selecao = "010" else
		las_time when selecao = "001" else
		x"0000";
	
	compRegistrador : registrador port map (
	   d => dados_tempo,
		ld => sinal_bt_pip or sinal_bt_piz or sinal_bt_las,
		rst => rst_all,
		clk => clk_sys,
		q => registrador_tempo
	);
	
	process (clk_sys)
	begin
	   if rising_edge(clk_sys) then
			ready_dec1 <= sinal_bt_pip or sinal_bt_piz or sinal_bt_las;
		   if rd_dec1 = '1' then
		      bus_dec1 <= registrador_tempo; -- ativa leitura do registrador
		   else
			   bus_dec1 <= (others => 'Z'); -- volta para estado de alta impedancia
			end if;
		end if;
	end process;
	
end rtl_decoder1;