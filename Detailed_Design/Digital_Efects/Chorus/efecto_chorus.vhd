----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_sine.all;

------------
-- Entity --
------------
entity efecto_chorus is
  generic(
    n       : integer := 1000; --Línea de retardo
    g_width : integer := 12 --Ancho del bus 
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
end efecto_chorus;

------------------
-- Architecture --
------------------
architecture arch_efecto_chorus of efecto_chorus is

  -- Type for fifo delay  
  type fifo_t is array (0 to n-1) of signed(g_width-1 downto 0);
  
  --Signals
  signal l_data_in_reg, l_data_in_next : signed(g_width-1 downto 0);
  signal r_data_in_reg, r_data_in_next : signed(g_width-1 downto 0);
  signal l_data_out_reg, l_data_out_next : fifo_t;
  signal r_data_out_reg, r_data_out_next : fifo_t;
  signal wave_out_retard : sine_vector_type;
  
  -- Components declaration
  component sine_wave_chorus is
    port(clk, reset_n, enable_in: in std_logic;
         wave_out: out sine_vector_type);
  end component; 
     
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Wave Instance to modulate the retard line:
  -------------------------------------------------------------------------------------------------------------------------------
  Unit_sine_wave_chorus : sine_wave_chorus 
  port map(
      clk       => clk,
      reset_n   => reset_n,
      enable_in => enable_in,
      wave_out  => wave_out_retard
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        l_data_in_reg <= (others => '0');
        r_data_in_reg <= (others => '0'); 
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
  -- Combinational logic process: Data_Output to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_in_reg, r_data_in_reg, l_data_out_reg, r_data_out_reg, wave_out_retard)
  begin
    l_data_out_next(0) <= l_data_in_reg + shift_right(l_data_out_reg(n-to_integer(unsigned(wave_out_retard))-1),1);
    r_data_out_next(0) <= r_data_in_reg + shift_right(r_data_out_reg(n-to_integer(unsigned(wave_out_retard))-1),1);
    for i in 1 to n-1 loop
        l_data_out_next(i) <= l_data_out_reg(i-1);
        r_data_out_next(i) <= r_data_out_reg(i-1);
    end loop;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Input to the Register
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_next <= signed(l_data_in);
  r_data_in_next <= signed(r_data_in);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= std_logic_vector(l_data_out_reg(0));
  r_data_out <= std_logic_vector(r_data_out_reg(0));
  -------------------------------------------------------------------------------------------------------------------------------
end arch_efecto_chorus;