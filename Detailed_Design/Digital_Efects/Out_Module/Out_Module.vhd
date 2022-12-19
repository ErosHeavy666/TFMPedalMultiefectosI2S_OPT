----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_sine.sine_vector_width;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Out_Module is
  port ( 
    clk              : in std_logic; --MCLK                                            
    reset_n          : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in        : in std_logic; --Enable proporcionado por el i2s2
    Sin_Out          : in std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable    
    GNL_selector     : in std_logic_vector(total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
    l_data_out_logic : in std_logic_vector(width-1 downto 0); -- Datos de entrada izquierdos;                        
    r_data_out_logic : in std_logic_vector(width-1 downto 0); -- Datos de entrada derechos;                            
    l_data_out_0     : out std_logic_vector(width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
    r_data_out_0     : out std_logic_vector(width-1 downto 0);  -- Datos de salida derechos sin retardo;                         
    l_data_out_n     : out std_logic_vector(width-1 downto 0); -- Datos de salida izquierdos con retardo;                            
    r_data_out_n     : out std_logic_vector(width-1 downto 0)  -- Datos de salida derechos con retardo;      
); 
end Out_Module;

------------------
-- Architecture --
------------------
architecture arch_Out_Module of Out_Module is
  
  -- Type for fifo delay  
  type fifo_t is array (0 to n-1) of signed(width-1 downto 0);
  
  --Signals
  signal l_data_out_reg, l_data_out_next : fifo_t;
  signal r_data_out_reg, r_data_out_next : fifo_t;
  signal l_data_out_n_muxed, r_data_out_n_muxed : signed(width-1 downto 0);
  signal wave_out_retard : integer;
  
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        l_data_out_reg <= (others => (others => '0'));
        r_data_out_reg <= (others => (others => '0')); 
      elsif(enable_in = '1')then
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Out_Logic to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_out_logic, r_data_out_logic, l_data_out_reg, r_data_out_reg)
  begin
    l_data_out_next(0) <= signed(l_data_out_logic);
    r_data_out_next(0) <= signed(r_data_out_logic);
    for i in 1 to n-1 loop
      l_data_out_next(i) <= l_data_out_reg(i-1);
      r_data_out_next(i) <= r_data_out_reg(i-1);
    end loop;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Sin_Out for Chorus 
  -------------------------------------------------------------------------------------------------------------------------------
  wave_out_retard <= to_integer(unsigned(Sin_Out)) when (GNL_selector = Chorus_line_active) else 0;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Muxed data for out_n Output
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_n_muxed <= l_data_out_reg(4999)                when (GNL_selector = Eco_line_active)    else 
                        l_data_out_reg(499)                 when (GNL_selector = Reverb_line_active) else 
                        l_data_out_reg(999-wave_out_retard) when (GNL_selector = Chorus_line_active) else (others => '0');         
  r_data_out_n_muxed <= r_data_out_reg(4999)                when (GNL_selector = Eco_line_active)    else 
                        r_data_out_reg(499)                 when (GNL_selector = Reverb_line_active) else 
                        r_data_out_reg(999-wave_out_retard) when (GNL_selector = Chorus_line_active) else (others => '0');                                                                                    
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_0 <= std_logic_vector(l_data_out_reg(0));
  r_data_out_0 <= std_logic_vector(r_data_out_reg(0));
  l_data_out_n <= std_logic_vector(l_data_out_n_muxed);
  r_data_out_n <= std_logic_vector(r_data_out_n_muxed);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Out_Module;