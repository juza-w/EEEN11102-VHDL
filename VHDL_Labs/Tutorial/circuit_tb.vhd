
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
  a <= '0', '1' after 20 ns;
  b <= '0', '1' after 40 ns;
  enable <= '0', '1' after 60 ns, '0' after 80 ns;
  wait for 100 ns;
end process;
end architecture bench;