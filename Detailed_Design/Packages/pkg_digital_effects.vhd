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

component EfectoES is
  generic(
    d_width         :  INTEGER := 16);
  port( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); 
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); 
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
  );
end component;

component EfectoDELAY is
  generic(
    n               :  INTEGER := 4000;
    d_width         :  INTEGER := 16);
  port( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
  ); 
end component;

component EfectoCHORUS is
  generic(
    n               :  INTEGER := 1000;
    d_width         :  INTEGER := 16);
  port( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
  ); 
end component;

component EfectoVIBRATO is
  generic(
    n               :  INTEGER := 500;
    d_width         :  INTEGER := 16);
  port( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoREVERB is
GENERIC(
    n               :  INTEGER := 500;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoECO is
GENERIC(
    n               :  INTEGER := 5000;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

  component efecto_compressor is
    generic(
      g_width : integer := 16 --Ancho del bus 
      );
    port ( 
      clk        : in std_logic; --MCLK                                                
      reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global     
      enable_in  : in std_logic; --Enable proporcionado por el i2s2                    
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
  );
  end component;

  component efecto_overdrive is
    generic(
      g_width : integer := 16 --Ancho del bus 
      );
    port ( 
      clk        : in std_logic; --MCLK                                                
      reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global     
      enable_in  : in std_logic; --Enable proporcionado por el i2s2                    
      l_data_in  : in std_logic_vector(g_width-1 downto 0);             
      r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
      l_data_out : out std_logic_vector(g_width-1 downto 0);                        
      r_data_out : out std_logic_vector(g_width-1 downto 0)
    );
  end component;

component EfectoLOOPER is
GENERIC(
    d_width         : INTEGER := 16;
    d_deep          : INTEGER := 19
    );
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    SW13                  : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    SW5                   : IN STD_LOGIC;
    SW6                   : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoBANKFILTER is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    SW14                  : IN STD_LOGIC; --Switch de control para el tipo de filtro
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoREVERB_PARAMETRIZADO is
GENERIC(
    n1              : INTEGER := 1500;
    d_width         : INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    BTNC                  : in STD_LOGIC; 
    BTNL                  : in STD_LOGIC; 
    BTND                  : in STD_LOGIC;
    BTNR                  : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

    
end pkg_digital_effects;