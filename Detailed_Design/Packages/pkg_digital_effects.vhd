----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use work.pkg_sine.sine_vector_width;
use work.pkg_project.all;

-------------
-- Package --
-------------
package pkg_digital_effects is

  component Flow_Selector_Module is
    port ( 
      clk          : in std_logic;     
      reset_n      : in std_logic;   
      enable_in    : in std_logic; 
      SW0          : in std_logic; 
      SW1          : in std_logic; 
      SW2          : in std_logic; 
      SW3          : in std_logic; 
      SW4          : in std_logic; 
      SW5          : in std_logic; 
      SW6          : in std_logic; 
      SW7          : in std_logic; 
      FBK_selector : out std_logic_vector(total_feedback_delays-1 downto 0); 
      OUT_selector : out std_logic_vector(total_effects_binary-1 downto 0)
  );
  end component;

  component Control_Selector_Module is
    port ( 
      clk           : in std_logic; 
      reset_n       : in std_logic; 
      enable_in     : in std_logic; 
      BTNC          : in std_logic;
      BTNU          : in std_logic; 
      BTNL          : in std_logic; 
      BTNR          : in std_logic;     
      BTND          : in std_logic;  
      BTNL_selector : out std_logic_vector(delays_effects_binary-1 downto 0);
      BTNR_selector : out std_logic_vector(delays_effects_binary-1 downto 0);
      BTNU_selector : out std_logic_vector(gain_effects_binary-1 downto 0);
      BTNC_selector : out std_logic_vector(gain_effects_binary-1 downto 0);
      BTND_selector : out std_logic_vector(gain_effects_binary-1 downto 0)
  );
  end component;

  component Sine_Generator is
    port ( 
      clk          : in std_logic; 
      reset_n      : in std_logic; 
      enable_in    : in std_logic; 
      Sin_In       : out std_logic_vector(sine_vector_width-1 downto 0);      
      Sin_Out      : out std_logic_vector(sine_vector_width-1 downto 0)      
  ); 
  end component;

  component In_Module is
    port ( 
      clk           : in std_logic; 
      reset_n       : in std_logic; 
      enable_in     : in std_logic; 
      Sin_In        : in std_logic_vector(sine_vector_width-1 downto 0); 
      BTNL_selector : in std_logic_vector(delays_effects_binary-1 downto 0); 
      l_data_in     : in std_logic_vector(width-1 downto 0);         
      r_data_in     : in std_logic_vector(width-1 downto 0);           
      l_data_in_0   : out std_logic_vector(width-1 downto 0);                        
      r_data_in_0   : out std_logic_vector(width-1 downto 0);                    
      l_data_in_n   : out std_logic_vector(width-1 downto 0);                        
      r_data_in_n   : out std_logic_vector(width-1 downto 0) 
  );
  end component;

  component Output_Generator_Module is
    port ( 
      clk              : in std_logic;
      reset_n          : in std_logic;
      enable_in        : in std_logic;
      SW3              : in std_logic;
      SW4              : in std_logic;
      SW8              : in std_logic;
      SW9              : in std_logic;
      FBK_selector     : in std_logic_vector(total_feedback_delays-1 downto 0); 
      OUT_selector     : in std_logic_vector(total_effects_binary-1 downto 0);
      BTNU_selector    : in std_logic_vector(gain_effects_binary-1 downto 0);
      BTNC_selector    : in std_logic_vector(gain_effects_binary-1 downto 0);
      BTND_selector    : in std_logic_vector(gain_effects_binary-1 downto 0);    
      l_data_in_0      : in std_logic_vector(width-1 downto 0);                            
      r_data_in_0      : in std_logic_vector(width-1 downto 0);                      
      l_data_in_n      : in std_logic_vector(width-1 downto 0);                            
      r_data_in_n      : in std_logic_vector(width-1 downto 0);   
      l_data_out_n     : in std_logic_vector(width-1 downto 0);                           
      r_data_out_n     : in std_logic_vector(width-1 downto 0);   
      l_data_out_logic : out std_logic_vector(width-1 downto 0);                       
      r_data_out_logic : out std_logic_vector(width-1 downto 0)  
  );
  end component;

  component Out_Module is
    port ( 
      clk              : in std_logic; 
      reset_n          : in std_logic; 
      enable_in        : in std_logic; 
      Sin_Out          : in std_logic_vector(sine_vector_width-1 downto 0); 
      BTNR_selector    : in std_logic_vector(delays_effects_binary-1 downto 0); 
      l_data_out_logic : in std_logic_vector(width-1 downto 0);         
      r_data_out_logic : in std_logic_vector(width-1 downto 0);           
      l_data_out_0     : out std_logic_vector(width-1 downto 0);                        
      r_data_out_0     : out std_logic_vector(width-1 downto 0);                    
      l_data_out_n     : out std_logic_vector(width-1 downto 0);                        
      r_data_out_n     : out std_logic_vector(width-1 downto 0)     
  ); 
  end component;
    
end pkg_digital_effects;