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
  port( 
    clk          : in std_logic;    
    reset_n      : in std_logic;  
    enable_in    : in std_logic; 
    BTNC         : in std_logic;
    BTNU         : in std_logic; 
    BTNL         : in std_logic; 
    BTNR         : in std_logic;     
    BTND         : in std_logic;      
    SW0          : in std_logic; 
    SW1          : in std_logic; 
    SW2          : in std_logic; 
    SW3          : in std_logic; 
    SW4          : in std_logic; 
    SW5          : in std_logic; 
    SW6          : in std_logic; 
    SW7          : in std_logic; 
    SW8          : in std_logic; 
    SW9          : in std_logic; 
    l_data_in    : in std_logic_vector(width-1 downto 0);                     
    r_data_in    : in std_logic_vector(width-1 downto 0);   
    l_data_out   : out std_logic_vector(width-1 downto 0);                    
    r_data_out   : out std_logic_vector(width-1 downto 0)  
  );
end digital_effects;

------------------
-- Architecture --
------------------
architecture arch_digital_effects of digital_effects is
  
  -- Signals for interconnect the instances
  signal FBK_selector_connection : std_logic_vector(total_feedback_delays-1 downto 0);
  signal OUT_selector_connection : std_logic_vector(total_effects_binary-1 downto 0);
  signal BTNL_selector_connection : std_logic_vector(delays_effects_binary-1 downto 0);
  signal BTNR_selector_connection : std_logic_vector(delays_effects_binary-1 downto 0);
  signal BTNU_selector_connection : std_logic_vector(gain_effects_binary-1 downto 0);
  signal BTNC_selector_connection : std_logic_vector(gain_effects_binary-1 downto 0);
  signal BTND_selector_connection : std_logic_vector(gain_effects_binary-1 downto 0);
  signal Sin_In_connection : std_logic_vector(sine_vector_width-1 downto 0);
  signal Sin_Out_connection : std_logic_vector(sine_vector_width-1 downto 0);
  signal l_data_in_0_connection : std_logic_vector(width-1 downto 0);
  signal r_data_in_0_connection : std_logic_vector(width-1 downto 0);
  signal l_data_in_n_connection : std_logic_vector(width-1 downto 0);
  signal r_data_in_n_connection : std_logic_vector(width-1 downto 0);
  signal l_data_out_n_connection : std_logic_vector(width-1 downto 0);
  signal r_data_out_n_connection : std_logic_vector(width-1 downto 0);
  signal l_data_out_logic_connection : std_logic_vector(width-1 downto 0);
  signal r_data_out_logic_connection : std_logic_vector(width-1 downto 0);
  signal l_data_out_0_connection : std_logic_vector(width-1 downto 0);
  signal r_data_out_0_connection : std_logic_vector(width-1 downto 0);

begin
  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Selector_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Flow_Selector_Module : Flow_Selector_Module 
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
      FBK_selector => FBK_selector_connection,
      OUT_selector => Out_selector_connection
  ); 
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Selector_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Control_Selector_Module : Control_Selector_Module 
    port map( 
      clk           => clk,
      reset_n       => reset_n,
      enable_in     => enable_in,
      BTNC          => BTNC,
      BTNU          => BTNU,
      BTNL          => BTNL,
      BTNR          => BTNR,
      BTND          => BTND,
      BTNL_selector => BTNL_selector_connection,
      BTNR_selector => BTNR_selector_connection,
      BTNU_selector => BTNU_selector_connection,
      BTNC_selector => BTNC_selector_connection,
      BTND_selector => BTND_selector_connection
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
    port map( 
      clk           => clk,
      reset_n       => reset_n,
      enable_in     => enable_in,
      Sin_In        => Sin_In_connection,
      BTNL_selector => BTNL_selector_connection,
      l_data_in     => l_data_in,
      r_data_in     => r_data_in,
      l_data_in_0   => l_data_in_0_connection,   
      r_data_in_0   => r_data_in_0_connection,
      l_data_in_n   => l_data_in_n_connection,   
      r_data_in_n   => r_data_in_n_connection
  );   
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Output_Generator_Module
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Output_Generator_Module : Output_Generator_Module 
    port map( 
      clk              => clk,
      reset_n          => reset_n,
      enable_in        => enable_in,
      SW3              => SW3,
      SW4              => SW4,
      SW8              => SW8,
      SW9              => SW9,
      FBK_selector     => FBK_selector_connection,
      OUT_selector     => OUT_selector_connection,
      BTNU_selector    => BTNU_selector_connection,
      BTNC_selector    => BTNC_selector_connection,
      BTND_selector    => BTND_selector_connection,
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
    port map( 
      clk              => clk,
      reset_n          => reset_n,
      enable_in        => enable_in,
      Sin_Out          => Sin_Out_connection,
      BTNR_selector    => BTNR_selector_connection,
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