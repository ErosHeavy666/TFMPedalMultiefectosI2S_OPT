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
    g_width       : integer := 10);  -- Data width
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
  s_r_LEDs <= "10110" when (i_play_enable = '0') else -- Stand-by 
              "00000" when (i_en_rx = '1' and signed(i_r_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "10000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "0000011111" and signed(i_r_data_rx) > "0000000000") else -- Positive
              "11000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "0000111111" and signed(i_r_data_rx) > "0000011111") else 
              "11100" when (i_en_rx = '1' and signed(i_r_data_rx) <= "0001111111" and signed(i_r_data_rx) > "0000111111") else
              "11110" when (i_en_rx = '1' and signed(i_r_data_rx) <= "0011111111" and signed(i_r_data_rx) > "0001111111") else
              "11111" when (i_en_rx = '1' and signed(i_r_data_rx) <= "0111111111" and signed(i_r_data_rx) > "0011111111") else
              ------------------------------------------------------
              "10000" when (i_en_rx = '1' and signed(i_r_data_rx) >= not("0000011111") and signed(i_r_data_rx) < not("0000000000")) else -- Negative
              "11000" when (i_en_rx = '1' and signed(i_r_data_rx) >= not("0000111111") and signed(i_r_data_rx) < not("0000011111")) else 
              "11100" when (i_en_rx = '1' and signed(i_r_data_rx) >= not("0001111111") and signed(i_r_data_rx) < not("0000111111")) else
              "11110" when (i_en_rx = '1' and signed(i_r_data_rx) >= not("0011111111") and signed(i_r_data_rx) < not("0001111111")) else
              "11111" when (i_en_rx = '1' and signed(i_r_data_rx) >= not("0111111111") and signed(i_r_data_rx) < not("0011111111")) else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "01101" when (i_play_enable = '0') else
              "00000" when (i_en_rx = '1' and signed(i_l_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "00001" when (i_en_rx = '1' and signed(i_l_data_rx) <= "0000011111" and signed(i_l_data_rx) > "0000000000") else -- Positive                                  
              "00011" when (i_en_rx = '1' and signed(i_l_data_rx) <= "0000111111" and signed(i_l_data_rx) > "0000011111") else 
              "00111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "0001111111" and signed(i_l_data_rx) > "0000111111") else 
              "01111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "0011111111" and signed(i_l_data_rx) > "0001111111") else 
              "11111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "0111111111" and signed(i_l_data_rx) > "0011111111") else 
              ------------------------------------------------------                            
              "00001" when (i_en_rx = '1' and signed(i_l_data_rx) >= not("0000011111") and signed(i_l_data_rx) < not("0000000000")) else                                       
              "00011" when (i_en_rx = '1' and signed(i_l_data_rx) >= not("0000111111") and signed(i_l_data_rx) < not("0000011111")) else                                     
              "00111" when (i_en_rx = '1' and signed(i_l_data_rx) >= not("0001111111") and signed(i_l_data_rx) < not("0000111111")) else                                     
              "01111" when (i_en_rx = '1' and signed(i_l_data_rx) >= not("0011111111") and signed(i_l_data_rx) < not("0001111111")) else                                     
              "11111" when (i_en_rx = '1' and signed(i_l_data_rx) >= not("0111111111") and signed(i_l_data_rx) < not("0011111111")) else r_l_LEDs; -- Keep the last value  
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;