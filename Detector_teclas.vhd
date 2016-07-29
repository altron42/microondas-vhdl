library ieee;
use ieee.std_logic_1164.all;

Entity Detector_teclas is

Port (
	dav : out std_logic;
	coluna : in std_logic_vector (3 downto 0)
);
end Detector_teclas;

architecture f1 of Detector_teclas is
begin
	dav <= not (coluna(0) and coluna (1) and coluna (2) and coluna (3));
end f1;