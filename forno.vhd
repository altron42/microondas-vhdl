library ieee;
use ieee.std_logic_1164.all;

use work.constantes.all;

entity forno is
   port (
	   CLOCK : in std_logic;
	   BT_START, BT_CANCEL, BT_STOP : in std_logic;
		BT_PIP, BT_PIZ, BT_LAS : in std_logic;
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
			ready_dec1 : in std_logic;
			rd_dec1 : out std_logic;
			op_t, fp_t : in std_logic;
			wr_t, ce_t : out std_logic;
			rst_all : out std_logic
		);
	end component;
	
	component decoder_1
	   port (
		   clk : in std_logic;
			bt_pip, bt_piz, bt_las : in std_logic;
			rd_dec1 : in std_logic;
			ready_dec1 : out std_logic := '0';
			bus_dec1 : out std_logic_vector (bus_max_width downto 0)
		);
	end component;
	
	component Temporizador
	   generic(divisor_clk_t: integer := 25000000);
	   port (
		   clk_t, ce_t, wr_t, rst_all : in std_logic;
			bus_t_in : in std_logic_vector (15 downto 0);
			t_out : out std_logic_vector (15 downto 0);
			op_t, fp_t : out std_logic
		);
	end component;
	
	component Ripple_Clock
	   generic ( fator : integer := 200 );
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
			fsd_Dados				: out std_logic_vector(7 downto 0)
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
	
	-- sinais de controle do LCD
	signal fio_resetar_lcd_driver, fio_selecionaChar : std_logic;
	signal fio_endereco_lcd : std_logic_vector (5 downto 0);
	signal fio_caracter_lcd: character;
	
	-- sinais de controle do decodificador 1
	signal fio_ready_dec1, fio_rd_dec1 : std_logic;
	
	-- sinais de controle do temporizador
	signal fio_op_t, fio_fp_t, fio_wr_t, fio_ce_t : std_logic;
	
	-- Sinal do barramento
	signal barramento : std_logic_vector (bus_max_width downto 0);
	
	-- sinal de controle assincrono para resetar todos os componentes
	signal fio_rst_all : std_logic;
	
	signal fio_saida_t : std_logic_vector (bus_max_width downto 0);
	
begin
   divisorFreq_LCDDriver: Ripple_Clock port map
	   (CLOCK, fio_resetar_lcd_driver);
		
	compControlador : Controlador port map (
	   clk => CLOCK,
		bt_start => BT_START,
		bt_stop => BT_STOP,
		bt_cancel => BT_CANCEL,
		sw_sp => SW_SENPORTA,
		en_wait => LED_ESPERA,
		en_lamp => LED_OPERANDO,
		ready_dec1 => fio_ready_dec1,
		rd_dec1 => fio_rd_dec1,
		op_t => fio_op_t,
		fp_t => fio_fp_t,
		wr_t => fio_wr_t,
		ce_t => fio_ce_t,
		rst_all => fio_rst_all );
		
	compDecoder_1 : decoder_1 port map (
	   clk => CLOCK,
	   bt_pip => BT_PIP,
		bt_piz => BT_PIZ,
		bt_las => BT_LAS,
		ready_dec1 => fio_ready_dec1,
		rd_dec1 => fio_rd_dec1,
		bus_dec1 => barramento
	);
		
	compTemporizador : Temporizador port map (
	   clk_t => CLOCK,
	   ce_t => fio_ce_t,
		wr_t => fio_wr_t,
		rst_all => fio_rst_all,
		bus_t_in => barramento,
		t_out => fio_saida_t, -- falta ligar essa saida em algum lugar (provavelmente controlaodor do LCD e depois ULA)
		op_t => fio_op_t,
		fp_t => fio_fp_t
	);
		
	compControlador_LCD: Controlador_LCD port map
		(CLOCK, fio_selecionaChar, fio_endereco_lcd, fio_caracter_lcd);
		
	compLCD_Driver: LCD_Driver port map
		(CLOCK, fio_resetar_lcd_driver, fio_selecionaChar, '1', fio_endereco_lcd(3 downto 0), fio_endereco_lcd(5 downto 4),
	   fio_caracter_lcd, x"00", LCD_RS, LCD_RW, LCD_E, LCD_DADOS);
	
end microondas;