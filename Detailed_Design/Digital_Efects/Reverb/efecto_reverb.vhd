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
entity efecto_reverb is
  generic(
    n       : integer := 500; --Línea de retardo
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
end efecto_reverb;

------------------
-- Architecture --
------------------
architecture arch_efecto_reverb of efecto_reverb is

  -- Type for fifo delay  
  type fifo_t is array (0 to n-1) of signed(g_width-1 downto 0);
  
  --Signals
  signal l_data_in_reg, l_data_in_next : fifo_t;
  signal r_data_in_reg, r_data_in_next : fifo_t;
  signal l_data_out_reg, l_data_out_next : fifo_t;
  signal r_data_out_reg, r_data_out_next : fifo_t;
  
begin
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        l_data_in_reg <= (others => (others => '0'));
        r_data_in_reg <= (others => (others => '0'));
        l_data_out_reg <= (others => (others => '0'));
        r_data_out_reg <= (others => (others => '0'));
      elsif(enable_in = '1')then
        l_data_in_reg <= l_data_in_next;
        r_data_in_reg <= r_data_in_next;
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Input to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_in, r_data_in, l_data_in_reg, r_data_in_reg)
  begin
    l_data_in_next(0) <= signed(l_data_in);
    r_data_in_next(0) <= signed(r_data_in);
    for i in 1 to n-1 loop
        l_data_in_next(i) <= l_data_in_reg(i-1);
        r_data_in_next(i) <= r_data_in_reg(i-1);
    end loop;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Output to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_in_reg, r_data_in_reg, l_data_out_reg, r_data_out_reg)
  begin
    l_data_out_next(0) <= -(shift_right(l_data_in_reg(0),1)) + shift_right(l_data_in_reg(n-1),0) + shift_right(l_data_out_reg(n-1),1);
    r_data_out_next(0) <= -(shift_right(r_data_in_reg(0),1)) + shift_right(r_data_in_reg(n-1),0) + shift_right(r_data_out_reg(n-1),1);
    for i in 1 to n-1 loop
        l_data_out_next(i) <= l_data_out_reg(i-1);
        r_data_out_next(i) <= r_data_out_reg(i-1);
    end loop;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= std_logic_vector(l_data_out_reg(0));
  r_data_out <= std_logic_vector(r_data_out_reg(0)); 
  -------------------------------------------------------------------------------------------------------------------------------
end arch_efecto_reverb;