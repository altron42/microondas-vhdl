library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.constantes.all;

entity ula is
   port (
	   clk_sys : in std_logic;
	   t1_in, t2_in : in std_logic_vector (bus_max_width downto 0);
		t_somado : out std_logic_vector (bus_max_width downto 0);
		carry : out std_logic;
		rst_all : in std_logic;
		rd_ula : in std_logic
	);
end ula;

architecture ula_rtl of ula is
   
	component bcd_adder
	   port (
		   a, b  : in  std_logic_vector (3 downto 0);
         cin : in std_logic;
			estouro : in std_logic;
         sum : out std_logic_vector (3 downto 0);
         cout : out std_logic
		);
	end component;
	
	signal carry1, carry2, carry3 : std_logic;
   signal soma_parcial : std_logic_vector (bus_max_width downto 0);
	
begin

   adder1 : bcd_adder port map (
	   a => t1_in(3 downto 0),
		b => t2_in(3 downto 0),
		cin => '0',
		estouro => '0',
		cout => carry1,
		sum => soma_parcial(3 downto 0)
	);
	
	adder2 : bcd_adder port map (
	   a => t1_in(7 downto 4),
		b => t2_in(7 downto 4),
		cin => carry1,
		estouro => '1',
		cout => carry2,
		sum => soma_parcial(7 downto 4)
	);
	
	adder3 : bcd_adder port map (
	   a => t1_in(11 downto 8),
		b => t2_in(11 downto 8),
		cin => carry2,
		estouro => '0',
		cout => carry3,
		sum => soma_parcial(11 downto 8)
	);
	
	adder4 : bcd_adder port map (
	   a => t1_in(15 downto 12),
		b => t2_in(15 downto 12),
		cin => carry3,
		estouro => '0',
		cout => carry,
		sum => soma_parcial(15 downto 12)
	);
	
	process (clk_sys)
	begin
	   if rising_edge(clk_sys) then
		   if rd_ula = '1' then
		      t_somado <= soma_parcial; -- ativa leitura da soma e joga no barramento
		   else
			   t_somado <= (others => 'Z'); -- volta para estado de alta impedancia
			end if;
		end if;
	end process;

end ula_rtl;