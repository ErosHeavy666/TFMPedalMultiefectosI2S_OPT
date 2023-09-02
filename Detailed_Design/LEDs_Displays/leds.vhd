----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity leds is
  port ( 
    clk           : in std_logic; -- MCLK
    n_reset       : in std_logic; -- Reset síncrono a nivel bajo del sistema global
    i_play_enable : in std_logic; -- Enable que activa el sistema 
    i_en_rx       : in std_logic; 
    i_r_data_rx   : in std_logic_vector(width-1 downto 0); -- Canal derecho de audio a la entrada
    i_l_data_rx   : in std_logic_vector(width-1 downto 0); -- Canal izquierdo de audio a la entrada
    o_leds        : out std_logic_vector(width-1 downto 0) -- Vector de 16 Leds 
  );
end leds;

------------------
-- Architecture --
------------------
architecture arch_leds of leds is

  -- Signals
  signal r_r_LEDs, s_r_LEDs : std_logic_vector(width/2-1 downto 0);
  signal r_l_LEDs, s_l_LEDs : std_logic_vector(width/2-1 downto 0);
    
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
  s_r_LEDs <= "101100" when (i_play_enable = '0') else -- Stand-by 
              "000000" when (i_en_rx = '1' and signed(i_r_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "100000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"156" and signed(i_r_data_rx) > x"000") else -- Positive
              "110000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"2AC" and signed(i_r_data_rx) > x"156") else 
              "111000" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"402" and signed(i_r_data_rx) > x"2AC") else
              "111100" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"558" and signed(i_r_data_rx) > x"402") else
              "111110" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"6AE" and signed(i_r_data_rx) > x"558") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= x"7FF" and signed(i_r_data_rx) > x"6AE") else
              ------------------------------------------------------
              "100000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"EAA" and signed(i_r_data_rx) < x"000") else -- Negative
              "110000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"D54" and signed(i_r_data_rx) < x"EAA") else 
              "111000" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"BFE" and signed(i_r_data_rx) < x"D54") else
              "111100" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"AA8" and signed(i_r_data_rx) < x"BFE") else
              "111110" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"952" and signed(i_r_data_rx) < x"AA8") else
              "111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= x"800" and signed(i_r_data_rx) < x"952") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "001101" when (i_play_enable = '0') else
              "000000" when (i_en_rx = '1' and signed(i_l_data_rx)  = x"000") else -- No signal
              ------------------------------------------------------
              "000001" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"156" and signed(i_l_data_rx) > x"000") else -- Positive                                  
              "000011" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"2AC" and signed(i_l_data_rx) > x"156") else 
              "000111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"402" and signed(i_l_data_rx) > x"2AC") else 
              "001111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"558" and signed(i_l_data_rx) > x"402") else 
              "011111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"6AE" and signed(i_l_data_rx) > x"558") else 
              "111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= x"7FF" and signed(i_l_data_rx) > x"6AE") else 
              ------------------------------------------------------                            
              "000001" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"EAA" and signed(i_l_data_rx) < x"000") else                                       
              "000011" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"D54" and signed(i_l_data_rx) < x"EAA") else                                     
              "000111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"BFE" and signed(i_l_data_rx) < x"D54") else                                     
              "001111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"AA8" and signed(i_l_data_rx) < x"BFE") else                                     
              "011111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"952" and signed(i_l_data_rx) < x"AA8") else                                     
              "111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= x"800" and signed(i_l_data_rx) < x"952") else r_l_LEDs; -- Keep the last value   
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;