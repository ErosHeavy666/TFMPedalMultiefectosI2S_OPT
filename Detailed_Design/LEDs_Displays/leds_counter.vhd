----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------
-- Entity --
------------
entity leds_counter is
  port (  
    clk         : in std_logic;
    n_reset     : in std_logic;
    o_leds_rate : out std_logic
  );
end leds_counter;

------------------
-- Architecture --
------------------
architecture arch_leds_counter of leds_counter is
  
  -- Constants 
  constant c_REFRESH_RATE : integer := 47041; -- MCLK/240Hz = 11290000/240 = 47041
    
  -- Signals
  signal r_cnt_leds_rate, s_cnt_leds_rate : unsigned(15 downto 0);
  signal r_leds_rate, s_leds_rate : std_logic;
    
begin

  -- Register process:
  r_ledslay_counter_process : process(clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
        r_cnt_leds_rate <= (others => '0');
        r_leds_rate <= '0';
      else
        r_cnt_leds_rate <= s_cnt_leds_rate;
        r_leds_rate <= s_leds_rate;
      end if;
    end if;
  end process;
    
  -- Combinational logic process:
  s_ledslay_counter_process : process(r_cnt_leds_rate)
  begin
    if (r_cnt_leds_rate = to_unsigned(c_REFRESH_RATE, r_cnt_leds_rate'length)) then -- Limit reached so reset
        s_cnt_leds_rate <= (others => '0');
        s_leds_rate <= '1';
    else -- Counts
        s_cnt_leds_rate <= r_cnt_leds_rate + 1;
        s_leds_rate <= '0';
    end if;
  end process;

  -- Output process:
  o_leds_rate <= r_leds_rate; 
  
end arch_leds_counter;