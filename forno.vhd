library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.constantes.all;

entity forno is
   port (
	   CLOCK : in std_logic;
	   BT_START, BT_CANCEL, BT_STOP : in std_logic;
		BT_PIP, BT_PIZ, BT_LAS : in std_logic;
		BT_3, BT_5 : in std_logic;
		SW_SENPORTA : in std_logic;
		LED_ESPERA, LED_OPERANDO : out std_logic;
		LCD_DADOS : out std_logic_vector (7 downto 0);
		LCD_RS, LCD_RW, LCD_E : out std_logic
	);
end forno;

architecture microondas of forno is

   component Controlador
	   port (
		   clk, bt_start, bt_cancel, bt_stop, sw_sp : in std_logic;
			en_wait, en_lamp : out std_logic;
			ready_dec1,ready_dec2 : in std_logic;
			rd_dec1, rd_dec2 : out std_logic;
			rd_ula : out std_logic := '0';
			op_t, fp_t : in std_logic;
			wr_t, ce_t : out std_logic;
			rst_all : out std_logic
		);
	end component;
	
	component decoder_1
	   port (
		   clk : in std_logic;
			clk_sys : in std_logic;
			bt_pip, bt_piz, bt_las : in std_logic;
			rd_dec1 : in std_logic;
			rst_all : in std_logic;
			ready_dec1 : buffer std_logic := '0';
			bus_dec1 : out std_logic_vector (bus_max_width downto 0)
		);
	end component;
	
	component decoder_2
	   port (
		   clk : in std_logic;
			clk_sys : in std_logic;
			bt_3, bt_5 : in std_logic;
			rd_dec2 : in std_logic;
			rst_all : in std_logic;
			ready_dec2 : buffer std_logic := '0';
			bus_dec2 : out std_logic_vector (bus_max_width downto 0)
		);
	end component;
	
	component ula
	    port (
		   clk_sys : in std_logic;
			t1_in, t2_in : in std_logic_vector (bus_max_width downto 0);
			t_somado : out std_logic_vector (bus_max_width downto 0);
			carry : out std_logic;
			rd_ula : in std_logic
		);
	end component;
	
	component Temporizador
	   port (
		   clk_t, ce_t, wr_t, rst_all : in std_logic;
			bus_t_in : in std_logic_vector (bus_max_width downto 0);
			t_out : out std_logic_vector (bus_max_width downto 0);
			op_t, fp_t : out std_logic
		);
	end component;
	
	component Ripple_Clock
	   generic ( fator : integer := 100 );
	   port (
		   clk_in : in std_logic;
			clk_out : out std_logic
		);
	end component;
	
	component LCD_Driver
		generic(fsd_Clk_divider: integer:= 40000);
		port (
			fsd_Clk, fsd_Reset		: in std_logic;
			fsd_SelecionaChar		: in std_logic;
			fsd_AtivaEscrita		: in std_logic;
			fsd_EnderecoEscritaX	: in  std_logic_vector (3 downto 0);
			fsd_EnderecoEscritaY	: in  std_logic_vector (1 downto 0);
			fsd_DadosEmChar  		: in  character;
			fsd_DadosEmBinario  	: in std_logic_vector(7 downto 0);
			fsd_RS, fsd_RW			: out std_logic;
			fsd_E						: Buffer std_logic;
			fsd_Dados				: out std_logic_vector(7 downto 0);
			fsd_tempo            : in std_logic_vector(15 downto 0)
		);
	end component;
	
	component Controlador_LCD
		port(
			clk_lcd : in std_logic;
			selecionaChar: out std_logic;
			endereco: out std_logic_vector(5 downto 0);
			caracter: out character
		);
	end component;
	
	component debounce
      generic(
		   tamanho_contador : integer := 19);
      port (
         clk : in  std_logic; 
         in_botao : in  std_logic;
         resultado : out std_logic
		);
   end component;
	
	-- sinais de controle do LCD
	signal fio_resetar_lcd_driver, fio_selecionaChar : std_logic;
	signal fio_endereco_lcd : std_logic_vector (5 downto 0);
	signal fio_caracter_lcd: character;
	
	-- sinais de controle do decodificador 1
	signal fio_ready_dec1, fio_rd_dec1 : std_logic;
	
	-- sinais de controle do decodificador 2
	signal fio_ready_dec2, fio_rd_dec2 : std_logic;
	
	-- sinais de controle dos botoes
	signal fio_bt_start, fio_bt_cancel, fio_bt_stop : std_logic;
	
	-- sinais de controle da ULA
	signal fio_rd_ula : std_logic;
	
	-- sinais de controle do temporizador
	signal fio_op_t, fio_fp_t, fio_wr_t, fio_ce_t : std_logic;
	
	-- sinais dos barramentos
	signal barramento, barramento_ula : std_logic_vector (bus_max_width downto 0);
	
	-- sinal de controle assincrono para resetar todos os componentes
	signal fio_rst_all : std_logic;
	
	-- saida do clock dividido
	signal CLOCK_SYS_OUT, CLOCK_TEMPORIZADOR : std_logic;
	
	signal fio_saida_t : std_logic_vector (bus_max_width downto 0);
	
