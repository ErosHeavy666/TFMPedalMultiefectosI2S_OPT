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
entity efecto_overdrive is
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
end efecto_overdrive;

architecture arch_efecto_overdrive of efecto_overdrive is

  -- Constants for threshold
  constant Vth_NEGATIVE : signed(g_width-1 downto 0) := x"D000"; --Umbral negativo
  constant Vth_POSITIVE : signed(g_width-1 downto 0) := x"3000"; --Umbral positivo
  constant Vth_ZERO : signed(g_width-1 downto 0) := x"0000";
  
  -- Signals 
  signal l_data_in_reg, l_data_in_next : signed(g_width-1 downto 0);
  signal r_data_in_reg, r_data_in_next : signed(g_width-1 downto 0);
  signal l_data_out_reg, l_data_out_next : signed(g_width-1 downto 0);
  signal r_data_out_reg, r_data_out_next : signed(g_width-1 downto 0);

begin
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
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
  l_data_out_next <= l_data_in_reg when (enable_in = '1' and (Vth_zero <= l_data_in_reg) and (l_data_in_reg < Vth_POSITIVE)) else
                     Vth_POSITIVE  when (enable_in = '1' and (l_data_in_reg >= Vth_POSITIVE))                                else
                     l_data_in_reg when (enable_in = '1' and (l_data_in_reg > Vth_NEGATIVE) and (l_data_in_reg < Vth_zero))  else
                     Vth_NEGATIVE  when (enable_in = '1' and (l_data_in_reg <= Vth_NEGATIVE))                                else
                     l_data_out_reg;  
  r_data_out_next <= r_data_in_reg when (enable_in = '1' and (Vth_zero <= r_data_in_reg) and (r_data_in_reg < Vth_POSITIVE)) else
                     Vth_POSITIVE  when (enable_in = '1' and (r_data_in_reg >= Vth_POSITIVE))                                else
                     r_data_in_reg when (enable_in = '1' and (r_data_in_reg > Vth_NEGATIVE) and (r_data_in_reg < Vth_zero))  else
                     Vth_NEGATIVE  when (enable_in = '1' and (r_data_in_reg <= Vth_NEGATIVE))                                else
                     r_data_out_reg;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process:
  l_data_out <= std_logic_vector(l_data_out_reg);   
  r_data_out <= std_logic_vector(r_data_out_reg); 
  -------------------------------------------------------------------------------------------------------------------------------
end arch_efecto_overdrive;
