library ieee;
use ieee.std_logic_1164.all;

Entity Contador_Anel is

Port (
	clk: in std_logic;
	dav : in std_logic;
	linha : buffer std_logic_vector (3 downto 0)
);
end Contador_Anel;

architecture f1 of Contador_Anel is
begin
process(clk, dav)
	variable aux: std_logic_vector(3 downto 0):= "0001";
	begin
		if (rising_edge(clk)) then
			if (dav = '0') then
				linha <= aux;
				case aux is
					when "1110" => aux := "1101";
					when "1101" => aux := "1011";
					when "1011" => aux := "0111";
					when "0111" => aux := "1110";
					when others => aux := "1110";
				end case;
			end if;  
		end if;
	end process;
end f1;