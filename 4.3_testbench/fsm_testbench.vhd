library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_tb is
end fsm_tb;

architecture testbench of fsm_tb is

    component fsm
        port (
            clock : in  std_logic;
            reset : in  std_logic;
            i     : in  std_logic_vector(1 downto 0);
            x     : out std_logic;
            y     : out std_logic;
            z     : out std_logic
        );
    end component;

    signal clock : std_logic;
    signal reset : std_logic;
    signal i     : std_logic_vector(1 downto 0);
    signal x     : std_logic;
    signal y     : std_logic;
    signal z     : std_logic;

begin

    uut: entity work.fsm
    port map (
        clock => clock,
        reset => reset,
        i     => i,
        x     => x,
        y     => y,
        z     => z
    );

    ---clk stays low for first 50ns, so we can see async reset sets S5 immediately at 25ns, before first rising clk 
    clock_gen: process
    begin
        clock <= '0'; wait for 50 ns;
        clock <= '1'; wait for 50 ns;
    end process;

    ---generate i, take 25ns interval after the preivous rising edge to make it stable
    stimulus_gen: process
    begin
        -- 0ns: start with reset high
        reset <= '1';
        i     <= "00";

        wait for 25 ns;
        reset <= '0';

        -- 75ns: first rising edge was at 50ns (S5, i=00, stays S5)
        -- change i after 50ns edge, ready for 150ns edge
        wait for 75 ns;     -- now at 100ns, just passed 50ns edge
        i <= "01";          -- S5 + i=01 → S2 at 150ns edge

        wait for 100 ns;    -- now at 200ns, just passed 150ns edge
        i <= "11";          -- S2 + i=11 → S3 at 250ns edge

        wait for 100 ns;    -- now at 300ns, just passed 250ns edge
        i <= "00";          -- S3 + i=00 → S4 at 350ns edge

        wait for 100 ns;    -- now at 400ns, just passed 350ns edge
        i <= "10";          -- S4 + i=10 → S3 at 450ns edge

        wait for 100 ns;    -- now at 500ns, just passed 450ns edge
        i <= "11";          -- S3 + i=11 → S2 at 550ns edge

        wait for 100 ns;    -- now at 600ns, just passed 550ns edge
        i <= "10";          -- S2 + i=10 → S5 at 650ns edge

        wait for 100 ns;    -- now at 700ns, just passed 650ns edge
        i <= "11";          -- S5 + i=11 → S1 at 750ns edge

        wait for 100 ns;    -- now at 800ns, just passed 750ns edge
        i <= "11";          -- S1 + i=11 → S2 at 850ns edge

        -- 900ns: test async reset from S2
        -- next rising edge is 950ns
        wait for 100 ns;    -- now at 900ns, just passed 850ns edge
        reset <= '1';       -- async → S5 immediately at 900ns
                            -- NOT waiting for 950ns edge

        wait for 100 ns;    -- now at 1000ns
        reset <= '0';       -- release reset, still S5
        i <= "01";          -- S5 + i=01 → S2 at 1050ns edge
                            -- used for rising edge test

        wait;
    end process;

    -- =============================================
    -- monitor
    -- rule: assert ~25ns AFTER a rising edge
    --       outputs settle quickly after edge
    --       never assert ON the edge itself
    -- =============================================
    monitor: process
    begin
        -- 75ns: reset went low at 25ns, async so S5 now
        -- safely between 50ns and 150ns rising edges
        wait for 75 ns;
        assert (x = '1' and y = '0' and z = '1')
            report "ERROR - should be in S5 after reset"
            severity FAILURE;

        -- 175ns: 150ns edge fired with i=01 → should be S2
        -- safely between 150ns and 250ns edges
        wait for 100 ns;    -- now at 175ns
        assert (x = '0' and y = '0' and z = '1')
            report "ERROR - S5+i=01 should go to S2"
            severity FAILURE;

        -- 275ns: 250ns edge fired with i=11 → should be S3
        wait for 100 ns;    -- now at 275ns
        assert (x = '1' and y = '1' and z = '0')
            report "ERROR - S2+i=11 should go to S3"
            severity FAILURE;

        -- 375ns: 350ns edge fired with i=00 → should be S4
        wait for 100 ns;    -- now at 375ns
        assert (x = '0' and y = '1' and z = '1')
            report "ERROR - S3+i=00 should go to S4"
            severity FAILURE;

        -- 475ns: 450ns edge fired with i=10 → should be S3
        wait for 100 ns;    -- now at 475ns
        assert (x = '1' and y = '1' and z = '0')
            report "ERROR - S4+i=10 should go to S3"
            severity FAILURE;

        -- 575ns: 550ns edge fired with i=11 → should be S2
        wait for 100 ns;    -- now at 575ns
        assert (x = '0' and y = '0' and z = '1')
            report "ERROR - S3+i=11 should go to S2"
            severity FAILURE;

        -- 675ns: 650ns edge fired with i=10 → should be S5
        wait for 100 ns;    -- now at 675ns
        assert (x = '1' and y = '0' and z = '1')
            report "ERROR - S2+i=10 should go to S5"
            severity FAILURE;

        -- 775ns: 750ns edge fired with i=11 → should be S1
        wait for 100 ns;    -- now at 775ns
        assert (x = '0' and y = '1' and z = '0')
            report "ERROR - S5+i=11 should go to S1"
            severity FAILURE;

        -- 875ns: 850ns edge fired with i=11 → should be S2
        wait for 100 ns;    -- now at 875ns
        assert (x = '0' and y = '0' and z = '1')
            report "ERROR - S1+i=11 should go to S2"
            severity FAILURE;

        -- =============================================
        -- test ASYNC reset
        -- reset went high at 900ns
        -- next rising edge is at 950ns
        -- check at 925ns: safely between 900ns and 950ns
        -- async → already S5 at 900ns
        -- sync  → still S2 until 950ns edge
        -- =============================================
        wait for 50 ns;     -- now at 925ns
        assert (x = '1' and y = '0' and z = '1')
            report "ERROR - reset is not asynchronous"
            severity FAILURE;

        -- =============================================
        -- test RISING edge (not falling edge)
        -- reset released at 1000ns, i=01
        -- falling edge at 1000ns
        -- rising edge at 1050ns → S5+i=01 → S2
        -- check at 1025ns: between 1000ns falling
        --                  and 1050ns rising
        -- rising edge FSM: still S5 (hasn't clocked yet)
        -- falling edge FSM: already S2 (wrong!)
        -- =============================================
        wait for 100 ns;    -- now at 1025ns
        assert (x = '1' and y = '0' and z = '1')
            report "ERROR - not triggered on rising edge"
            severity FAILURE;

        -- =============================================
        -- all tests passed
        -- =============================================
        assert FALSE
            report "OK. All tests passed. End of simulation."
            severity NOTE;

        wait;
    end process;

end;