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
    g_width : integer := 16); --Ancho del bus     
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
  signal enable_n1, enable_n2, enable_n3, enable_n4 : std_logic := '0'; 
  
  signal state_n_next, state_n_reg: unsigned(1 downto 0) := "00"; 
  signal state_g1_next, state_g1_reg: unsigned(1 downto 0) := "00"; 
  signal state_g2_next, state_g2_reg: unsigned(1 downto 0) := "00"; 
  signal state_g3_next, state_g3_reg: unsigned(1 downto 0) := "00"; 
  signal BTNR_next, BTNR_reg : std_logic;
  signal BTND_next, BTND_reg : std_logic;
  signal BTNL_next, BTNL_reg : std_logic;
  signal BTNC_next, BTNC_reg : std_logic;
  signal BTNR_re_detection_next, BTNR_re_detection_reg : std_logic;
  signal BTND_re_detection_next, BTND_re_detection_reg : std_logic;
  signal BTNL_re_detection_next, BTNL_re_detection_reg : std_logic;
  signal BTNC_re_detection_next, BTNC_re_detection_reg : std_logic;
   
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
        ----------------------------------------------
        BTNR_reg <= '0';
        BTND_reg <= '0';
        BTNL_reg <= '0';
        BTNC_reg <= '0';
        BTNR_re_detection_reg <= '0';
        BTND_re_detection_reg <= '0';
        BTNL_re_detection_reg <= '0';
        BTNC_re_detection_reg <= '0';
        state_n_reg <= (others => '0');        
        state_g1_reg <= (others => '0');        
        state_g2_reg <= (others => '0');        
        state_g3_reg <= (others => '0');        
      elsif(enable_in = '1')then
        l_data_in_reg <= l_data_in_next;
        r_data_in_reg <= r_data_in_next;
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
        ----------------------------------------------
        BTNR_reg <= BTNR_next;
        BTND_reg <= BTND_next;
        BTNL_reg <= BTNL_next;
        BTNC_reg <= BTNC_next;
        BTNR_re_detection_reg <= BTNR_re_detection_next;
        BTND_re_detection_reg <= BTND_re_detection_next;
        BTNL_re_detection_reg <= BTNL_re_detection_next;
        BTNC_re_detection_reg <= BTNC_re_detection_next;
        state_n_reg <= state_n_next;        
        state_g1_reg <= state_g1_next;        
        state_g2_reg <= state_g2_next;        
        state_g3_reg <= state_g3_next;          
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Enable_n, g1, g2 y g3 generator to config the reverb stats
  -------------------------------------------------------------------------------------------------------------------------------  
  enable_n1 <= '1' when state_n_reg = "00" else '0';
  enable_n2 <= '1' when state_n_reg = "01" else '0';
  enable_n3 <= '1' when state_n_reg = "10" else '0';
  enable_n4 <= '1' when state_n_reg = "11" else '0';
  -------------------------------------------------------------------------------------------------------------------------------  
  g1 <= 0 when state_g1_reg = "00" else
        1 when state_g1_reg = "01" else
        2 when state_g1_reg = "10" else
        3;
  -------------------------------------------------------------------------------------------------------------------------------  
  g2 <= 1 when state_g2_reg = "00" else
        2 when state_g2_reg = "01" else
        3 when state_g2_reg = "10" else
        4;
  -------------------------------------------------------------------------------------------------------------------------------  
  g3 <= 0 when state_g2_reg = "00" else
        1 when state_g2_reg = "01" else
        2 when state_g2_reg = "10" else
        3;
  -------------------------------------------------------------------------------------------------------------------------------  
  BTNR_next <= BTNR;
  BTND_next <= BTND;
  BTNL_next <= BTNL;
  BTNC_next <= BTNC;
  -------------------------------------------------------------------------------------------------------------------------------  
  BTNR_re_detection_next <= '1' when (BTNR_next = '1' and BTNR_reg = '0') else '0';
  BTND_re_detection_next <= '1' when (BTND_next = '1' and BTND_reg = '0') else '0';
  BTNL_re_detection_next <= '1' when (BTNL_next = '1' and BTNL_reg = '0') else '0';
  BTNC_re_detection_next <= '1' when (BTNC_next = '1' and BTNC_reg = '0') else '0';
  -------------------------------------------------------------------------------------------------------------------------------  
  state_n_next  <= state_n_reg  + 1 when BTNR_re_detection_reg = '1' else state_n_reg;      
  state_g1_next <= state_g1_reg + 1 when BTNR_re_detection_reg = '1' else state_g1_reg;      
  state_g2_next <= state_g2_reg + 1 when BTNR_re_detection_reg = '1' else state_g2_reg;      
  state_g3_next <= state_g3_reg + 1 when BTNR_re_detection_reg = '1' else state_g3_reg;      
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