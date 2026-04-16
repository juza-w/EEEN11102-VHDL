library ieee;
use ieee.std_logic_1164.all;
entity circuit is
  port (
    a, b, enable : in std_logic;
    y            : out std_logic
  );
end circuit;

architecture rtl of circuit is
  signal q : std_logic;
begin
  q <= a nand b;
  y <= not q when enable = '0' else 'Z';
end architecture;