begin

   -- componentes de clock
   divisorFreq_CLOCK: Ripple_Clock generic map
	   (fator => sys_clock_divider)
	port map
	   (CLOCK, CLOCK_SYS_OUT);

   divisorFreq_LCDDriver: Ripple_Clock port map
	   (CLOCK, fio_resetar_lcd_driver);
	
	-- CONTROLADOR
	compControlador : Controlador port map (
	   clk => CLOCK_SYS_OUT,
		bt_start => fio_bt_start,
		bt_stop => fio_bt_stop,
		bt_cancel => fio_bt_cancel,
		sw_sp => SW_SENPORTA,
		en_wait => LED_ESPERA,
		en_lamp => LED_OPERANDO, -- LED OPERANDO
		ready_dec1 => fio_ready_dec1,
		ready_dec2 => fio_ready_dec2,
		rd_dec1 => fio_rd_dec1,
		rd_dec2 => fio_rd_dec2,
		rd_ula => fio_rd_ula,
		op_t => fio_op_t,
		fp_t => fio_fp_t,
		wr_t => fio_wr_t,
		ce_t => fio_ce_t,
		rst_all => fio_rst_all );
	
	-- DECODER 1
	compDecoder_1 : decoder_1 port map (
	   clk => CLOCK,
		clk_sys => CLOCK_SYS_OUT,
	   bt_pip => BT_PIP,
		bt_piz => BT_PIZ,
		bt_las => BT_LAS,
		ready_dec1 => fio_ready_dec1, -- fio_ready_dec1
		rst_all => fio_rst_all,
		rd_dec1 => fio_rd_dec1,
		bus_dec1 => barramento
	);
	
	-- DECODER 2
	compDecoder_2 : decoder_2 port map (
		clk => CLOCK,
		clk_sys => CLOCK_SYS_OUT,
		bt_3 => BT_3,
		bt_5 => BT_5,
		rd_dec2 => fio_rd_dec2,
		rst_all => fio_rst_all,
		ready_dec2 => fio_ready_dec2,
		bus_dec2 => barramento_ula
	);
	
	-- ULA
	compULA : ula port map (
	   clk_sys => CLOCK_SYS_OUT,
	   t1_in => fio_saida_t,
		t2_in => barramento_ula,
		t_somado => barramento,
		carry => open,
		rd_ula => fio_rd_ula
	);
	
	-- TEMPORIZADOR
	compTemporizador : Temporizador port map (
	   clk_t => CLOCK_SYS_OUT,
	   ce_t => fio_ce_t,
		wr_t => fio_wr_t,
		rst_all => fio_rst_all,
		bus_t_in => barramento,
		t_out => fio_saida_t, -- Ligado no driver do LCD e na entrada 1 da ULA
		op_t => fio_op_t,
		fp_t => fio_fp_t
	);
	
	-- COMPONENTES DO LCD
	compControlador_LCD: Controlador_LCD
   	port map (
			clk_lcd => CLOCK,
			selecionaChar => fio_selecionaChar,
			endereco => fio_endereco_lcd,
			caracter => fio_caracter_lcd
		);
		
	compLCD_Driver: LCD_Driver port map
		(CLOCK, fio_resetar_lcd_driver, fio_selecionaChar, '1', fio_endereco_lcd(3 downto 0), fio_endereco_lcd(5 downto 4),
	   fio_caracter_lcd, x"00", LCD_RS, LCD_RW, LCD_E, LCD_DADOS, fio_saida_t);
	
	-- port map de debounce para os botoes
	debounce_bt_start : debounce port map (
	   clk => CLOCK,
		in_botao => BT_START,
		resultado => fio_bt_start
	);
	
	debounce_bt_cancel : debounce port map (
	   clk => CLOCK,
		in_botao => BT_CANCEL,
		resultado => fio_bt_cancel
	);
	
	debounce_bt_stop : debounce port map (
	   clk => CLOCK,
		in_botao => BT_STOP,
		resultado => fio_bt_stop
	);
	
end microondas;