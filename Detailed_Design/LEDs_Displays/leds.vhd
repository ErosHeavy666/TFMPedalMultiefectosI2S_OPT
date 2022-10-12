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
entity leds is
  generic(
    g_width       : integer := 12);  -- Data width
  port ( 
    clk           : in std_logic; -- MCLK
    n_reset       : in std_logic; -- Reset síncrono a nivel bajo del sistema global
    i_play_enable : in std_logic; -- Enable que activa el sistema 
    i_en_rx       : in std_logic; 
    i_r_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal derecho de audio a la entrada
    i_l_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal izquierdo de audio a la entrada
    o_leds        : out std_logic_vector(g_width-1 downto 0) -- Vector de 16 Leds 
  );
end leds;

------------------
-- Architecture --
------------------
architecture arch_leds of leds is

  -- Signals
  signal r_r_LEDs, s_r_LEDs : std_logic_vector(g_width/2-1 downto 0);
  signal r_l_LEDs, s_l_LEDs : std_logic_vector(g_width/2-1 downto 0);
    
begin
      
  -- Register process:
  r_leds_process : process(clk) --Proceso sensible al reloj de MCLK
  begin
    if (rising_edge(clk)) then
      if(n_reset = '0') then
        r_r_LEDs <= (others => '0');
        r_l_LEDs <= (others => '0');
      else
        r_r_LEDs <= s_r_LEDs;
        r_l_LEDs <= s_l_LEDs;
      end if;
    end if;
  end process;
  
  -- Combinational logic process:
              ------------------------------------------------------ 
  s_r_LEDs <= "010110" when (i_play_enable = '0') else -- Stand-by 
              "000000" when (i_en_rx = '1' and signed(i_r_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "100000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"0FF" and signed(i_r_data_rx) > x"000") else -- Positive
              "110000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"1FF" and signed(i_r_data_rx) > x"0FF") else 
              "111000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"2FF" and signed(i_r_data_rx) > x"1FF") else
              "111100" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"3FF" and signed(i_r_data_rx) > x"2FF") else
              "111110" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"4FF" and signed(i_r_data_rx) > x"3FF") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"5FF" and signed(i_r_data_rx) > x"4FF") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"6FF" and signed(i_r_data_rx) > x"5FF") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"7FF" and signed(i_r_data_rx) > x"6FF") else
              ------------------------------------------------------
              "100000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"F00" and signed(i_r_data_rx) < x"000") else -- Negative
              "110000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"E00" and signed(i_r_data_rx) < x"F00") else 
              "111000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"D00" and signed(i_r_data_rx) < x"E00") else
              "111100" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"C00" and signed(i_r_data_rx) < x"D00") else
              "111110" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"B00" and signed(i_r_data_rx) < x"C00") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"A00" and signed(i_r_data_rx) < x"B00") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"900" and signed(i_r_data_rx) < x"A00") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"800" and signed(i_r_data_rx) < x"900") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "100110" when (i_play_enable = '0') else
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"0FF" and signed(i_l_data_rx) > x"000") else -- Positive                                  
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"1FF" and signed(i_l_data_rx) > x"0FF") else 
              "000001" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"2FF" and signed(i_l_data_rx) > x"1FF") else 
              "000011" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"3FF" and signed(i_l_data_rx) > x"2FF") else 
              "000111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"4FF" and signed(i_l_data_rx) > x"3FF") else 
              "001111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"5FF" and signed(i_l_data_rx) > x"4FF") else 
              "011111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"6FF" and signed(i_l_data_rx) > x"5FF") else 
              "111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"7FF" and signed(i_l_data_rx) > x"6FF") else 
              ------------------------------------------------------                            
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"F00" and signed(i_l_data_rx) < x"000") else                                       
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"E00" and signed(i_l_data_rx) < x"F00") else                                     
              "000001" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"D00" and signed(i_l_data_rx) < x"E00") else                                     
              "000011" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"C00" and signed(i_l_data_rx) < x"D00") else                                     
              "000111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"B00" and signed(i_l_data_rx) < x"C00") else                                     
              "001111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"A00" and signed(i_l_data_rx) < x"B00") else                                     
              "011111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"900" and signed(i_l_data_rx) < x"A00") else                                     
              "111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"800" and signed(i_l_data_rx) < x"900") else r_l_LEDs; -- Keep the last value    
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;