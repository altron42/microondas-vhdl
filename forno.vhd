library ieee;
use ieee.std_logic_1164.all;

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

   component Decrementador
	   port (
		   clk, load, enable, rst : in std_logic;
			ate5 : in std_logic;
			carry : out std_logic;
			din : in std_logic_vector (3 downto 0);
			dout : out std_logic_vector (3 downto 0)
		);
	end component;
	
	component Temporizador
	   port (
		   clk_t, ce_t, wr_t, rst_all : in std_logic;
			t_in : in std_logic_vector (15 downto 0);
			t_out : out std_logic_vector (15 downto 0);
			op_t, fp_t : out std_logic
		);
	end component;
	
	component Ripple_Clock
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
	
	signal fio_resetar_lcd_driver, fio_selecionaChar : std_logic;
	signal fio_endereco_lcd : std_logic_vector (5 downto 0);
	signal fio_caracter_lcd: character;
	
begin
   divisorFreq_LCDDriver: Ripple_Clock port map
	   (CLOCK, fio_resetar_lcd_driver);
	compControlador_LCD: Controlador_LCD port map
		(CLOCK, fio_selecionaChar, fio_endereco_lcd, fio_caracter_lcd);
	compLCDDriver: LCD_Driver port map
		(CLOCK, fio_resetar_lcd_driver, fio_selecionaChar, '1', fio_endereco_lcd(3 downto 0), fio_endereco_lcd(5 downto 4),
	   fio_caracter_lcd, x"00", LCD_RS, LCD_RW, LCD_E, LCD_DADOS);
end microondas;