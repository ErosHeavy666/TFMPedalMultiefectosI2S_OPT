----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_components.all;

------------
-- Entity --
------------
entity i2s_playback IS
  generic(
      g_width     :  integer := 12);                    
  port(
      CLK_100MHZ  : in std_logic;                     
      N_RESET     : in std_logic;                     
      PLAY_ENABLE : in std_logic;
      BTNR        : in std_logic;
      BTNC        : in std_logic; 
      BTNL        : in std_logic; 
      BTND        : in std_logic;     
      SW0         : in std_logic;
      SW1         : in std_logic;
      SW2         : in std_logic;
      SW3         : in std_logic;
      SW4         : in std_logic;
      SW5         : in std_logic;
      SW6         : in std_logic;
      SW7         : in std_logic;
      SW8         : in std_logic;
      SW9         : in std_logic;
      SW10        : in std_logic;
      SW11        : in std_logic;
      SW12        : in std_logic;
      SW13        : in std_logic;
      SW14        : in std_logic;                
      MCLK        : out std_logic_vector(1 downto 0);  --master clock
      SCLK        : out std_logic_vector(1 downto 0);  --serial clock (or bit clock)
      WS          : out std_logic_vector(1 downto 0);  --word select (or left-right clock)
      SD_IN       : in std_logic;                     --serial data in
      SD_OUT      : out std_logic;
      SEG         : out std_logic_vector(6 downto 0);
      AN          : out std_logic_vector(7 downto 0);
      LED         : out std_logic_vector(g_width-1 downto 0)
  );                  
end i2s_playback;

------------------
-- Architecture --
------------------
architecture arch_i2s_playback OF i2s_playback IS

  -- Signals
  signal master_clk  : std_logic; -- internal master clock signal
  signal serial_clk  : std_logic; -- internal serial clock signal
  signal word_select : std_logic; -- internal word select signal
  signal l_data_rx   : std_logic_vector(g_width-1 downto 0);  -- left channel data received from I2S Transceiver component
  signal r_data_rx   : std_logic_vector(g_width-1 downto 0);  -- right channel data received from I2S Transceiver component
  signal l_data_tx   : std_logic_vector(g_width-1 downto 0);  -- left channel data to transmit using I2S Transceiver component
  signal r_data_tx   : std_logic_vector(g_width-1 downto 0);  -- right channel data to transmit using I2S Transceiver component
  signal en_rx       : std_logic;    
  
  signal reset : std_logic;
  
begin
    
  -- Instance for PLL component
  unit_clk_wiz_1: clk_wiz_1 
    port map(
      clk_in1 => CLK_100MHZ, 
      clk_out1 => master_clk
  );
  
  -- Instance for I2S Transceiver component
  unit_i2s_transceiver: i2s_transceiver
    port map(
      clk       => master_clk,
      n_reset   => N_RESET, 
      i_reset_s => PLAY_ENABLE,
      sclk      => serial_clk, 
      ws        => word_select, 
      sd_in     => sd_in, 
      sd_out    => sd_out,
      l_in      => l_data_rx, 
      r_in      => r_data_rx, 
      en_in     => en_rx,
      l_out     => l_data_tx, 
      r_out     => r_data_tx
  );
  
  reset <= not N_RESET;
  
  unit_digital_efects : digital_efects
  generic map(g_width => 12)
  port map(
       clk        => master_clk, 
       reset_n    => reset,
       enable_in  => en_rx,
       BTNR       => BTNR,
       BTNC       => BTNC,
       BTNL       => BTNL,
       BTND       => BTND,
       SW0        => SW0,
       SW1        => SW1,
       SW2        => SW2,
       SW3        => SW3,
       SW4        => SW4,
       SW5        => SW5,
       SW6        => SW6,
       SW7        => SW7,
       SW8        => SW8,
       SW9        => SW9,
       SW10       => SW10,
       SW11       => SW11,
       SW12       => SW12,
       SW13       => SW13,
       SW14       => SW14,
       l_data_in  => l_data_rx, 
       r_data_in  => r_data_rx, 
       l_data_out => l_data_tx, 
       r_data_out => r_data_tx
  ); 

  -- Instance for display interface component
  unit_display_interface : display_interface 
    port map(
      clk           => master_clk,
      n_reset       => n_reset,
      i_play_enable => PLAY_ENABLE,
      o_seg         => SEG,
      o_an          => AN
  );
  
  -- Instance for LEDs component
  unit_leds : leds  
    generic map(g_width => 12)
    port map(
      clk           => master_clk,
      n_reset       => n_reset,
      i_play_enable => PLAY_ENABLE,
      i_en_rx       => en_rx,
      i_r_data_rx   => r_data_rx,
      i_l_data_rx   => l_data_rx,
      o_leds        => LED
  );
 
  -- Output process:
  MCLK(0) <= master_clk;  --output master clock to ADC
  MCLK(1) <= master_clk;  --output master clock to DAC
  SCLK(0) <= serial_clk;  --output serial clock (from I2S Transceiver) to ADC
  SCLK(1) <= serial_clk;  --output serial clock (from I2S Transceiver) to DAC
  WS(0) <= word_select;   --output word select (from I2S Transceiver) to ADC
  WS(1) <= word_select;   --output word select (from I2S Transceiver) to DAC
                    
end arch_i2s_playback;
