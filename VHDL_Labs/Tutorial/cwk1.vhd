library ieee;
use ieee.std_logic_1164.all;

entity cwk1 is
  port ( a, b, c, d : in std_logic;
         x, y : out std_logic );
end;

architecture rtl of cwk1 is
  signal nand_out : std_logic;
  signal not_c    : std_logic;
  signal and_out  : std_logic;
  signal mux_out  : std_logic;
begin
  nand_out <= a nand b;
  not_c    <= not c;
  and_out  <= not_c and b and d;
  mux_out  <= nand_out when and_out = '0' else d;
  x        <= mux_out or b;
  y        <= and_out;
end architecture;