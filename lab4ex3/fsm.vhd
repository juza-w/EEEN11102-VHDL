library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port (
        clock : in  std_logic;
        reset : in  std_logic;
        i     : in  std_logic_vector(1 downto 0);
        x     : out std_logic;
        y     : out std_logic;
        z     : out std_logic
    );
end fsm;

architecture behavioral of fsm is
    type stateval is (s1, s2, s3, s4, s5);
    signal state, next_state : stateval;
begin

    state_reg: process (clock, reset)
    begin
        if reset = '1' then
            state <= s5;
        elsif rising_edge(clock) then
            state <= next_state;
        end if;
    end process;

    next_state_logic: process (state, i)
    begin
        next_state <= state;
        case state is
            when s5 =>
                if    i = "01" then next_state <= s2;
                elsif i = "11" then next_state <= s1;
                end if;
            when s1 =>
                if i = "11" then next_state <= s2;
                end if;
            when s2 =>
                if    i = "11" then next_state <= s3;
                elsif i = "10" then next_state <= s5;
                end if;
            when s3 =>
                if    i = "11" then next_state <= s2;
                elsif i = "00" then next_state <= s4;
                end if;
            when s4 =>
                if    i = "00" then next_state <= s5;
                elsif i = "10" then next_state <= s3;
                end if;
        end case;
    end process;

    x <= '1' when (state = s3 or state = s5) else '0';
    y <= '1' when (state = s1 or state = s3 or state = s4) else '0';
    z <= '1' when (state = s2 or state = s4 or state = s5) else '0';

end behavioral;
