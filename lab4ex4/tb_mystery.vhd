library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mystery is
end tb_mystery;

architecture testbench of tb_mystery is
  signal rst : std_logic := '0';
  signal clk : std_logic := '0';
  signal d   : std_logic := '1';
  signal e   : std_logic := '0';
  signal a   : std_logic_vector(3 downto 0) := "0000";
  signal b   : std_logic_vector(3 downto 0) := "0000";
  signal x   : std_logic_vector(3 downto 0);
  signal y   : std_logic_vector(3 downto 0);
begin

  uut: entity work.mystery
  port map (
    rst => rst, clk => clk, d => d,
    e => e, a => a, b => b,
    x => x, y => y
  );

  clock_gen: process
  begin
    clk <= '0'; wait for 50 ns;
    clk <= '1'; wait for 50 ns;
  end process;

  stimulus: process
  begin
    -- test reset
    rst <= '1';
    wait for 200 ns;
    rst <= '0';

    -- test load: d=0, a=1010, should load into q
    d <= '0';
    a <= "1010";
    wait for 200 ns;

    -- test hold: d=1, q should stay 1010
    d <= '1';
    wait for 200 ns;

    -- test output enable: e=1, x should show q
    e <= '1';
    wait for 200 ns;

    -- test output disable: e=0, x should be ZZZZ
    e <= '0';
    wait for 100 ns;

    assert FALSE
      report "OK. Simulation complete."
      severity NOTE;
    wait;
  end process;

end testbench;
