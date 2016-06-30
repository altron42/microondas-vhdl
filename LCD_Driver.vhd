library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity LCD_Driver is
	generic(fsd_Clk_divider: integer:= 40000);
	port(
		fsd_Clk, fsd_Reset	: in std_logic;
		fsd_SelecionaChar		: in std_logic;
		fsd_AtivaEscrita		: in std_logic;
		fsd_EnderecoEscritaX	: in  std_logic_vector (3 downto 0);
		fsd_EnderecoEscritaY	: in  std_logic_vector (1 downto 0);
		fsd_DadosEmChar  		: in  character;
		fsd_DadosEmBinario  	: in std_logic_vector(7 downto 0);
		fsd_RS, fsd_RW			: out std_logic;
		fsd_E					   : Buffer std_logic;
		fsd_Dados				: out std_logic_vector(7 downto 0)
	);
end Lcd_Driver;

architecture LCD_ME of LCD_Driver is
	type fsd_estado is (functionSet1, functionSet2, functionSet3, functionSet4,
						clearDisplay, displayControl, entryMode, 
						P0, P1, P2, P3, P4, P5, P6, P7, P8, 
						P9, P10, P11, P12, P13, P14, P15,
						P16, P17, P18, P19, posicionaLinha2,
						P20, P21, P22, P23, P24, P25, P26, P27,
						P28, P29, P30, P31, P32, P33, P34,
						P35, P36, P37, P38, P39, posicionaLinha3,
						P40, P41, P42, P43, P44, P45, P46, P47,
						P48, P49, P50, P51, P52, P53, P54, P55,
						P56, P57, P58, P59, posicionaLinha4,
						P60, P61, P62, P63, P64, P65, P66, P67, P68, P69,
						P70, P71, P72, P73, P74, P75, P76, P77, P78, P79,
						returnHome);
	signal fsd_est, fsd_estado_prox: fsd_estado;
	type fsd_memoria is array (0 to 79) of std_logic_vector(7 downto 0);
   signal fsd_RAM : fsd_memoria := (0 to 79 =>	x"20");
	signal fsd_EnderecoEscrita: std_logic_vector(5 downto 0);
	
