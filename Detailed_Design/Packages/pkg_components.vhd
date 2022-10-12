----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;

-------------
-- Package --
-------------
package pkg_components is

  component clk_wiz_1
    port(
      clk_in1  : in std_logic;
      clk_out1 : out std_logic
    );
  end component;

  component i2s_transceiver is
    generic(
        g_ms_ratio_w : natural := 3; -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
        g_sw_ratio_w : natural := 6; -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
        g_data_w     : natural := 12
    );
    port(
        clk        : in std_logic;
        n_reset    : in std_logic;
        i_reset_s  : in std_logic;
        sclk       : out std_logic;
        ws         : out std_logic;
        sd_in      : in std_logic;
        sd_out     : out std_logic;
        l_in       : out std_logic_vector(g_data_w-1 downto 0);
        r_in       : out std_logic_vector(g_data_w-1 downto 0);
        en_in      : out std_logic;
        l_out      : in std_logic_vector(g_data_w-1 downto 0);
        r_out      : in std_logic_vector(g_data_w-1 downto 0)
    );
  end component;
    
  component display_interface is 
    port( 
      clk           : in std_logic;
      n_reset       : in std_logic;
      i_play_enable : in std_logic;
      o_seg         : out std_logic_vector(6 downto 0);
      o_an          : out std_logic_vector(7 downto 0)
    );
  end component;

  component digital_efects is
    generic(
      g_width    : integer := 12);
    port( 
      clk        : in std_logic;
      reset_n    : in std_logic;
      enable_in  : in std_logic; 
      BTNR       : in std_logic;
      BTNC       : in std_logic; 
      BTNL       : in std_logic; 
      BTND       : in std_logic; 
      SW0        : in std_logic;
      SW1        : in std_logic;
      SW2        : in std_logic;
      SW3        : in std_logic;
      SW4        : in std_logic;
      SW5        : in std_logic;
      SW6        : in std_logic;
      SW7        : in std_logic;
      SW8        : in std_logic;
      SW9        : in std_logic;
      SW10       : in std_logic;
      SW11       : in std_logic;
      SW12       : in std_logic;
      SW13       : in std_logic;
      SW14       : in std_logic;
      l_data_in  : in std_logic_vector(g_width-1 downto 0);     
      r_data_in  : in std_logic_vector(g_width-1 downto 0); 
      l_data_out : out std_logic_vector(g_width-1 downto 0);
      r_data_out : out std_logic_vector(g_width-1 downto 0)  
    );
  end component;
  
  component leds is
    generic(
      g_width       : integer := 12);  
    port ( 
      clk           : in std_logic; 
      n_reset       : in std_logic; 
      i_play_enable : in std_logic; 
      i_en_rx       : in std_logic;  
      i_r_data_rx   : in std_logic_vector(g_width-1 downto 0); 
      i_l_data_rx   : in std_logic_vector(g_width-1 downto 0); 
      o_leds        : out std_logic_vector(g_width-1 downto 0) 
    );
  end component;
    
end pkg_components;