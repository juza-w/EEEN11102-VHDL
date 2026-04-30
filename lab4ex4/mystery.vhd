library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mystery is
  port (
    rst : in  STD_LOGIC;
    clk : in  STD_LOGIC;
    d   : in  STD_LOGIC;
    e   : in  STD_LOGIC;
    a   : in  STD_LOGIC_VECTOR(3 downto 0);
    b   : in  STD_LOGIC_VECTOR(3 downto 0);
    x   : out STD_LOGIC_VECTOR(3 downto 0);
    y   : out STD_LOGIC_VECTOR(3 downto 0)
  );
end mystery;

architecture behavioral of mystery is
  signal q : STD_LOGIC_VECTOR(3 downto 0);
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        q <= "0000";
      elsif d = '0' then
        q <= a;
      end if;
    end if;
  end process;

  x <= q when e = '1' else "ZZZZ";
  y <= "ZZZZ";

end behavioral;
