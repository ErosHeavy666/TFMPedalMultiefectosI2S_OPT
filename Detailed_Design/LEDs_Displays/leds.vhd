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
    i_r_data_rx   : in std_logic_vector (g_width-1 downto 0); -- Canal derecho de audio a la entrada
    i_l_data_rx   : in std_logic_vector (g_width-1 downto 0); -- Canal izquierdo de audio a la entrada
    o_leds        : out std_logic_vector (g_width-1 downto 0) -- Vector de 15 Leds 
  );
end leds;

------------------
-- Architecture --
------------------
architecture arch_leds of leds is

  -- Signals
  signal r_r_LEDs, s_r_LEDs : std_logic_vector (g_width/2-1 downto 0);
  signal r_l_LEDs, s_l_LEDs : std_logic_vector (g_width/2-1 downto 0);

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
              ------------------------------------------------------
              "10000000" when (i_play_enable = '1' and signed(i_r_data_rx) = "000000000000001") else -- Positive
              "11000000" when (i_play_enable = '1' and signed(i_r_data_rx) = "000000000000011") else 
              "11100000" when (i_play_enable = '1' and signed(i_r_data_rx) = "000000000001111") else
              "11110000" when (i_play_enable = '1' and signed(i_r_data_rx) = "000000000111111") else
              "11111000" when (i_play_enable = '1' and signed(i_r_data_rx) = "000000011111111") else
              "11111100" when (i_play_enable = '1' and signed(i_r_data_rx) = "000001111111111") else
              "11111110" when (i_play_enable = '1' and signed(i_r_data_rx) = "000111111111111") else
              "11111111" when (i_play_enable = '1' and signed(i_r_data_rx) = "011111111111111") else
              ------------------------------------------------------
              "10000000" when (i_play_enable = '1' and signed(i_r_data_rx) = "111111111111111") else -- Negative
              "11000000" when (i_play_enable = '1' and signed(i_r_data_rx) = "111111111111100") else 
              "11100000" when (i_play_enable = '1' and signed(i_r_data_rx) = "111111111110000") else
              "11110000" when (i_play_enable = '1' and signed(i_r_data_rx) = "111111111000000") else
              "11111000" when (i_play_enable = '1' and signed(i_r_data_rx) = "111111100000000") else
              "11111100" when (i_play_enable = '1' and signed(i_r_data_rx) = "111110000000000") else
              "11111110" when (i_play_enable = '1' and signed(i_r_data_rx) = "111000000000000") else
              "11111111" when (i_play_enable = '1' and signed(i_r_data_rx) = "100000000000000") else r_r_LEDs; -- Keep the last value
              ------------------------------------------------------
              ------------------------------------------------------ 
  s_l_LEDs <= "10011010" when (i_play_enable = '0') else
              ------------------------------------------------------
              "00000001" when (i_play_enable = '1' and signed(i_l_data_rx) = "000000000000001") else -- Positive
              "00000011" when (i_play_enable = '1' and signed(i_l_data_rx) = "000000000000011") else 
              "00000111" when (i_play_enable = '1' and signed(i_l_data_rx) = "000000000001111") else
              "00001111" when (i_play_enable = '1' and signed(i_l_data_rx) = "000000000111111") else
              "00011111" when (i_play_enable = '1' and signed(i_l_data_rx) = "000000011111111") else
              "00111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "000001111111111") else
              "01111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "000111111111111") else
              "11111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "011111111111111") else
              ------------------------------------------------------
              "00000001" when (i_play_enable = '1' and signed(i_l_data_rx) = "111111111111111") else -- Negative
              "00000011" when (i_play_enable = '1' and signed(i_l_data_rx) = "111111111111100") else 
              "00000111" when (i_play_enable = '1' and signed(i_l_data_rx) = "111111111110000") else
              "00001111" when (i_play_enable = '1' and signed(i_l_data_rx) = "111111111000000") else
              "00011111" when (i_play_enable = '1' and signed(i_l_data_rx) = "111111100000000") else
              "00111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "111110000000000") else
              "01111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "111000000000000") else
              "11111111" when (i_play_enable = '1' and signed(i_l_data_rx) = "100000000000000") else r_l_LEDs; -- Keep the last value
              ------------------------------------------------------

  -- Output process:
  o_leds <= (r_l_LEDs & r_r_LEDs); 
  
end arch_leds;