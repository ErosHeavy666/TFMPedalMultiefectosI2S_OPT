----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------
-- Entity --
------------
entity efecto_filter is
  generic(
    g_width    : integer := 16); --Ancho del bus
  port ( 
    clk        : in std_logic; --MCLK
    reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global
    enable_in  : in std_logic; --Enable proporcionado por el i2s2 
    SW14       : in std_logic; --Switch de control para el tipo de filtro
    l_data_in  : in std_logic_vector(g_width-1 downto 0);             
    r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
    l_data_out : out std_logic_vector(g_width-1 downto 0);                        
    r_data_out : out std_logic_vector(g_width-1 downto 0)
  ); 
end efecto_filter;

architecture efecto_filter_arch of efecto_filter is
         
  -- Signals         
  signal l_data_filtered_reg, r_data_filtered_reg : std_logic_vector(g_width-1 downto 0);   
  signal l_data_filtered_next, r_data_filtered_next: std_logic_vector(g_width-1 downto 0);   
  signal l_data_filtered_ready, r_data_filtered_ready : std_logic; 
  signal filter_select : std_logic;    
  
  -- Components declaration  
  component Fir_Filter_Bankfilter is
    generic(
      g_width : integer := 16);
    port (  
      clk              : in std_logic; 
      reset_n          : in std_logic;             
      filter_select    : in std_logic;   
      data_in          : in std_logic_vector(g_width-1 downto 0); 
      data_in_ready    : in std_logic;    
      data_out         : out std_logic_vector(g_width-1 downto 0); 
      data_out_ready   : out std_logic
    );                                           
  end component;

begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Filter selection
  -------------------------------------------------------------------------------------------------------------------------------
  filter_select <= '1' when (SW14 = '1') else '0'; -- '1' = LPF // '0' = HPF
  -------------------------------------------------------------------------------------------------------------------------------
  -- Filter Instance for Left channel:
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Fir_Filter_Bankfilter_L : Fir_Filter_Bankfilter 
  generic map(g_width => 16)
  port map(
    clk              => clk,
    reset_n          => reset_n,
    filter_select    => filter_select,
    data_in          => l_data_in,
    data_in_ready    => enable_in,
    data_out         => l_data_filtered_next,
    data_out_ready   => l_data_filtered_ready
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Filter Instance for Right channel:
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_Fir_Filter_Bankfilter_R : Fir_Filter_Bankfilter 
  generic map(g_width => 16)
  port map(
    clk              => clk,
    reset_n          => reset_n,
    filter_select    => filter_select,
    data_in          => r_data_in,
    data_in_ready    => enable_in,
    data_out         => r_data_filtered_next,
    data_out_ready   => r_data_filtered_ready
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
          l_data_filtered_reg <= (others => '0');
          r_data_filtered_reg <= (others => '0');    
      elsif (l_data_filtered_ready = '1') then
        l_data_filtered_reg <= l_data_filtered_next;
      elsif (r_data_filtered_ready = '1') then
        r_data_filtered_reg <= r_data_filtered_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------  
  l_data_out <= l_data_filtered_reg;
  r_data_out <= r_data_filtered_reg;
  -------------------------------------------------------------------------------------------------------------------------------
end efecto_filter_arch;