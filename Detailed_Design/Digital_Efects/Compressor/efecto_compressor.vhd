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
entity efecto_compressor is
  generic(
    g_width : integer := 16 --Ancho del bus 
    );
  port ( 
    clk        : in std_logic; --MCLK                                                
    reset_n    : in std_logic; --Reset síncrono a nivel alto del sistema global     
    enable_in  : in std_logic; --Enable proporcionado por el i2s2                    
    l_data_in  : in std_logic_vector(g_width-1 downto 0);             
    r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
    l_data_out : out std_logic_vector(g_width-1 downto 0);                        
    r_data_out : out std_logic_vector(g_width-1 downto 0)
);
end efecto_compressor;

------------------
-- Architecture --
------------------
architecture arch_efecto_compressor of efecto_compressor is
 
  -- Constants for threshold
  constant Vth_NEGATIVE : signed(g_width-1 downto 0) := x"9FFF"; --Umbral de la zona no líneal negativa --> +0.75
  constant Vth_POSITIVE : signed(g_width-1 downto 0) := x"6000"; --Umbral de la zona no lineal positiva --> -0.75
  constant Vth_ZERO : signed(g_width-1 downto 0) := x"0000";
  -- Constants for gain
  constant g1 : signed((g_width/2-1) downto 0) := x"50"; --Ganancia para zona lineal --> 0.625
  constant g2 : signed((g_width/2-1) downto 0) := x"10"; --Ganancia para zona no lineal --> 0.125

  -- Signals 
  signal l_data_in_reg, l_data_in_next : signed(g_width-1 downto 0);
  signal r_data_in_reg, r_data_in_next : signed(g_width-1 downto 0);
  signal l_data_out_reg, l_data_out_next : signed((g_width*3/2-1) downto 0);
  signal r_data_out_reg, r_data_out_next : signed((g_width*3/2-1) downto 0);

begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if(reset_n = '1') then
        l_data_in_reg  <= (others => '0');
        r_data_in_reg  <= (others => '0');        
        l_data_out_reg <= (others => '0');
        r_data_out_reg <= (others => '0');
      elsif(enable_in = '1')then
        l_data_in_reg  <= l_data_in_next;
        r_data_in_reg  <= r_data_in_next;        
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
      end if;
    end if;  
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_next <= signed(l_data_in);
  r_data_in_next <= signed(r_data_in); 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_next <= (l_data_in_reg*g1) when (enable_in = '1' and 
                                             (((Vth_zero <= l_data_in_reg)    and (l_data_in_reg < Vth_POSITIVE)) or 
                                              ((l_data_in_reg > Vth_NEGATIVE) and (l_data_in_reg < Vth_zero)))) else                                              
                     (Vth_positive*g1)+((l_data_in_reg-Vth_positive)*g2) when (enable_in = '1' and 
                                                                              ((l_data_in_reg >= Vth_POSITIVE) or
                                                                               (l_data_in_reg <= Vth_NEGATIVE))) else
                     l_data_out_reg;    
  r_data_out_next <= (r_data_in_reg*g1) when (enable_in = '1' and 
                                             (((Vth_zero <= r_data_in_reg)    and (r_data_in_reg < Vth_POSITIVE)) or 
                                              ((r_data_in_reg > Vth_NEGATIVE) and (r_data_in_reg < Vth_zero)))) else                                              
                     (Vth_positive*g1)+((r_data_in_reg-Vth_positive)*g2) when (enable_in = '1' and 
                                                                              ((r_data_in_reg >= Vth_POSITIVE) or
                                                                               (r_data_in_reg <= Vth_NEGATIVE))) else
                     r_data_out_reg;  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: --> Hay que castear la señal ya que por las multiplicaciones hay que subirla a 32 bits,
                     --- Nos quedamos con el signo y los decimales más significativos.
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= std_logic_vector(l_data_out_reg((g_width*3/2)-2 downto g_width/2-1));   
  r_data_out <= std_logic_vector(r_data_out_reg((g_width*3/2)-2 downto g_width/2-1));  
  -------------------------------------------------------------------------------------------------------------------------------
end arch_efecto_compressor;