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
    g_width       : integer := 14);  -- Data width
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
  s_r_LEDs <= "1011001" when (i_play_enable = '0') else -- Stand-by 
              "0000000" when (i_en_rx = '1' and signed(i_r_data_rx)  = "00" & x"000") else -- No signal
              ------------------------------------------------------
              "1000000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "00" & x"492" and signed(i_r_data_rx) > "00" & x"000") else -- Positive
              "1100000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "00" & x"924" and signed(i_r_data_rx) > "00" & x"492") else 
              "1110000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "00" & x"DB6" and signed(i_r_data_rx) > "00" & x"924") else
              "1111000" when (i_en_rx = '1' and signed(i_r_data_rx) <= "01" & x"248" and signed(i_r_data_rx) > "00" & x"DB6") else
              "1111100" when (i_en_rx = '1' and signed(i_r_data_rx) <= "01" & x"6DA" and signed(i_r_data_rx) > "01" & x"248") else
              "1111110" when (i_en_rx = '1' and signed(i_r_data_rx) <= "01" & x"B6C" and signed(i_r_data_rx) > "01" & x"6DA") else
              "1111111" when (i_en_rx = '1' and signed(i_r_data_rx) <= "01" & x"FFF" and signed(i_r_data_rx) > "01" & x"B6C") else
              ------------------------------------------------------
              "1000000" when (i_en_rx = '1' and signed(i_r_data_rx) >= "11" & x"B6E" and signed(i_r_data_rx) < "11" & x"000") else -- Negative
              "1100000" when (i_en_rx = '1' and signed(i_r_data_rx) >= "11" & x"6DC" and signed(i_r_data_rx) < "11" & x"B6E") else 
              "1110000" when (i_en_rx = '1' and signed(i_r_data_rx) >= "11" & x"24A" and signed(i_r_data_rx) < "11" & x"6DC") else
              "1111000" when (i_en_rx = '1' and signed(i_r_data_rx) >= "10" & x"DB8" and signed(i_r_data_rx) < "11" & x"24A") else
              "1111100" when (i_en_rx = '1' and signed(i_r_data_rx) >= "10" & x"926" and signed(i_r_data_rx) < "10" & x"DB8") else
              "1111110" when (i_en_rx = '1' and signed(i_r_data_rx) >= "10" & x"494" and signed(i_r_data_rx) < "10" & x"926") else
              "1111111" when (i_en_rx = '1' and signed(i_r_data_rx) >= "10" & x"000" and signed(i_r_data_rx) < "10" & x"494") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "1001101" when (i_play_enable = '0') else
              "0000000" when (i_en_rx = '1' and signed(i_l_data_rx)  = "00" & x"000") else -- No signal
              ------------------------------------------------------
              "0000001" when (i_en_rx = '1' and signed(i_l_data_rx) <= "00" & x"492" and signed(i_l_data_rx) > "00" & x"000") else -- Positive                                  
              "0000011" when (i_en_rx = '1' and signed(i_l_data_rx) <= "00" & x"924" and signed(i_l_data_rx) > "00" & x"492") else 
              "0000111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "00" & x"DB6" and signed(i_l_data_rx) > "00" & x"924") else 
              "0001111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "01" & x"248" and signed(i_l_data_rx) > "00" & x"DB6") else 
              "0011111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "01" & x"6DA" and signed(i_l_data_rx) > "01" & x"248") else 
              "0111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "01" & x"B6C" and signed(i_l_data_rx) > "01" & x"6DA") else 
              "1111111" when (i_en_rx = '1' and signed(i_l_data_rx) <= "01" & x"FFF" and signed(i_l_data_rx) > "01" & x"B6C") else 
              ------------------------------------------------------                            
              "0000001" when (i_en_rx = '1' and signed(i_l_data_rx) >= "11" & x"B6E" and signed(i_l_data_rx) < "11" & x"000") else                                       
              "0000011" when (i_en_rx = '1' and signed(i_l_data_rx) >= "11" & x"6DC" and signed(i_l_data_rx) < "11" & x"B6E") else                                     
              "0000111" when (i_en_rx = '1' and signed(i_l_data_rx) >= "11" & x"24A" and signed(i_l_data_rx) < "11" & x"6DC") else                                     
              "0001111" when (i_en_rx = '1' and signed(i_l_data_rx) >= "10" & x"DB8" and signed(i_l_data_rx) < "11" & x"24A") else                                     
              "0011111" when (i_en_rx = '1' and signed(i_l_data_rx) >= "10" & x"926" and signed(i_l_data_rx) < "10" & x"DB8") else                                     
              "0111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= "10" & x"494" and signed(i_l_data_rx) < "10" & x"926") else                                     
              "1111111" when (i_en_rx = '1' and signed(i_l_data_rx) >= "10" & x"000" and signed(i_l_data_rx) < "10" & x"494") else r_l_LEDs; -- Keep the last value  
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;