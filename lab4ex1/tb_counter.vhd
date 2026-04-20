-- Digital Electronics VHDL Laboratory, Univeristy of  Manchester
-- VHDL Test Bench Created from source file counter.vhd
-- Lab #4 v2026

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter is
end;

architecture testbench of tb_counter is
  -- Ports
  signal preset : std_logic;
  signal clk : std_logic;
  signal up : std_logic;
  signal count : std_logic_vector (7 downto 0);

  component counter
    port (
      preset : in std_logic;
      clk    : in std_logic;
      up     : in std_logic;
      count  : out std_logic_vector (7 downto 0)
    );
  end component;

begin

  uut : counter
  port map (
    preset => preset,
    clk    => clk,
    up     => up,
    count  => count
  );
     clk <= '0'; wait for 500 ns;
     clk <= '1'; wait for 500 ns;
   end process; --clock_gen

   -----------------------------------
   -- other stimuli
   -----------------------------------
   stimulus_gen: process
   begin
	  -- preset the counter to initialise
	  preset <= '1';
	  -- set it to count up
	  up <= '1';
	  wait for 1.4 us;
     -- stop presetting, the counter should count up from now on...
	  preset <= '0';
	  wait for 4 us;
     -- then try counting down
	  up <= '0';
	  wait for 2.2 us;
     -- preset, should be asynchronous
	  preset <= '1';	  
	  
	  wait; -- wait forever (makes sure process does not loop)
   end process; -- stimulus_gen
   
   -----------------------------------
   -- monitor the outputs
   -----------------------------------
   monitor: process
   begin
	  -- first, wait for some time - the initialisation should be ignored in the testbench.
     wait for 1.2 us;
	  -- the counter should preset after first clock edge
	  assert (count = "11111111") report "ERROR - counter did not preset!" severity FAILURE;
	  -- the counter should count up, first it will overflow from 255 to 0
	  wait for 1 us;
	  assert (count = "00000000") report "ERROR - should be counting up" severity FAILURE;
	  -- counter is counting up for next 3 cycles
	  wait for 1 us;
	  assert (count = "00000001") report "ERROR - should be counting up" severity FAILURE;
	  wait for 1 us;
	  assert (count = "00000010") report "ERROR - should be counting up" severity FAILURE;
	  wait for 1 us;
	  assert (count = "00000011") report "ERROR - should be counting up" severity FAILURE;
	  
	  -- verify counting up continues correctly
	  wait for 1 us;
	  assert (count = "00000100") report "ERROR - should be counting up to 4" severity FAILURE;
	  wait for 1 us;
	  assert (count = "00000101") report "ERROR - should be counting up to 5" severity FAILURE;
	  wait for 1 us;
	  assert (count = "00000110") report "ERROR - should be counting up to 6" severity FAILURE;
	  wait for 1 us;
	  assert (count = "00000111") report "ERROR - should be counting up to 7" severity FAILURE;
	   
	  wait for 2 us;
	  -- now should be counting down
	  assert (count < "00001000") report "ERROR - should be counting down now" severity FAILURE;
	  wait for 1 us;
	  -- verify it continues counting down
	  assert (count < "00000110") report "ERROR - should continue counting down" severity FAILURE;
	  wait for 1 us;
	  -- verify it continues counting down
	  assert (count < "00000100") report "ERROR - should continue counting down further" severity FAILURE;
	  
	  wait for 1.2 us;
	  assert (count = "11111111") report "ERROR - counter did not preset at the end!" severity FAILURE;
	  -- end of tests
	  	  
	  -- the following line will generate an end of simulation message. This can be used make sure all test were run. 
	  assert FALSE report "All tests OK. End of simulation." severity NOTE;
	  wait; -- make sure the process stops here and doesnt loop.
   
	end process; -- monitor

end;
