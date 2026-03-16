
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circuit_tb is
end;

architecture bench of circuit_tb is
  -- Generics
  -- Ports
  signal a : std_logic;
  signal b : std_logic;
  signal enable : std_logic;
  signal y : std_logic;
begin

  circuit_inst : entity work.circuit
  port map (
    a => a,
    b => b,
    enable => enable,
    y => y
  );
-- clk <= not clk after clk_period/2;

process
begin
  a <= '1'; wait for 10 ns;
  a <= '0'; wait for 10 ns;
end process;

process
begin
 b <= '0'; wait for 20 ns;
 b <= '1'; wait for 20 ns;
end process;

process
begin
 enable <= '0'; wait for 40 ns; 
 enable <= '1'; wait for 40 ns;
end process;


end architecture bench;