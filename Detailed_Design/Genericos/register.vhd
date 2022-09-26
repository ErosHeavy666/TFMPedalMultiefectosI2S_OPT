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
entity register_d is
  generic(
    g_width : integer := 16);
  port (
    clk     : in std_logic; --Entrada del reloj general del sistema de 12MHz
    n_reset : in std_logic; --Reset síncrono del sistema 
    i_en    : in std_logic; --Enable que activa el FF de tipo D (se asociará con Sample_In_Enable)
    i_data  : in std_logic_vector(g_width-1 downto 0); --Datos de entrada -> Sample_In -> Xn
    o_data  : out std_logic_vector(g_width-1 downto 0) --Datos de salida -> Xn -> Sample_Out
  );
end register_d;

------------------
-- Architecture --
------------------
architecture arch_register_d of register_d is

  -- Signals
  signal r_data, s_data : std_logic_vector (g_width-1 downto 0);
  
begin
  
  -- Register process:
  process(clk) 
  begin
    if(rising_edge(clk)) then
      if(n_reset = '0') then       --Si el reset esta a cero en un evento de subida del reloj
        r_data <= (others => '0'); --Se escribe un x"0000" a la salida del registro
      elsif (i_en = '1') then      --Si el reset no esta activado y se detecta que enable esta a uno en
        r_data <= s_data;          --un evento de subida del reloj, este coloca en la salida 
      end if;                      --el valor de la entrada
    end if;
  end process;  
  
  -- Combinational logic process:
  s_data <= i_data;
  
  -- Output process:
  o_data <= r_data;
  
end arch_register_d;