begin
	process(fsd_Clk, fsd_AtivaEscrita) is
	begin
		fsd_EnderecoEscrita(5 downto 4) <= fsd_EnderecoEscritaY;
		fsd_EnderecoEscrita(3 downto 0) <= fsd_EnderecoEscritaX;
		if fsd_Reset = '1' then
			for i in fsd_RAM'range loop
				fsd_RAM(i) <= x"20";
			end loop;
		elsif (rising_edge(fsd_Clk) and fsd_AtivaEscrita = '1') then
			if fsd_SelecionaChar = '1' then
				fsd_RAM(to_integer(unsigned(fsd_EnderecoEscrita))) <= std_logic_vector(to_unsigned(character'pos(fsd_DadosEmChar),8));
			else
				fsd_RAM(to_integer(unsigned(fsd_EnderecoEscrita))) <= fsd_DadosEmBinario;
			end if;
		end if;
	end process;
	
	process(fsd_Clk)
		variable fsd_count: integer range 0 to fsd_Clk_divider;
	begin
		if rising_edge(fsd_Clk) then
			fsd_count := fsd_count + 1;
			if fsd_count = fsd_Clk_divider then
				fsd_E <= not fsd_E;
				fsd_count := 0;
			end if;
		end if;
	end process;
	
	process(fsd_E)
	begin
		if rising_edge(fsd_E) then
			fsd_est <= fsd_estado_prox;
		end if;
	end process;
	
	process(fsd_est)
	begin
	
		case fsd_est is
			when functionSet1 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet2;
			when functionSet2 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet3;
			when functionSet3 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= functionSet4;
			when functionSet4 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00111000";
				fsd_estado_prox <= clearDisplay;
			when clearDisplay =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00000001";
				fsd_estado_prox <= displayControl;
			-- Alterar display control para nao mostrar o cursor "00001100"
			when displayControl =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00001100";
				fsd_estado_prox <= entryMode;
			when entryMode =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= "00000110";
				fsd_estado_prox <= P0;
				
				
			when P0 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(0);
				fsd_estado_prox <= P1;
			when P1 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(1);
				fsd_estado_prox <= P2;
			when P2 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(2);
				fsd_estado_prox <= P3;
			when P3 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(3);
				fsd_estado_prox <= P4;
			when P4 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(4);
				fsd_estado_prox <= P5;
			when P5 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(5);
				fsd_estado_prox <= P6;
			when P6 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(6);
				fsd_estado_prox <= P7;
			when P7 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(7);
				fsd_estado_prox <= P8;
			when P8 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(8);
				fsd_estado_prox <= P9;
			when P9 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(9);
				fsd_estado_prox <= P10;
			when P10 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(10);
				fsd_estado_prox <= P11;
			when P11 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(11);
				fsd_estado_prox <= P12;
			when P12 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(12);
				fsd_estado_prox <= P13;
			when P13 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(13);
				fsd_estado_prox <= P14;
			when P14 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(14);
				fsd_estado_prox <= P15;
			when P15 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(15);
				fsd_estado_prox <= P16;
			when P16 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(16);
				fsd_estado_prox <= P17;
			when P17 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(17);
				fsd_estado_prox <= P18;
			when P18 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(18);
				fsd_estado_prox <= P19;
			when P19 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(19);
				fsd_estado_prox <= posicionaLinha2;
			when posicionaLinha2 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				-- Set DDRAM address = 40H para ir para a segunda linha
				fsd_Dados <= x"C0";
				fsd_estado_prox <= P20;
			when P20 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(20);
				fsd_estado_prox <= P21;
			when P21 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(21);
				fsd_estado_prox <= P22;
			when P22 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(22);
				fsd_estado_prox <= P23;
			when P23 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(23);
				fsd_estado_prox <= P24;
			when P24 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(24);
				fsd_estado_prox <= P25;
			when P25 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(25);
				fsd_estado_prox <= P26;
			when P26 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(26);
				fsd_estado_prox <= P27;
			when P27 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(27);
				fsd_estado_prox <= P28;
			when P28 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(28);
				fsd_estado_prox <= P29;
			when P29 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(29);
				fsd_estado_prox <= P30;
			when P30 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(30);
				fsd_estado_prox <= P31;
			when P31 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(31);
				fsd_estado_prox <= P32;
			when P32 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(32);
				fsd_estado_prox <= P33;
			when P33 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(33);
				fsd_estado_prox <= P34;
			when P34 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(34);
				fsd_estado_prox <= P35;
			when P35 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(35);
				fsd_estado_prox <= P36;
			when P36 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(36);
				fsd_estado_prox <= P37;
			when P37 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(37);
				fsd_estado_prox <= P38;
			when P38 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(38);
				fsd_estado_prox <= P39;
			when P39 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(39);
				fsd_estado_prox <= posicionaLinha3;
			when posicionaLinha3 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= x"94";
				fsd_estado_prox <= P40;
			when P40 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(40);
				fsd_estado_prox <= P41;
			when P41 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(41);
				fsd_estado_prox <= P42;
			when P42 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(42);
				fsd_estado_prox <= P43;
			when P43 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(43);
				fsd_estado_prox <= P44;
			when P44 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(44);
				fsd_estado_prox <= P45;
			when P45 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(45);
				fsd_estado_prox <= P46;
			when P46 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(46);
				fsd_estado_prox <= P47;
			when P47 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(47);
				fsd_estado_prox <= P48;
			when P48 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(48);
				fsd_estado_prox <= P49;
			when P49 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(49);
				fsd_estado_prox <= P50;
			when P50 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(50);
				fsd_estado_prox <= P51;
			when P51 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(51);
				fsd_estado_prox <= P52;
			when P52 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(52);
				fsd_estado_prox <= P53;
			when P53 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(53);
				fsd_estado_prox <= P54;
			when P54 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(54);
				fsd_estado_prox <= P55;
			when P55 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(55);
				fsd_estado_prox <= P56;
			when P56 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(56);
				fsd_estado_prox <= P57;
			when P57 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(57);
				fsd_estado_prox <= P58;
			when P58 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(58);
				fsd_estado_prox <= P59;
			when P59 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(59);
				fsd_estado_prox <= posicionaLinha4;
			when posicionaLinha4 =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= x"D4";
				fsd_estado_prox <= P60;
			when P60 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(60);
				fsd_estado_prox <= P61;
			when P61 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(61);
				fsd_estado_prox <= P62;
			when P62 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(62);
				fsd_estado_prox <= P63;
			when P63 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(63);
				fsd_estado_prox <= P64;
			when P64 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(64);
				fsd_estado_prox <= P65;
			when P65 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(65);
				fsd_estado_prox <= P66;
			when P66 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(66);
				fsd_estado_prox <= P67;
			when P67 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(67);
				fsd_estado_prox <= P68;
			when P68 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(68);
				fsd_estado_prox <= P69;
			when P69 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(69);
				fsd_estado_prox <= P70;
			when P70 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(70);
				fsd_estado_prox <= P71;
			when P71 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(71);
				fsd_estado_prox <= P72;
			when P72 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(72);
				fsd_estado_prox <= P73;
			when P73 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(73);
				fsd_estado_prox <= P74;
			when P74 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(74);
				fsd_estado_prox <= P75;
			when P75 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(75);
				fsd_estado_prox <= P76;
			when P76 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(76);
				fsd_estado_prox <= P77;
			when P77 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(77);
				fsd_estado_prox <= P78;
			when P78 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(78);
				fsd_estado_prox <= P79;
			when P79 =>
				fsd_RS <= '1'; fsd_RW <= '0';
				fsd_Dados <= fsd_RAM(79);
				fsd_estado_prox <= returnHome;
			when returnHome =>
				fsd_RS <= '0'; fsd_RW <= '0';
				fsd_Dados <= x"80";
				fsd_estado_prox <= P0;
			when others	=> fsd_estado_prox <= functionSet1;
		end case;
	end process;
end LCD_ME;