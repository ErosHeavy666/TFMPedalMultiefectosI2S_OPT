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
package pkg_digital_effects is

  component efecto_es is
    generic(
      g_width : integer := 16 --Ancho del bus
    ); 
    port( 
      clk        : in std_logic;
      reset_n    : in std_logic; 
      enable_in  : in std_logic;
      l_data_in  : in std_logic_vector(g_width-1 downto 0);                        
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                          
      l_data_out : out std_logic_vector(g_width-1 downto 0);                           
      r_data_out : out std_logic_vector(g_width-1 downto 0) 
    );
  end component;

  component efecto_delay is
    generic(
      n       : integer := 4000;
      g_width : integer := 16);
    port( 
      clk        : in std_logic;   
      reset_n    : in std_logic;   
      enable_in  : in std_logic;   
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    ); 
  end component;

  component efecto_chorus is
    generic(
      n       : integer := 1000;
      g_width : integer := 16);
    port( 
      clk        : in std_logic;   
      reset_n    : in std_logic;   
      enable_in  : in std_logic;   
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    ); 
  end component;

  component efecto_vibrato is
    generic(
      n       : integer := 500;
      g_width : integer := 16 
    );
    port( 
      clk        : in std_logic;                                         
      reset_n    : in std_logic;
      enable_in  : in std_logic; 
      l_data_in  : in std_logic_vector(g_width-1 downto 0);                         
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                           
      l_data_out : out std_logic_vector(g_width-1 downto 0);                            
      r_data_out : out std_logic_vector(g_width-1 downto 0) 
  ); 
  end component;

  component efecto_reverb is
    generic(
      n       : integer := 500;
      g_width : integer := 16 
    );
    port( 
      clk        : in std_logic; 
      reset_n    : in std_logic; 
      enable_in  : in std_logic; 
      l_data_in  : in std_logic_vector(g_width-1 downto 0);                      
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                        
      l_data_out : out std_logic_vector(g_width-1 downto 0);                         
      r_data_out : out std_logic_vector(g_width-1 downto 0) 
    ); 
  end component;

  component efecto_eco is
    generic(
      n       : integer := 5000;
      g_width : integer := 16 
    );
    port( 
      clk        : in std_logic; 
      reset_n    : in std_logic; 
      enable_in  : in std_logic; 
      l_data_in  : in std_logic_vector(g_width-1 downto 0);                      
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                        
      l_data_out : out std_logic_vector(g_width-1 downto 0);                         
      r_data_out : out std_logic_vector(g_width-1 downto 0) 
    ); 
  end component;

  component efecto_compressor is
    generic(
      g_width : integer := 16 
      );
    port ( 
      clk        : in std_logic;   
      reset_n    : in std_logic;   
      enable_in  : in std_logic;   
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
  );
  end component;

  component efecto_overdrive is
    generic(
      g_width : integer := 16 
      );
    port ( 
      clk        : in std_logic;    
      reset_n    : in std_logic;    
      enable_in  : in std_logic;    
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    );
  end component;

  component efecto_looper is
    generic(
      g_width : integer := 16; --Ancho del bus  
      d_deep  : integer := 19); --Ancho de la memoria RAM
    port( 
      clk        : in std_logic; --MCLK                                            
      reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global 
      SW13       : in std_logic; --RSTA                
      enable_in  : in std_logic; --Enable proporcionado por el i2s2                
      SW5        : in std_logic; --Switches de control para el looper --> Write
      SW6        : in std_logic; --Switches de control para el looper --> Read                
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    );
  end component;

  component efecto_filter is
    generic(
      g_width    : integer := 12); 
    port ( 
      clk        : in std_logic; 
      reset_n    : in std_logic; 
      enable_in  : in std_logic; 
      SW14       : in std_logic; 
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    ); 
  end component;

  component efecto_config_reverb is
    generic(
      n1      : integer := 1500;
      g_width : integer := 16); 
    port( 
      clk        : in std_logic;
      reset_n    : in std_logic;
      enable_in  : in std_logic;
      BTNC       : in std_logic;
      BTNL       : in std_logic;
      BTND       : in std_logic;
      BTNR       : in std_logic;
      l_data_in  : in std_logic_vector(g_width-1 downto 0);                         
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                           
      l_data_out : out std_logic_vector(g_width-1 downto 0);                            
      r_data_out : out std_logic_vector(g_width-1 downto 0) 
    ); 
  end component;

    
end pkg_digital_effects;