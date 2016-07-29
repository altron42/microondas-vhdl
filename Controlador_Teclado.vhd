library ieee;
use ieee.std_logic_1164.all;

entity Controlador_Teclado is
	port (
		  clock : in std_logic;
		  coluna : in std_logic_vector (3 downto 0);
		  linha : buffer std_logic_vector (3 downto 0);
		  rd_kb : in std_logic;
		  dav_kb : out std_logic;
		  cod_out : out std_logic_vector (15 downto 0)
	);
end Controlador_Teclado;

architecture f4 of Controlador_Teclado is
	
	signal saida : std_logic_vector (7 downto 0); --  linha concatenada com a coluna 
	signal dav : std_logic; -- dispositivo disponivel (alguma tecla foi pressionada)
	signal cod, cod_reg : std_logic_vector (3 downto 0); -- codigo em binario da tecla pressionada
	
	component Contador_Anel
	port (
		clk: in std_logic;
		dav : in std_logic;
		linha : buffer std_logic_vector (3 downto 0)
		);
	end component;
	
	component Registrador_Teclado
	port (
		cod: in std_logic_vector (3 downto 0);
		cod_reg : out std_logic_vector (3 downto 0);
		dav : in std_logic
	);
	end component;
	
	component Detector_Teclas
	port (
		dav : out std_logic;
		coluna : in std_logic_vector (3 downto 0)
	);
	end component;
	
	component Decoder_Teclado
	port (
		saida : in std_logic_vector (7 downto 0);
		cod : out std_logic_vector (3 downto 0)
	);
	end component;
	
begin

   CA : Contador_Anel port map (
		clk => clock,
		dav => dav,
		linha => linha
	);
	
	DT : Detector_teclas port map (
		dav => dav,
		coluna => coluna
	);	
	
	REG : Registrador_Teclado port map (
 		cod => cod,
 		cod_reg => cod_reg,
 		dav => dav
 	);
	
	DEC : Decoder_Teclado port map (
		saida => saida,
		cod => cod
	);
	
	dav_kb <= dav;
	saida <= linha & coluna;
	
	cod_out <= "000000000000" & cod_reg when rd_kb = '1' else (others => 'Z');

end f4;