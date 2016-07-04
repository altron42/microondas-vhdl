library ieee;
use ieee.std_logic_1164.all;

entity Temporizador is
   -- divisor de clock faz 1 Hz (1 pulso) a cada 50 Mhz de clk_t
   generic(divisor_clk_t: integer := 50000000);
   port (
	   clk_t, ce_t, wr_t, rst_all : in std_logic;
		bus_t_in : in std_logic_vector (15 downto 0);
		t_out : out std_logic_vector (15 downto 0);
		op_t, fp_t : out std_logic
	);
end Temporizador;

architecture temporizador_MS of Temporizador is
   
	component decrementador_bcd
	   port (
		   clk, load, enable, rst, estouro : in std_logic;
			din : in std_logic_vector (3 downto 0);
			dout : out std_logic_vector (3 downto 0);
			carry : out std_logic
		);
	end component;
   
	signal enable_0, enable_1, enable_2, enable_3 : std_logic;
	signal carry_0, carry_1, carry_2, carry_3 : std_logic;
	signal fp_buffer : std_logic;
	
	signal bcd_clk : std_logic := '1';

begin
   -- Divisor de clock para adequar a contagem de segundo em segundo
   process (clk_t)
	   variable count_t : integer range 0 to divisor_clk_t;
	begin
	   if rising_edge(clk_t) then
		   count_t := count_t + 1;
			if count_t = divisor_clk_t then
			   bcd_clk <= not bcd_clk;
				count_t := 0;
			end if;
		end if;
	end process;

	-- Unidade logica
   fp_buffer <= carry_0 and carry_1 and carry_2 and carry_3;	
   enable_0 <= ce_t and not fp_buffer;
	enable_1 <= carry_0 and enable_0;
	enable_2 <= carry_1 and enable_1;
	enable_3 <= carry_2 and enable_2;
	op_t <= enable_0;
	fp_t <= fp_buffer;
	
   -- port map dos decrementadores bcd
   decrementador_0 : decrementador_bcd port map
	   (bcd_clk, wr_t, enable_0, rst_all, '0',
		bus_t_in(3 downto 0), t_out(3 downto 0), carry_0);
		
	decrementador_1 : decrementador_bcd port map
	   (bcd_clk, wr_t, enable_1, rst_all, '1',
		bus_t_in(7 downto 4), t_out(7 downto 4), carry_1);
		
	decrementador_2 : decrementador_bcd port map
	   (bcd_clk, wr_t, enable_2, rst_all, '0',
		bus_t_in(11 downto 8), t_out(11 downto 8), carry_2);
		
	decrementador_3 : decrementador_bcd port map
	   (bcd_clk, wr_t, enable_3, rst_all, '0',
		bus_t_in(15 downto 12), t_out(15 downto 12), carry_3);

end temporizador_MS;