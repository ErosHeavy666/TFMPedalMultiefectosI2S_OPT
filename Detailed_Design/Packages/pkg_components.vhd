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
    generic (
        g_ms_ratio_w : natural := 3; -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
        g_sw_ratio_w : natural := 6; -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
        g_data_w     : natural := 16
    );
    port (
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
        r_out      : in std_logic_vector(g_data_w-1 downto 0);
        en_out     : out std_logic
    );
  end component;
    
  component display_interface is 
    Port ( 
      clk           : in std_logic;
      n_reset       : in std_logic;
      i_play_enable : in std_logic;
      o_seg         : out std_logic_vector(6 downto 0);
      o_an          : out std_logic_vector(7 downto 0)
    );
  end component;

    component Digital_Efects is
    GENERIC(
        d_width         :  INTEGER := 16);
    Port ( 
        clk                   : in STD_LOGIC;
        reset_n               : in STD_LOGIC;
        enable_in             : in STD_LOGIC; 
        enable_out            : out STD_LOGIC;
        BTNR                  : in STD_LOGIC;
        BTNC                  : in STD_LOGIC; 
        BTNL                  : in STD_LOGIC; 
        BTND                  : in STD_LOGIC; 
        SW0                   : in STD_LOGIC;
        SW1                   : in STD_LOGIC;
        SW2                   : in STD_LOGIC;
        SW3                   : in STD_LOGIC;
        SW4                   : in STD_LOGIC;
        SW5                   : in STD_LOGIC;
        SW6                   : in STD_LOGIC;
        SW7                   : in STD_LOGIC;
        SW8                   : in STD_LOGIC;
        SW9                   : in STD_LOGIC;
        SW10                  : in STD_LOGIC;
        SW11                  : in STD_LOGIC;
        SW12                  : in STD_LOGIC;
        SW13                  : in STD_LOGIC;
        SW14                  : in STD_LOGIC;
        l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
        l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
        r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
        r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
    );
    end component;
     
  component leds is
    generic(
      g_width       : integer := 16);  -- Data width
    port ( 
      clk           : in std_logic; -- MCLK
      n_reset       : in std_logic; -- Reset síncrono a nivel bajo del sistema global
      i_play_enable : in std_logic; -- Enable que activa el sistema 
      i_r_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal derecho de audio a la entrada
      i_l_data_rx   : in std_logic_vector(g_width-1 downto 0); -- Canal izquierdo de audio a la entrada
      o_leds        : out std_logic_vector(g_width-1 downto 0) -- Vector de 15 Leds 
    );
  end component;
    
end pkg_components;