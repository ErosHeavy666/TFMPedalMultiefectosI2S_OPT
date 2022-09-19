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
entity display_counter is
  port (  
    clk         : in std_logic;
    n_reset     : in std_logic;
    o_disp_rate : out std_logic
  );
end display_counter;

------------------
-- Architecture --
------------------
architecture arch_display_counter of display_counter is
  
  -- Constants 
  constant c_REFRESH_RATE : integer := 28225; -- MCLK/400Hz = 11290000/400 = 28225
    
  -- Signals
  signal r_cnt_disp_rate, s_cnt_disp_rate : unsigned(14 downto 0);
  signal r_disp_rate, s_disp_rate : std_logic;
    
begin

  -- Register process:
  r_display_counter_process : process(clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
        r_cnt_disp_rate <= (others => '0');
        r_disp_rate <= '0';
      else
        r_cnt_disp_rate <= s_cnt_disp_rate;
        r_disp_rate <= s_disp_rate;
      end if;
    end if;
  end process;
    
  -- Combinational logic process:
  s_display_counter_process : process(r_cnt_disp_rate)
  begin
    if (r_cnt_disp_rate = to_unsigned(c_REFRESH_RATE, r_cnt_disp_rate'length)) then -- Limit reached so reset
        s_cnt_disp_rate <= (others => '0');
        s_disp_rate <= '1';
    else -- Counts
        s_cnt_disp_rate <= r_cnt_disp_rate + 1;
        s_disp_rate <= '0';
    end if;
  end process;

  -- Output process:
  o_disp_rate <= r_disp_rate; 
  
end arch_display_counter;