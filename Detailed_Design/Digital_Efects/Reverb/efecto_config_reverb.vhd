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
entity efecto_config_reverb is
  generic(
    n1      : integer := 1500;--Línea de retardo  
    g_width : integer := 12); --Ancho del bus     
  port( 
    clk        : in std_logic; --MCLK                                             
    reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global  
    enable_in  : in std_logic; --Enable proporcionado por el i2s2                 
    BTNC       : in std_logic; --Volumen muestra retardada entrada
    BTNL       : in std_logic; --Volumen muestra original
    BTND       : in std_logic; --Volumen muestra retardada salida
    BTNR       : in std_logic; --Control de la línea de retardo
    l_data_in  : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada izquierdos;                        
    r_data_in  : in std_logic_vector(g_width-1 downto 0); -- Datos de entrada derechos;                            
    l_data_out : out std_logic_vector(g_width-1 downto 0); -- Datos de salida izquierdos;                            
    r_data_out : out std_logic_vector(g_width-1 downto 0)  -- Datos de salida derechos;  
  ); 
end efecto_config_reverb;

architecture arch_efecto_config_reverb of efecto_config_reverb is
   
  -- Type for fifo delay  
  type fifo_t1 is array (0 to n1-1) of signed(g_width-1 downto 0);
  
  --Signals
  signal l_data_in_reg, l_data_in_next : fifo_t1;
  signal r_data_in_reg, r_data_in_next : fifo_t1;
  signal l_data_out_reg, l_data_out_next : fifo_t1;
  signal r_data_out_reg, r_data_out_next : fifo_t1;
  signal l_data_out_next_n, r_data_out_next_n : signed(g_width-1 downto 0);
  
  signal g1 : integer; --Volumen muestra original --> BTNL
  signal g2 : integer; --Volumen muestra retardada salida --> BTND
  signal g3 : integer; --Volumen muestra retardada entrada --> BTNC

  signal state_n : unsigned(1 downto 0) := "00"; 
  signal state_g1, state_g2, state_g3 : unsigned(1 downto 0) := "00";
  signal button_n : STD_LOGIC := '1'; 
  signal button_g1, button_g2, button_g3 : STD_LOGIC := '1'; --Flag de control para no saturar el pulsador
  signal enable_n1, enable_n2 : STD_LOGIC := '0'; 
  signal enable_n3, enable_n4 : STD_LOGIC := '0';
   
begin

--Parametrización de n
process(clk, reset_n, BTNR, state_n, button_n)
begin
    if reset_n = '1' then
        state_n <= "00";
        button_n <= '1';
    elsif(rising_edge(clk))then
        if(BTNR = '1' and button_n = '1')then
            state_n <= state_n + 1; 
            button_n <= '0';
        elsif(BTNR = '1' and button_n = '0')then
            state_n <= state_n; 
            button_n <= '0';            
        else
            button_n <= '1';
            state_n <= state_n;
        end if;
    end if;
end process;

enable_n1 <= '1' when state_n = "00" else '0';
enable_n2 <= '1' when state_n = "01" else '0';
enable_n3 <= '1' when state_n = "10" else '0';
enable_n4 <= '1' when state_n = "11" else '0';

--Parametrización de g1
process(clk, reset_n, BTNL, state_g1, button_g1)
begin
    if reset_n = '1' then
        state_g1 <= "00"; 
        button_g1 <= '1';   
    elsif(rising_edge(clk))then
        if(BTNL = '1' and button_g1 = '1')then
            state_g1 <= state_g1 + 1; 
            button_g1 <= '0';
        elsif(BTNL = '1' and button_g1 = '0')then
            state_g1 <= state_g1; 
            button_g1 <= '0';            
        else
            button_g1 <= '1';
            state_g1 <= state_g1;
        end if;
    end if;
end process;

g1 <= 0 when state_g1 = "00" else
      1 when state_g1 = "01" else
      2 when state_g1 = "10" else
      3;
      
