library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity decoder_2 is
   port (
	   clk : in std_logic;
	   bt_3, bt_5 : in std_logic;
		rst_all : in std_logic;
		ready_dec2 : buffer std_logic := '0';
		bus_dec2 : out std_logic_vector (bus_max_width downto 0) := (others => 'Z')
	);
end decoder_2;

architecture rtl_decoder2 of decoder_2 is

   component debounce
      generic(
		   tamanho_contador : integer := 2);
      port (
         clk : in  std_logic; 
         in_botao : in  std_logic;
         resultado : out std_logic
		);
   end component;
	
	component registrador 
	   port (
			dt_i   : in std_logic_vector (15 downto 0); -- dado
			ld  : in std_logic; -- enable
			rst : in std_logic; -- reset assisncrono
			clk : in std_logic; -- clock
			dt_o   : out std_logic_vector (15 downto 0) -- saida
		);
	end component;
	
	signal sinal_bt_3, sinal_bt_5 : std_logic;
	
	signal flag : std_logic := '0';
	
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
	
	process (sinal_bt_3, sinal_bt_5)
	begin
	   if sinal_bt_3 = '0' or sinal_bt_5 = '0' then
		   flag <= '0';
		end if;
	end process;
	
	process (clk, rst_all)
	   variable dados_tempo : std_logic_vector (bus_max_width downto 0) := x"0000";
		variable selecao : std_logic_vector (1 downto 0) := "00";
	begin
   	if rst_all = '1' then
		   dados_tempo := (others => 'Z');
		elsif rising_edge(clk) then
		   if ready_dec2 = '1' then
				ready_dec2 <= '0';
			elsif sinal_bt_3 = '0' or sinal_bt_5 = '0' then
			   flag <= '0';
			else
				selecao := sinal_bt_5 & sinal_bt_3;
				case selecao is
					when "10" => dados_tempo := x"0005"; ready_dec2 <= '1'; flag <= '1';
					when "01" => dados_tempo := x"0003"; ready_dec2 <= '1'; flag <= '1';
					when others => dados_tempo := (others => 'Z'); ready_dec2 <= '0';
				end case;
			end if;
		end if;
		bus_dec2 <= dados_tempo;
	end process;
	
end rtl_decoder2;