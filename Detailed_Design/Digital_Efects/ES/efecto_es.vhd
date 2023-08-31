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
entity efecto_es is
  generic(
    g_width : integer := 8 --Ancho del bus
  ); 
  port( 
    clk        : in std_logic; --MCLK                                            
    reset_n    : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in  : in std_logic; --Enable proporcionado por el i2s2                
    l_data_in  : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos;                        
    r_data_in  : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos;                            
    l_data_out : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos;                            
    r_data_out : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida derechos;  
  );
end efecto_es;

------------------
-- Architecture --
------------------
architecture arch_efecto_es of efecto_es is

  --Signals
  signal l_data_in_reg, l_data_in_next : signed(g_width-1 downto 0);
  signal r_data_in_reg, r_data_in_next : signed(g_width-1 downto 0);
  signal l_data_out_reg, l_data_out_next : signed(g_width-1 downto 0);
  signal r_data_out_reg, r_data_out_next : signed(g_width-1 downto 0);
  
begin 

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        l_data_in_reg <= (others => '0');
        r_data_in_reg <= (others => '0');
        l_data_out_reg <= (others => '0');
        r_data_out_reg <= (others => '0'); 
      elsif(enable_in = '1')then
        l_data_in_reg <= l_data_in_next;
        r_data_in_reg <= r_data_in_next;
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Input to the Register
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_next <= signed(l_data_in);
  r_data_in_next <= signed(r_data_in);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Register to the output
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_next <= l_data_in_reg;
  r_data_out_next <= r_data_in_reg;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= std_logic_vector(l_data_out_reg);
  r_data_out <= std_logic_vector(r_data_out_reg);
  -------------------------------------------------------------------------------------------------------------------------------  
end arch_efecto_es;