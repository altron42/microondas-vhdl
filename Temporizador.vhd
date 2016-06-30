library ieee;
use ieee.std_logic_1164.all;

entity Temporizador
   port (
	   clk_t, ce_t, wr_t, rst_all : in std_logic;
		t_in : in std_logic_vector (15 downto 0);
		t_out : out std_logic_vector (15 downto 0);
		op_t, fp_t : out std_logic
	);
end Temporizador;

architecture temporizador_MS of Temporizador is
   
	component decrementador_bcd
	   port (
		   clk, load, enable, rst, ate5 : in std_logic;
			din : in std_logic_vector (3 downto 0);
			dout : out std_logic_vector (3 downto 0);
			carry : out std_logic
		);
	end component;
   
	signal enable_0, enable_1, enable_2, enable_3 : std_logic;
	signal carry_0, carry_1, carry_2, carry_3 : std_logic;
	signal fp_buffer : std_logic;

begin
   fp_buffer <= carry_0 and carry_1 and carry_2 and carry_3;
	
   enable_0 <= ce_t and not fp_buffer;
	enable_1 <= carry_0 and enable_0;
	enable_2 <= carry_1 and enable_1;
	enable_3 <= carry_2 and enable_2;
	
	op_t <= enable_0;
	fp_t < fp_buffer;
	
   -- port map dos decrementadores bcd
   decrementador_0 : decrementador_bcd port map
	   (clk_t, wr_t, enable_0, rst_all, '0',
		t_in(3 downto 0), t_out(3 downto 0), carry_0);
		
	decrementador_1 : decrementador_bcd port map
	   (clk_t, wr_t, enable_1, rst_all, '1',
		t_in(7 downto 4), t_out(7 downto 4), carry_1);
		
	decrementador_2 : decrementador_bcd port map
	   (clk_t, wr_t, enable_2, rst_all, '0',
		t_in(11 downto 8), t_out(11 downto 8), carry_2);
		
	decrementador_3 : decrementador_bcd port map
	   (clk_t, wr_t, enable_3, rst_all, '0',
		t_in(15 downto 12), t_out(15 downto 12), carry_3);

end temporizador_MS;