library ieee;
use ieee.std_logic_1164.all;

entity Controlador is
	port (
	   clk, bt_start, bt_cancel, bt_stop, sw_sp : in std_logic;
		en_wait, en_lamp : out std_logic := '0';
		ready_dec1, ready_dec2 : in std_logic;
		rd_dec1, rd_dec2 : out std_logic := '0';
		rd_ula : out std_logic := '0';
		op_t, fp_t : in std_logic;
		wr_t, ce_t : out std_logic := '0';
		rst_all : out std_logic := '0'
	);
end Controlador;

architecture rtl_controlador of Controlador is
   type ctrl_estados is (espera, pronto, rodando, parado);
	
	signal ctrl_sto, ctrl_sto_prox : ctrl_estados := espera;
begin

   en_lamp <= op_t;
	en_wait <= not op_t;

	process (clk)
	begin
		if falling_edge(clk) then
		   ctrl_sto <= ctrl_sto_prox;
		end if;
	end process;
	
	process (ctrl_sto, bt_cancel)
	begin
	   if bt_cancel = '1' then
		   ctrl_sto_prox <= espera;
			rst_all <= '1';
		else
		   rst_all <= '0';
			if ready_dec2 = '1' then
			   rd_dec2 <= '1';
				rd_ula <= '1';
				wr_t <= '1';
			else
			   wr_t <= '0';
				rd_ula <= '0';
				rd_dec2 <= '0';
			end if;
			case ctrl_sto is
				when espera => -- Estado em espera
					ce_t <= '0';
					if ready_dec1 = '1' then
						rd_dec1 <= '1';
						wr_t <= '1';
						ctrl_sto_prox <= pronto;
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
					end if;
				when rodando => -- Estado em rodando
					ce_t <= '1';
					if bt_stop = '1' or sw_sp = '0' then
						ctrl_sto_prox <= parado;
					elsif fp_t = '1' then
						ctrl_sto_prox <= espera;
					else
						ctrl_sto_prox <= rodando;
					end if;
				when parado => -- Estado em parado
					ce_t <= '0';
					if bt_start = '1' and sw_sp = '1' then
						ctrl_sto_prox <= rodando;
					else
						ctrl_sto_prox <= parado;
					end if;
				when others => ctrl_sto_prox <= espera; -- condicao para voltar para o estado de espera
			end case;
		end if;
	end process;

end rtl_controlador;