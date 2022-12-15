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
end Output_Generator_Module;

------------------
-- Architecture --
------------------
architecture arch_Output_Generator_Module of Output_Generator_Module is
    
  -- Signals for Output generation
  signal l_data_in_0_to_out_reg, l_data_in_0_to_out_next : signed(width-1 downto 0);
  signal r_data_in_0_to_out_reg, r_data_in_0_to_out_next : signed(width-1 downto 0);
  signal l_data_in_n_to_out_reg, l_data_in_n_to_out_next : signed(width-1 downto 0);
  signal r_data_in_n_to_out_reg, r_data_in_n_to_out_next : signed(width-1 downto 0);
  signal l_data_out_n_to_out_reg, l_data_out_n_to_out_next : signed(width-1 downto 0);
  signal r_data_out_n_to_out_reg, r_data_out_n_to_out_next : signed(width-1 downto 0);
  signal l_data_out_feedback_reg, l_data_out_feedback_next : signed(width-1 downto 0);
  signal r_data_out_feedback_reg, r_data_out_feedback_next : signed(width-1 downto 0);
  signal l_data_out_logic_reg, l_data_out_logic_next : signed(width-1 downto 0);
  signal r_data_out_logic_reg, r_data_out_logic_next : signed(width-1 downto 0);
  
  -- Signals from output components
  signal l_data_out_es, r_data_out_es : std_logic_vector(width-1 downto 0);
  signal l_data_out_looper, r_data_out_looper : std_logic_vector(width-1 downto 0);
  signal l_data_out_compressor, r_data_out_compressor : std_logic_vector(width-1 downto 0);
  signal l_data_out_overdrive, r_data_out_overdrive : std_logic_vector(width-1 downto 0);
  signal l_data_out_filter, r_data_out_filter : std_logic_vector(width-1 downto 0);
  
  -- Components
  component efecto_es is
    port( 
      clk        : in std_logic; 
      reset_n    : in std_logic; 
      enable_in  : in std_logic; 
      l_data_in  : in std_logic_vector(width-1 downto 0);                       
      r_data_in  : in std_logic_vector(width-1 downto 0);                         
      l_data_out : out std_logic_vector(width-1 downto 0);                          
      r_data_out : out std_logic_vector(width-1 downto 0) 
    );
  end component;
  
  component efecto_looper is
    generic(
      d_deep  : integer := 19); 
    port( 
      clk        : in std_logic;
      reset_n    : in std_logic;
      SW8        : in std_logic;
      enable_in  : in std_logic;
      SW3        : in std_logic;
      SW4        : in std_logic;        
      l_data_in  : in std_logic_vector(width-1 downto 0);             
      r_data_in  : in std_logic_vector(width-1 downto 0);                             
      l_data_out : out std_logic_vector(width-1 downto 0);                        
      r_data_out : out std_logic_vector(width-1 downto 0)
    );
  end component;
 
  component efecto_compressor is
    port ( 
      clk        : in std_logic;                                           
      reset_n    : in std_logic; 
      enable_in  : in std_logic;             
      l_data_in  : in std_logic_vector(width-1 downto 0);             
      r_data_in  : in std_logic_vector(width-1 downto 0);                             
      l_data_out : out std_logic_vector(width-1 downto 0);                        
      r_data_out : out std_logic_vector(width-1 downto 0)
  );
  end component;  
  
  component efecto_overdrive is
    port ( 
      clk        : in std_logic;                                                
      reset_n    : in std_logic;     
      enable_in  : in std_logic;      
      l_data_in  : in std_logic_vector(width-1 downto 0);             
      r_data_in  : in std_logic_vector(width-1 downto 0);                             
      l_data_out : out std_logic_vector(width-1 downto 0);                        
      r_data_out : out std_logic_vector(width-1 downto 0)
    );
  end component; 

  component efecto_filter is
    port ( 
      clk        : in std_logic; 
      reset_n    : in std_logic; 
      enable_in  : in std_logic; 
      SW9        : in std_logic;
      l_data_in  : in std_logic_vector(width-1 downto 0);             
      r_data_in  : in std_logic_vector(width-1 downto 0);                             
      l_data_out : out std_logic_vector(width-1 downto 0);                        
      r_data_out : out std_logic_vector(width-1 downto 0)
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
      d_deep  => 19)
    port map( 
      clk        => clk,
      reset_n    => reset_n,
      SW8        => SW8,
      enable_in  => enable_in,
      SW3        => SW3,
      SW4        => SW4,
      l_data_in  => l_data_in_0,             
      r_data_in  => r_data_in_0,                             
      l_data_out => l_data_out_looper,                        
      r_data_out => r_data_out_looper
    );  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: efecto_compressor
  -------------------------------------------------------------------------------------------------------------------------------   
  Unit_efecto_compressor : efecto_compressor 
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
    port map( 
      clk        => clk,
      reset_n    => reset_n,
      enable_in  => enable_in,
      SW9        => SW9,
      l_data_in  => l_data_in_0,         
      r_data_in  => r_data_in_0,                         
      l_data_out => l_data_out_filter,                     
      r_data_out => r_data_out_filter
    );     
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_in_0_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  process(FBK_selector, BTNU_selector, l_data_in_0, r_data_in_0)
  begin
    if (FBK_selector(0) = '1') then
      if (BTNU_selector = Enabled_Unit_Gain) then
        l_data_in_0_to_out_next <= -(shift_right(signed(l_data_in_0),0));
        r_data_in_0_to_out_next <= -(shift_right(signed(r_data_in_0),0));
      elsif(BTNU_selector = Enabled_Half_Gain) then
        l_data_in_0_to_out_next <= -(shift_right(signed(l_data_in_0),1));
        r_data_in_0_to_out_next <= -(shift_right(signed(r_data_in_0),1));
      elsif(BTNU_selector = Enabled_Quarter_Gain) then
        l_data_in_0_to_out_next <= -(shift_right(signed(l_data_in_0),2));
        r_data_in_0_to_out_next <= -(shift_right(signed(r_data_in_0),2));
      else
        l_data_in_0_to_out_next <= -(shift_right(signed(l_data_in_0),3));
        r_data_in_0_to_out_next <= -(shift_right(signed(r_data_in_0),3));
      end if;
    else
      l_data_in_0_to_out_next <= (others => '0');
      r_data_in_0_to_out_next <= (others => '0');
    end if; 
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_in_n_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  process(FBK_selector, BTNC_selector, l_data_in_n, r_data_in_n)
  begin
    if (FBK_selector(1) = '1') then
      if (BTNC_selector = Enabled_Unit_Gain) then
        l_data_in_n_to_out_next <= (shift_right(signed(l_data_in_n),0));
        r_data_in_n_to_out_next <= (shift_right(signed(r_data_in_n),0));
      elsif(BTNC_selector = Enabled_Half_Gain) then
        l_data_in_n_to_out_next <= (shift_right(signed(l_data_in_n),1));
        r_data_in_n_to_out_next <= (shift_right(signed(r_data_in_n),1));
      elsif(BTNC_selector = Enabled_Quarter_Gain) then
        l_data_in_n_to_out_next <= (shift_right(signed(l_data_in_n),2));
        r_data_in_n_to_out_next <= (shift_right(signed(r_data_in_n),2));
      else
        l_data_in_n_to_out_next <= (shift_right(signed(l_data_in_n),3));
        r_data_in_n_to_out_next <= (shift_right(signed(r_data_in_n),3));
      end if;
    else
      l_data_in_n_to_out_next <= (others => '0');
      r_data_in_n_to_out_next <= (others => '0');
    end if; 
  end process;  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_n_to_out:
  -------------------------------------------------------------------------------------------------------------------------------
  process(FBK_selector, BTND_selector, l_data_out_n, r_data_out_n)
  begin
    if (FBK_selector(2) = '1') then
      if (BTND_selector = Enabled_Unit_Gain) then
        l_data_out_n_to_out_next <= (shift_right(signed(l_data_out_n),0));
        r_data_out_n_to_out_next <= (shift_right(signed(r_data_out_n),0));
      elsif(BTND_selector = Enabled_Half_Gain) then
        l_data_out_n_to_out_next <= (shift_right(signed(l_data_out_n),1));
        r_data_out_n_to_out_next <= (shift_right(signed(r_data_out_n),1));
      elsif(BTND_selector = Enabled_Quarter_Gain) then
        l_data_out_n_to_out_next <= (shift_right(signed(l_data_out_n),2));
        r_data_out_n_to_out_next <= (shift_right(signed(r_data_out_n),2));
      else
        l_data_out_n_to_out_next <= (shift_right(signed(l_data_out_n),3));
        r_data_out_n_to_out_next <= (shift_right(signed(r_data_out_n),3));
      end if;
    else
      l_data_out_n_to_out_next <= (others => '0');
      r_data_out_n_to_out_next <= (others => '0');
    end if; 
  end process;    
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_feedback:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_feedback_next <= l_data_in_0_to_out_reg + l_data_in_n_to_out_reg + l_data_out_n_to_out_reg;
  r_data_out_feedback_next <= r_data_in_0_to_out_reg + r_data_in_n_to_out_reg + r_data_out_n_to_out_reg;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for data_out_logic: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_logic_next <= signed(l_data_out_es)         when (OUT_selector = ES_line_active)         else
                           signed(l_data_out_looper)     when (OUT_selector = Looper_line_active)     else
                           signed(l_data_out_compressor) when (OUT_selector = Compressor_line_active) else
                           signed(l_data_out_overdrive)  when (OUT_selector = Overdrive_line_active)  else
                           signed(l_data_out_filter)     when (OUT_selector = Filter_line_active)     else
                           l_data_out_feedback_reg       when (OUT_selector = Feedback_line_active)   else
                           (others => '0');           -- when (OUT_selector = Disabled_output_line)   
  r_data_out_logic_next <= signed(r_data_out_es)         when (OUT_selector = ES_line_active)         else
                           signed(r_data_out_looper)     when (OUT_selector = Looper_line_active)     else
                           signed(r_data_out_compressor) when (OUT_selector = Compressor_line_active) else
                           signed(r_data_out_overdrive)  when (OUT_selector = Overdrive_line_active)  else
                           signed(r_data_out_filter)     when (OUT_selector = Filter_line_active)     else
                           r_data_out_feedback_reg       when (OUT_selector = Feedback_line_active)   else
                           (others => '0');           -- when (OUT_selector = Disabled_output_line)  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_logic <= std_logic_vector(l_data_out_logic_reg);
  r_data_out_logic <= std_logic_vector(r_data_out_logic_reg);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Output_Generator_Module;