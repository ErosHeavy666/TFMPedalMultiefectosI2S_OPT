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
    g_width       : integer := 8);  -- Data width
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
  s_r_LEDs <= "1011" when (i_play_enable = '0') else -- Stand-by 
              "0000" when (i_en_rx = '1' and signed(i_r_data_rx)  = x"00") else -- No signal
              ------------------------------------------------------
              "1000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"15" and signed(i_r_data_rx) > x"00") else -- Positive
              "1100" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"2A" and signed(i_r_data_rx) > x"15") else 
              "1110" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"40" and signed(i_r_data_rx) > x"2A") else
              "1111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"7F" and signed(i_r_data_rx) > x"40") else
              ------------------------------------------------------
              "1000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"EA" and signed(i_r_data_rx) < x"00") else -- Negative
              "1100" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"D5" and signed(i_r_data_rx) < x"EA") else 
              "1110" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"BF" and signed(i_r_data_rx) < x"D5") else
              "1111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"80" and signed(i_r_data_rx) < x"BF") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "0011" when (i_play_enable = '0') else
              "0000" when (i_en_rx = '1' and signed(i_l_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "0001" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"15" and signed(i_l_data_rx) > x"00") else -- Positive                                  
              "0011" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"2A" and signed(i_l_data_rx) > x"15") else 
              "0111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"40" and signed(i_l_data_rx) > x"2A") else 
              "1111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"7F" and signed(i_l_data_rx) > x"40") else 
              ------------------------------------------------------                            
              "0001" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"EA" and signed(i_l_data_rx) < x"00") else                                       
              "0011" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"D5" and signed(i_l_data_rx) < x"EA") else                                     
              "0111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"BF" and signed(i_l_data_rx) < x"D5") else                                      
              "1111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"80" and signed(i_l_data_rx) < x"BF") else r_l_LEDs; -- Keep the last value  
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;