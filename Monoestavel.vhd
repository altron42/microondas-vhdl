library ieee;
use ieee.std_logic_1164.all;

entity Monoestavel is
    port ( trig   : in  std_logic;
           clk    : in  std_logic;
           x      : out std_logic);
end Monoestavel;
            
architecture comportamento of Monoestavel is
    type StateType is (IDLE, EDGE, WAIT0);
    signal sto_atual : StateType := IDLE;
begin
    x <= '1' when sto_atual = EDGE else '0';
    process (clk)
    begin
        if rising_edge(clk) then
            if trig = '0' then
                sto_atual <= IDLE;
            elsif sto_atual = IDLE then
                sto_atual <= EDGE;
            elsif sto_atual = EDGE then
                sto_atual <= WAIT0;
            end if;
        end if;
    end process;
end comportamento;