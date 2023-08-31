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
      g_width : integer := 10 --Ancho del bus
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
      g_width : integer := 10);
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
      g_width : integer := 10);
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
      g_width : integer := 10 
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
      g_width : integer := 10 
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
      g_width : integer := 10 
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
      g_width : integer := 10 
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
      g_width : integer := 10 
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
      g_width : integer := 10;   
      d_deep  : integer := 19); 
    port( 
      clk        : in std_logic;                                        
      reset_n    : in std_logic; 
      SW13       : in std_logic; 
      enable_in  : in std_logic;     
      SW5        : in std_logic; 
      SW6        : in std_logic;                
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    );
  end component;

  component efecto_filter is
    generic(
      g_width    : integer := 10); 
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
      g_width : integer := 10); 
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