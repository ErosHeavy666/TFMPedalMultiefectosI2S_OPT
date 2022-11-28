----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_digital_effects.all;
use work.pkg_sine.sine_vector_width;
use work.pkg_project.all;

------------
-- Entity --
------------
entity digital_effects is
  generic(
    n                       : integer := 5000; --Línea de retardo
    g_width                 : integer := 16;   --Ancho del bus 
    g_total_number_switches : integer := 10;
    g_total_delays_effects  : integer := 5;    --Número total de las lineas de retardo que se desea
    g_total_normal_effects  : integer := 6);   --Número total de los efectos que no son de delay
  port( 
    clk          : in std_logic; -- MCLK                                                
    reset_n      : in std_logic; -- Reset síncrono a nivel alto del sistema global    
    enable_in    : in std_logic; -- Enable proporcionado por el i2s2         
    SW0          : in std_logic; -- Delay
    SW1          : in std_logic; -- Chorus
    SW2          : in std_logic; -- Reverb
    SW3          : in std_logic; -- Vibrato
    SW4          : in std_logic; -- Eco
    SW5          : in std_logic; -- Looper Write
    SW6          : in std_logic; -- Looper Read
    SW7          : in std_logic; -- Compressor
    SW8          : in std_logic; -- Overdrive
    SW9          : in std_logic; -- Filter
    SW13         : in std_logic; -- RSTA
    SW14         : in std_logic; -- Filter Selector
    l_data_in    : in std_logic_vector(g_width-1 downto 0);                     
    r_data_in    : in std_logic_vector(g_width-1 downto 0);   
    l_data_out   : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
    r_data_out   : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida derechos sin retardo;        
  );
end digital_effects;

------------------
-- Architecture --
------------------
architecture arch_digital_effects of digital_effects is
  
  -- Signals for interconnect the instances
  signal GNL_selector_connection : std_logic_vector(g_total_delays_effects-1 downto 0);
  signal Out_selector_connection : std_logic_vector(g_total_normal_effects-1 downto 0);
  signal Sin_In_connection : std_logic_vector(sine_vector_width-1 downto 0);
  signal Sin_Out_connection : std_logic_vector(sine_vector_width-1 downto 0);
  signal l_data_in_0_connection : std_logic_vector(g_width-1 downto 0);
  signal r_data_in_0_connection : std_logic_vector(g_width-1 downto 0);
  signal l_data_in_n_connection : std_logic_vector(g_width-1 downto 0);
  signal r_data_in_n_connection : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_n_connection : std_logic_vector(g_width-1 downto 0);
  signal r_data_out_n_connection : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_logic_connection : std_logic_vector(g_width-1 downto 0);
  signal r_data_out_logic_connection : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_0_connection : std_logic_vector(g_width-1 downto 0);
  signal r_data_out_0_connection : std_logic_vector(g_width-1 downto 0);

begin
  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Selector_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Selector_Module : Selector_Module 
    generic map (
      g_total_number_switches => g_total_number_switches,
      g_total_delays_effects  => g_total_delays_effects,
      g_total_normal_effects  => g_total_normal_effects
    )
    port map( 
      clk          => clk,
      reset_n      => reset_n,
      enable_in    => enable_in,
      SW0          => SW0,
      SW1          => SW1,
      SW2          => SW2,
      SW3          => SW3,
      SW4          => SW4,
      SW5          => SW5,
      SW6          => SW6,
      SW7          => SW7,
      SW8          => SW8,
      SW9          => SW9,
      GNL_selector => GNL_selector_connection,
      Out_selector => Out_selector_connection
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Sine_Generator
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Sine_Generator : Sine_Generator 
    port map( 
      clk          => clk,
      reset_n      => reset_n,
      enable_in    => enable_in,
      Sin_In       => Sin_In_connection,     
      Sin_Out      => Sin_Out_connection    
  ); 
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: In_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_In_Module : In_Module 
    generic map(
      n                       => n,
      g_total_delays_effects  => g_total_delays_effects, 
      g_width                 => g_width
    )
    port map( 
      clk          => clk,
      reset_n      => reset_n,
      enable_in    => enable_in,
      Sin_In       => Sin_In_connection,
      GNL_selector => GNL_selector_connection,
      l_data_in    => l_data_in,
      r_data_in    => r_data_in,
      l_data_in_0  => l_data_in_0_connection,   
      r_data_in_0  => r_data_in_0_connection,
      l_data_in_n  => l_data_in_n_connection,   
      r_data_in_n  => r_data_in_n_connection
  );   
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Output_Generator_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Output_Generator_Module : Output_Generator_Module 
    generic map(
      g_width                 => g_width,
      g_total_delays_effects  => g_total_delays_effects,
      g_total_normal_effects  => g_total_normal_effects
    )
    port map( 
      clk              => clk,
      reset_n          => reset_n,
      enable_in        => enable_in,
      SW5              => SW5,
      SW6              => SW6,
      SW13             => SW13,
      SW14             => SW14,
      GNL_selector     => GNL_selector_connection,
      Out_selector     => Out_selector_connection,
      l_data_in_0      => l_data_in_0_connection,                     
      r_data_in_0      => r_data_in_0_connection,                
      l_data_in_n      => l_data_in_n_connection,                      
      r_data_in_n      => r_data_in_n_connection,
      l_data_out_n     => l_data_out_n_connection,                    
      r_data_out_n     => r_data_out_n_connection,
      l_data_out_logic => l_data_out_logic_connection,                 
      r_data_out_logic => r_data_out_logic_connection
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Out_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Out_Module : Out_Module
    generic map(
      n                       => n,
      g_total_delays_effects  => g_total_delays_effects,
      g_width                 => g_width
    )
    port map( 
      clk              => clk,
      reset_n          => reset_n,
      enable_in        => enable_in,
      Sin_Out          => Sin_Out_connection,
      GNL_selector     => GNL_selector_connection,
      l_data_out_logic => l_data_out_logic_connection,
      r_data_out_logic => r_data_out_logic_connection,
      l_data_out_0     => l_data_out_0_connection, 
      r_data_out_0     => r_data_out_0_connection,
      l_data_out_n     => l_data_out_n_connection, 
      r_data_out_n     => r_data_out_n_connection
  );   
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= l_data_out_0_connection;
  r_data_out <= r_data_out_0_connection;
  -------------------------------------------------------------------------------------------------------------------------------
end arch_digital_effects;