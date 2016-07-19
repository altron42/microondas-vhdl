library ieee;
use ieee.std_logic_1164.all;

entity Controlador is
	port (
	   clk, bt_start, bt_cancel, bt_stop, sw_sp : in std_logic;
		en_wait, en_lamp : out std_logic := '0';
		ready_dec1, ready_dec2 : in std_logic;
		rd_dec1 : out std_logic := '0';
		rd_ula : out std_logic := '0';
		op_t, fp_t : in std_logic;
		wr_t, ce_t : out std_logic := '0';
		rst_all : out std_logic := '0'
	);
end Controlador;

architecture rtl_controlador of Controlador is
   type ctrl_estados is (espera, pronto, rodando, parado, incrementa, reset);
	
	signal ctrl_sto, ctrl_sto_prox, sto_anterior : ctrl_estados;
	
	signal flag_sto : std_logic_vector (1 downto 0) := "00";
	
begin

   en_lamp <= op_t;
	en_wait <= not op_t;

	process (clk, bt_cancel)
	begin
	   if bt_cancel = '1' then
		   ctrl_sto <= reset;
		elsif falling_edge(clk) then
		   ctrl_sto <= ctrl_sto_prox;
		end if;
	end process;
	
	process (ctrl_sto)
	begin
			case ctrl_sto is
				when espera => -- Estado em espera
				   rst_all <= '0';
					ce_t <= '0';
					if ready_dec1 = '1' then
						rd_dec1 <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= pronto;
					elsif ready_dec2 = '1' then
					   flag_sto <= "00";
					   rd_ula <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= incrementa;
					else
						ctrl_sto_prox <= espera;
					end if;
				when pronto => -- Estado em pronto
					rd_dec1 <= '0';
					wr_t <= '0';
					if bt_start = '1' and sw_sp = '1' then
						ctrl_sto_prox <= rodando;
					elsif ready_dec1 = '1' then
						rd_dec1 <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= pronto;
					elsif ready_dec2 = '1' then
					   flag_sto <= "01";
					   rd_ula <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= incrementa;
					else
					   ctrl_sto_prox <= pronto;
					end if;
				when rodando => -- Estado em rodando
					ce_t <= '1';
					if bt_stop = '1' or sw_sp = '0' then
						ctrl_sto_prox <= parado;
					elsif fp_t = '1' then
						ctrl_sto_prox <= espera;
					elsif ready_dec2 = '1' then
					   flag_sto <= "10";
					   rd_ula <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= incrementa;
					else
						ctrl_sto_prox <= rodando;
					end if;
				when parado => -- Estado em parado
					ce_t <= '0';
					if bt_start = '1' and sw_sp = '1' then
						ctrl_sto_prox <= rodando;
					elsif ready_dec2 = '1' then
					   flag_sto <= "11";
					   rd_ula <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= incrementa;
					else
						ctrl_sto_prox <= parado;
					end if;
				when incrementa => -- Estado incrementar contador
				   rd_ula <= '0';
					wr_t <= '0';
					case flag_sto is
					   when "00" => ctrl_sto_prox <= pronto;
						when "01" => ctrl_sto_prox <= pronto;
						when "10" => ctrl_sto_prox <= rodando;
						when "11" => ctrl_sto_prox <= parado;
					end case;
				when reset =>  -- Estado reseta tudo
				   rst_all <= '1';
					ctrl_sto_prox <= espera;
				when others => ctrl_sto_prox <= espera; -- condicao para voltar para o estado de espera
			end case;
	end process;

end rtl_controlador;