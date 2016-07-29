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
		dav_dec2 : buffer std_logic := '0';
		bus_dec2 : out std_logic_vector (bus_max_width downto 0) := (others => 'Z')
	);
end decoder_2;

architecture rtl_decoder2 of decoder_2 is

   component debounce
      port (
         clk : in  std_logic; 
         x : in  std_logic;
         y : buffer std_logic
		);
   end component;
	
	signal sinal_bt_3, sinal_bt_5 : std_logic;
	
begin
   
	bt3Debounce : debounce port map (
	   clk => clk,
		x => bt_3,
		y => sinal_bt_3
	);
	
	bt5Debounce : debounce port map (
	   clk => clk,
		x => bt_5,
		y => sinal_bt_5
	);
	
	process (clk, rst_all)
	   variable dados_tempo : std_logic_vector (bus_max_width downto 0) := x"0000";
		variable selecao : std_logic_vector (1 downto 0) := "00";
		variable flag : std_logic := '0';
	begin
   	if rst_all = '1' then
		   dados_tempo := (others => '0');
		elsif rising_edge(clk) then
			if dav_dec2 = '1' and (sinal_bt_5 = '1' or sinal_bt_3 = '1') then
			   dav_dec2 <= '0';
				flag := '1';
			elsif sinal_bt_5 = '0' and sinal_bt_3 = '0' then
			   flag := '0';
			elsif flag = '0' then
				selecao := sinal_bt_5 & sinal_bt_3;
				case selecao is
					when "10" => dados_tempo := x"0005"; dav_dec2 <= '1';
					when "01" => dados_tempo := x"0003"; dav_dec2 <= '1';
					when others => dados_tempo := (others => '0'); dav_dec2 <= '0';
				end case;
			end if;
		end if;
		bus_dec2 <= dados_tempo;
	end process;
	
end rtl_decoder2;