--Parametrización de g2
process(clk, reset_n, BTND, state_g2, button_g2)
begin
    if reset_n = '1' then
        state_g2 <= "00";
        button_g2 <= '1';   
    elsif(rising_edge(clk))then
        if(BTND = '1' and button_g2 = '1')then
            state_g2 <= state_g2 + 1; 
            button_g2 <= '0';
        elsif(BTND = '1' and button_g2 = '0')then
            state_g2 <= state_g2; 
            button_g2 <= '0';            
        else
            button_g2 <= '1';
            state_g2 <= state_g2;
        end if;
    end if;
end process;

g2 <= 1 when state_g2 = "00" else
      2 when state_g2 = "01" else
      3 when state_g2 = "10" else
      4;

--Parametrización de g3
process(clk, reset_n, BTNC, state_g3, button_g3)
begin
    if reset_n = '1' then
        state_g3 <= "00";
        button_g3 <= '1';   
    elsif(rising_edge(clk))then
        if(BTNC = '1' and button_g3 = '1')then
            state_g3 <= state_g3 + 1; 
            button_g3 <= '0';
        elsif(BTNC = '1' and button_g3 = '0')then
            state_g3 <= state_g3; 
            button_g3 <= '0';            
        else
            button_g3 <= '1';
            state_g3 <= state_g3;
        end if;
    end if;
end process;
      
g3 <= 0 when state_g3 = "00" else
      1 when state_g3 = "01" else
      2 when state_g3 = "10" else
      3;

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
    for i in 1 to n1-1 loop
        l_data_in_next(i) <= l_data_in_reg(i-1);
        r_data_in_next(i) <= r_data_in_reg(i-1);
    end loop;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Output to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_out_next_n, r_data_out_next_n, l_data_out_reg, r_data_out_reg)
  begin
    l_data_out_next(0) <= l_data_out_next_n;
    r_data_out_next(0) <= r_data_out_next_n;
    for i in 1 to n1-1 loop
        l_data_out_next(i) <= l_data_out_reg(i-1);
        r_data_out_next(i) <= r_data_out_reg(i-1);
    end loop;
  end process;
  l_data_out_next_n <= -(shift_right(l_data_in_reg(0),g1)) + shift_right(l_data_in_reg(n1-1),g3)    + shift_right(l_data_out_reg(n1-1),g2)    when enable_n1 = '1' else
                       -(shift_right(l_data_in_reg(0),g1)) + shift_right(l_data_in_reg(n1-501),g3)  + shift_right(l_data_out_reg(n1-501),g2)  when enable_n2 = '1' else
                       -(shift_right(l_data_in_reg(0),g1)) + shift_right(l_data_in_reg(n1-1001),g3) + shift_right(l_data_out_reg(n1-1001),g2) when enable_n3 = '1' else
                       -(shift_right(l_data_in_reg(0),g1)) + shift_right(l_data_in_reg(n1-1499),g3) + shift_right(l_data_out_reg(n1-1499),g2) when enable_n4 = '1' else 
                       l_data_out_reg(0);
  r_data_out_next_n <= -(shift_right(r_data_in_reg(0),g1)) + shift_right(r_data_in_reg(n1-1),g3)    + shift_right(r_data_out_reg(n1-1),g2)    when enable_n1 = '1' else
                       -(shift_right(r_data_in_reg(0),g1)) + shift_right(r_data_in_reg(n1-501),g3)  + shift_right(r_data_out_reg(n1-501),g2)  when enable_n2 = '1' else
                       -(shift_right(r_data_in_reg(0),g1)) + shift_right(r_data_in_reg(n1-1001),g3) + shift_right(r_data_out_reg(n1-1001),g2) when enable_n3 = '1' else
                       -(shift_right(r_data_in_reg(0),g1)) + shift_right(r_data_in_reg(n1-1499),g3) + shift_right(r_data_out_reg(n1-1499),g2) when enable_n4 = '1' else 
                       r_data_out_reg(0);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= std_logic_vector(l_data_out_reg(0));
  r_data_out <= std_logic_vector(r_data_out_reg(0)); 
  -------------------------------------------------------------------------------------------------------------------------------
end arch_efecto_config_reverb;