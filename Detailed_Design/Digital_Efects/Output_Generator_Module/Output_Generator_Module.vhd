----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Output_Generator_Module is
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
end Output_Generator_Module;

------------------
-- Architecture --
------------------
architecture arch_Output_Generator_Module of Output_Generator_Module is
    
  -- Signals for Output generation
  signal l_data_in_0_to_out_reg, l_data_in_0_to_out_next : signed(g_width-1 downto 0);
  signal r_data_in_0_to_out_reg, r_data_in_0_to_out_next : signed(g_width-1 downto 0);
  signal l_data_in_n_to_out_reg, l_data_in_n_to_out_next : signed(g_width-1 downto 0);
  signal r_data_in_n_to_out_reg, r_data_in_n_to_out_next : signed(g_width-1 downto 0);
  signal l_data_out_n_to_out_reg, l_data_out_n_to_out_next : signed(g_width-1 downto 0);
  signal r_data_out_n_to_out_reg, r_data_out_n_to_out_next : signed(g_width-1 downto 0);
  signal l_data_out_feedback_reg, l_data_out_feedback_next : signed(g_width-1 downto 0);
  signal r_data_out_feedback_reg, r_data_out_feedback_next : signed(g_width-1 downto 0);
  signal l_data_out_logic_reg, l_data_out_logic_next : signed(g_width-1 downto 0);
  signal r_data_out_logic_reg, r_data_out_logic_next : signed(g_width-1 downto 0);
  
  -- Signals from output components
  signal l_data_out_es, r_data_out_es : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_looper, r_data_out_looper : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_compressor, r_data_out_compressor : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_overdrive, r_data_out_overdrive : std_logic_vector(g_width-1 downto 0);
  signal l_data_out_filter, r_data_out_filter : std_logic_vector(g_width-1 downto 0);
  
  -- Components
  component efecto_es is
    generic(
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
  
  component efecto_looper is
    generic(
      g_width : integer := 16; 
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
 
  component efecto_compressor is
    generic(
      g_width : integer := 16);
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
      g_width : integer := 16);
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

  component efecto_filter is
    generic(
      g_width    : integer := 16); 
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
  
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if(reset_n = '1') then
        l_data_in_0_to_out_reg <= (others => '0');
        r_data_in_0_to_out_reg <= (others => '0');
        l_data_in_n_to_out_reg <= (others => '0');
        r_data_in_n_to_out_reg <= (others => '0');
        l_data_out_n_to_out_reg <= (others => '0');
        r_data_out_n_to_out_reg <= (others => '0');
        l_data_out_feedback_reg <= (others => '0');
        r_data_out_feedback_reg <= (others => '0');
        l_data_out_logic_reg <= (others => '0');
        r_data_out_logic_reg <= (others => '0');
      elsif(enable_in = '1')then
        l_data_in_0_to_out_reg <= l_data_in_0_to_out_next;
        r_data_in_0_to_out_reg <= r_data_in_0_to_out_next;
        l_data_in_n_to_out_reg <= l_data_in_n_to_out_next;
        r_data_in_n_to_out_reg <= r_data_in_n_to_out_next;
        l_data_out_n_to_out_reg <= l_data_out_n_to_out_next;
        r_data_out_n_to_out_reg <= r_data_out_n_to_out_next;
        l_data_out_feedback_reg <= l_data_out_feedback_next;
        r_data_out_feedback_reg <= r_data_out_feedback_next;
        l_data_out_logic_reg <= l_data_out_logic_next;
        r_data_out_logic_reg <= r_data_out_logic_next;
      end if;
    end if;  
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_es
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_efecto_es : efecto_es 
    generic map(
      g_width => g_width) 
    port map( 
      clk        => clk,
      reset_n    => reset_n,
      enable_in  => enable_in,
      l_data_in  => l_data_in_0,                     
      r_data_in  => r_data_in_0,                       
      l_data_out => l_data_out_es,                         
      r_data_out => r_data_out_es
    ); 
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_looper
  -------------------------------------------------------------------------------------------------------------------------------    
  Unit_efecto_looper : efecto_looper 
    generic map(
      g_width => g_width, 
      d_deep  => 19)
    port map( 
      clk        => clk,
      reset_n    => reset_n,
      SW13       => SW13,
      enable_in  => enable_in,
      SW5        => SW5,
      SW6        => SW6,
      l_data_in  => l_data_in_0,             
      r_data_in  => r_data_in_0,                             
      l_data_out => l_data_out_looper,                        
      r_data_out => r_data_out_looper
    );  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_compressor
  -------------------------------------------------------------------------------------------------------------------------------   
  Unit_efecto_compressor : efecto_compressor 
    generic map(
      g_width => g_width)
    port map( 
      clk        => clk,              
      reset_n    => reset_n,
      enable_in  => enable_in,
      l_data_in  => l_data_in_0,           
      r_data_in  => r_data_in_0,                           
      l_data_out => l_data_out_compressor,                       
      r_data_out => r_data_out_compressor
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_overdrive
  -------------------------------------------------------------------------------------------------------------------------------   
  Unit_efecto_overdrive : efecto_overdrive
    generic map(
      g_width => g_width)
    port map( 
      clk        => clk,             
      reset_n    => reset_n,
      enable_in  => enable_in,
      l_data_in  => l_data_in_0,     
      r_data_in  => r_data_in_0,                     
      l_data_out => l_data_out_overdrive,                 
      r_data_out => r_data_out_overdrive
    );  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_filter
  ------------------------------------------------------------------------------------------------------------------------------- 
  Unit_efecto_filter : efecto_filter 
    generic map(
      g_width    => g_width)
    port map( 
      clk        => clk,
      reset_n    => reset_n,
      enable_in  => enable_in,
      SW14       => SW14,
      l_data_in  => l_data_in_0,         
      r_data_in  => r_data_in_0,                         
      l_data_out => l_data_out_filter,                     
      r_data_out => r_data_out_filter
    );     
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_in_0_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_0_to_out_next <= signed(l_data_in_0)                   when (GNL_selector = Delay_line_active or
                                                                         GNL_selector = Chorus_line_active)  else 
                             -(shift_right(signed(l_data_in_0),1)) when (GNL_selector = Reverb_line_active or
                                                                         GNL_selector = Eco_line_active)     else 
                             (others => '0');
  r_data_in_0_to_out_next <= signed(r_data_in_0)                   when (GNL_selector = Delay_line_active or
                                                                         GNL_selector = Chorus_line_active)  else 
                             -(shift_right(signed(r_data_in_0),1)) when (GNL_selector = Reverb_line_active or
                                                                         GNL_selector = Eco_line_active)     else 
                             (others => '0');
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_in_n_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_n_to_out_next <= shift_right(signed(l_data_in_n),1) when (GNL_selector = Delay_line_active or
                                                                      GNL_selector = Vibrato_line_active) else
                             signed(l_data_in_n)                when (GNL_selector = Reverb_line_active or
                                                                      GNL_selector = Eco_line_active)     else 
                             (others => '0');
  r_data_in_n_to_out_next <= shift_right(signed(r_data_in_n),1) when (GNL_selector = Delay_line_active or
                                                                      GNL_selector = Vibrato_line_active) else
                             signed(r_data_in_n)                when (GNL_selector = Reverb_line_active or
                                                                      GNL_selector = Eco_line_active)     else 
                             (others => '0');
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_n_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_n_to_out_next <= shift_right(signed(l_data_out_n),1) when (GNL_selector = Chorus_line_active or
                                                                        GNL_selector = Reverb_line_active or
                                                                        GNL_selector = Eco_line_active)   else
                              (others => '0');         
  r_data_out_n_to_out_next <= shift_right(signed(r_data_out_n),1) when (GNL_selector = Chorus_line_active or
                                                                        GNL_selector = Reverb_line_active or
                                                                        GNL_selector = Eco_line_active)   else
                              (others => '0');     
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_feedback:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_feedback_next <= l_data_in_0_to_out_reg + l_data_in_n_to_out_reg + l_data_out_n_to_out_reg;
  r_data_out_feedback_next <= r_data_in_0_to_out_reg + r_data_in_n_to_out_reg + r_data_out_n_to_out_reg;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_logic: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_logic_next <= signed(l_data_out_es)         when (Out_selector = ES_line_active)         else
                           signed(l_data_out_looper)     when (Out_selector = Looper_line_active)     else
                           signed(l_data_out_compressor) when (Out_selector = Compressor_line_active) else
                           signed(l_data_out_overdrive)  when (Out_selector = Overdrive_line_active)  else
                           signed(l_data_out_filter)     when (Out_selector = Filter_line_active)     else
                           l_data_out_feedback_reg       when (Out_selector = Feedback_line_active)   else
                           (others => '0');
  r_data_out_logic_next <= signed(r_data_out_es)         when (Out_selector = ES_line_active)         else
                           signed(r_data_out_looper)     when (Out_selector = Looper_line_active)     else
                           signed(r_data_out_compressor) when (Out_selector = Compressor_line_active) else
                           signed(r_data_out_overdrive)  when (Out_selector = Overdrive_line_active)  else
                           signed(r_data_out_filter)     when (Out_selector = Filter_line_active)     else
                           r_data_out_feedback_reg       when (Out_selector = Feedback_line_active)   else
                           (others => '0');
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_logic <= std_logic_vector(l_data_out_logic_reg);
  r_data_out_logic <= std_logic_vector(r_data_out_logic_reg);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Output_Generator_Module;