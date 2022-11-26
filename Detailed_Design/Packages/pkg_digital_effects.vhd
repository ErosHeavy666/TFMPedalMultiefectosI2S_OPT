----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use work.pkg_sine.sine_vector_width;

-------------
-- Package --
-------------
package pkg_digital_effects is

  component Selector_Module is
    generic(
      g_total_number_switches : integer := 10;
      g_total_delays_effects  : integer := 5; --Número total de las lineas de retardo que se desea
      g_total_normal_effects  : integer := 6  --Número total de los efectos que no son de delay
    );
    port ( 
      clk          : in std_logic; --MCLK                                                
      reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global    
      enable_in    : in std_logic; --Enable proporcionado por el i2s2             
      SW0          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW1          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW2          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW3          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW4          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW5          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW6          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW7          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW8          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      SW9          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
      GNL_selector : out std_logic_vector(g_total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
      Out_selector : out std_logic_vector(g_total_normal_effects-1 downto 0) -- Out Selector
  );
  end component;

  component Sine_Generator is
    port ( 
      clk          : in std_logic; --MCLK                                            
      reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global 
      enable_in    : in std_logic; --Enable proporcionado por el i2s2
      Sin_In       : out std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable         
      Sin_Out      : out std_logic_vector(sine_vector_width-1 downto 0) --Señal senoidal para seleccionar el retardo modulable         
  ); 
  end component;

  component In_Module is
    generic(
      n                       : integer := 5000; --Línea de retardo
      g_total_delays_effects  : integer := 5; --Número total de las lineas de retardo que se desea  
      g_width                 : integer := 16 --Ancho del bus 
    );
    port ( 
      clk          : in std_logic; --MCLK                                            
      reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global 
      enable_in    : in std_logic; --Enable proporcionado por el i2s2
      Sin_In       : in std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable    
      GNL_selector : in std_logic_vector(g_total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
      l_data_in    : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos;                        
      r_data_in    : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos;                            
      l_data_in_0  : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
      r_data_in_0  : out std_logic_vector(g_width-1 downto 0);  -- Datos de salida derechos sin retardo;                         
      l_data_in_n  : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos con retardo;                            
      r_data_in_n  : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida derechos con retardo;      
  ); 
  end component;

  component Output_Generator_Module is
    generic(
      g_width                 : integer := 16; --Ancho del bus 
      g_total_delays_effects  : integer := 5;  --Número total de las lineas de retardo que se desea
      g_total_normal_effects  : integer := 6   --Número total de los efectos que no son de delay
    );
    port ( 
      clk              : in std_logic; --MCLK                                                
      reset_n          : in std_logic; --Reset síncrono a nivel alto del sistema global    
      enable_in        : in std_logic; --Enable proporcionado por el i2s2     
      SW5              : in std_logic; -- Looper Write
      SW6              : in std_logic; -- Looper Read          
      SW13             : in std_logic; -- RSTA
      SW14             : in std_logic; -- Filter Selector
      GNL_selector     : in std_logic_vector(g_total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
      Out_selector     : in std_logic_vector(g_total_normal_effects-1 downto 0); -- Out Selector
      l_data_in_0      : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos sin retardo                            
      r_data_in_0      : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos sin retardo                        
      l_data_in_n      : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos con retardo                            
      r_data_in_n      : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos con retardo     
      l_data_out_n     : in std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos con retardo                            
      r_data_out_n     : in std_logic_vector(g_width-1 downto 0); -- Datos de salida derechos con retardo      
      l_data_out_logic : out std_logic_vector(g_width-1 downto 0); -- Datos de salida sin retardo izquierdos                        
      r_data_out_logic : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida sin retardo derechos    
  );
  end component;

  component Out_Module is
    generic(
      n                       : integer := 5000; --Línea de retardo
      g_total_delays_effects  : integer := 5; --Número total de las lineas de retardo que se desea  
      g_width                 : integer := 16 --Ancho del bus 
    );
    port ( 
      clk              : in std_logic; --MCLK                                            
      reset_n          : in std_logic; --Reset síncrono a nivel alto del sistema global 
      enable_in        : in std_logic; --Enable proporcionado por el i2s2
      Sin_Out          : in std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable    
      GNL_selector     : in std_logic_vector(g_total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
      l_data_out_logic : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos;                        
      r_data_out_logic : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos;                            
      l_data_out_0     : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
      r_data_out_0     : out std_logic_vector(g_width-1 downto 0);  -- Datos de salida derechos sin retardo;                         
      l_data_out_n     : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos con retardo;                            
      r_data_out_n     : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida derechos con retardo;      
  ); 
  end component;
    
end pkg_digital_effects;