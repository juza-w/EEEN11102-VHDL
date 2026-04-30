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

	clock_gen; process
	begin
     clk <= '0'; wait for 500 ns;
     clk <= '1'; wait for 500 ns;
  end process; --clock_gen

   stimulus_gen: process
   begin
	  preset <= '1';
	  up <= '1';
	  wait for 1.4 us;
	  preset <= '0';
	  wait for 4 us;
	  up <= '0';
	  wait for 2.2 us;
	  preset <= '1';	  
	  
	  wait; 
   end process; 
   
 
   monitor: process
   begin
	 	wait for 1.2 us;
		assert (count = "11111111")
		 report "ERROR - counter di not preset"
		 severity FAILURE;
	
		wait for 500 ns;
		assert (count = "00000000")
			report "ERROR - counter not rising edge triggered"
			severity FIALURE;

		wait for 500 ns;
		assert (count = "00000000")
			report "ERROR - should be counting up"
			severity FAILURE;

		wait for 1 us;
		assert (count = "00000001")
			report "ERROR - should be counting up"
			severity FAILURE;
		
		wait for 1 us;
		assert (count = "00000010")
			report "ERROR - should be counting up"
      severity FAILURE;

		wait for 1 us;    
    assert (count = "00000011") 
        report "ERROR - should be counting up" 
        severity FAILURE;

	  wait for 500 ns;      
    assert (count = "00000010")
        report "ERROR - counter not counting down"
        severity FAILURE;

    -- check another down step
    wait for 1 us;      
    assert (count = "00000001")
        report "ERROR - counter not counting down"
	      severity FAILURE;
	
	 wait for 1300 ns;       
    assert (count = "11111111")
        report "ERROR - preset is not asynchronous"
        severity FAILURE;

    assert FALSE 
        report "OK. All tests passed. End of simulation." 
        severity NOTE;

		wait;
end monitor;




end;
