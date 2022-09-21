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
    g_width       : integer := 16);  -- Data width
  port ( 
    clk           : in std_logic; -- MCLK
    n_reset       : in std_logic; -- Reset síncrono a nivel bajo del sistema global
    i_play_enable : in std_logic; -- Enable que activa el sistema 
    i_en_rx       : in std_logic; 
    i_r_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal derecho de audio a la entrada
    i_l_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal izquierdo de audio a la entrada
    o_leds        : out std_logic_vector(g_width-1 downto 0) -- Vector de 15 Leds 
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
  s_r_LEDs <= "01011001" when (i_play_enable = '0') else -- Stand-by 
              "00000000" when (i_en_rx = '1' and signed(i_r_data_rx)  = x"0000") else -- No signal
              ------------------------------------------------------
              "10000000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"0FFF" and signed(i_r_data_rx) > x"0000") else -- Positive
              "11000000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"1FFF" and signed(i_r_data_rx) > x"0FFF") else 
              "11100000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"2FFF" and signed(i_r_data_rx) > x"1FFF") else
              "11110000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"3FFF" and signed(i_r_data_rx) > x"2FFF") else
              "11111000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"4FFF" and signed(i_r_data_rx) > x"3FFF") else
              "11111100" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"5FFF" and signed(i_r_data_rx) > x"4FFF") else
              "11111110" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"6FFF" and signed(i_r_data_rx) > x"5FFF") else
              "11111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"7FFF" and signed(i_r_data_rx) > x"6FFF") else
              ------------------------------------------------------
              "10000000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"F000" and signed(i_r_data_rx) < x"0000") else -- Negative
              "11000000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"E000" and signed(i_r_data_rx) < x"F000") else 
              "11100000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"D000" and signed(i_r_data_rx) < x"E000") else
              "11110000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"C000" and signed(i_r_data_rx) < x"D000") else
              "11111000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"B000" and signed(i_r_data_rx) < x"C000") else
              "11111100" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"A000" and signed(i_r_data_rx) < x"B000") else
              "11111110" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"9000" and signed(i_r_data_rx) < x"A000") else
              "11111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"8000" and signed(i_r_data_rx) < x"9000") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "10011010" when (i_play_enable = '0') else
              "00000000" when (i_en_rx = '1' and signed(i_l_data_rx)  = x"0000") else -- No signal
              ------------------------------------------------------
              "00000001" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"0FFF" and signed(i_l_data_rx) > x"0000") else -- Positive                                  
              "00000011" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"1FFF" and signed(i_l_data_rx) > x"0FFF") else 
              "00000111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"2FFF" and signed(i_l_data_rx) > x"1FFF") else 
              "00001111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"3FFF" and signed(i_l_data_rx) > x"2FFF") else 
              "00011111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"4FFF" and signed(i_l_data_rx) > x"3FFF") else 
              "00111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"5FFF" and signed(i_l_data_rx) > x"4FFF") else 
              "01111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"6FFF" and signed(i_l_data_rx) > x"5FFF") else 
              "11111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"7FFF" and signed(i_l_data_rx) > x"6FFF") else 
              ------------------------------------------------------                            
              "00000001" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"F000" and signed(i_l_data_rx) < x"0000") else                                       
              "00000011" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"E000" and signed(i_l_data_rx) < x"F000") else                                     
              "00000111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"D000" and signed(i_l_data_rx) < x"E000") else                                     
              "00001111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"C000" and signed(i_l_data_rx) < x"D000") else                                     
              "00011111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"B000" and signed(i_l_data_rx) < x"C000") else                                     
              "00111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"A000" and signed(i_l_data_rx) < x"B000") else                                     
              "01111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"9000" and signed(i_l_data_rx) < x"A000") else                                     
              "11111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"8000" and signed(i_l_data_rx) < x"9000") else r_l_LEDs; -- Keep the last value    
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;