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
  type fifo_sine is array (0 to max_table_index*2+1) of std_logic_vector(width-1 downto 0);
  
  --Signals
  signal l_data_fifo_reg, l_data_fifo_next : fifo_sine;
  signal r_data_fifo_reg, r_data_fifo_next : fifo_sine;
    
  signal l_data_out_reg, l_data_out_next            : std_logic_vector(width-1 downto 0);
  signal r_data_out_reg, r_data_out_next            : std_logic_vector(width-1 downto 0);
  signal l_data_out_n_muxed, r_data_out_n_muxed     : std_logic_vector(width-1 downto 0);
  
  signal l_data_fifo_0_to_1,   r_data_fifo_0_to_1   : std_logic_vector(width-1 downto 0); -- 512
  signal l_data_fifo_1_to_2,   r_data_fifo_1_to_2   : std_logic_vector(width-1 downto 0); -- 1024
  signal l_data_fifo_2_to_3,   r_data_fifo_2_to_3   : std_logic_vector(width-1 downto 0); -- 1536
  signal l_data_fifo_3_to_4,   r_data_fifo_3_to_4   : std_logic_vector(width-1 downto 0); -- 2048
  signal l_data_fifo_4_to_5,   r_data_fifo_4_to_5   : std_logic_vector(width-1 downto 0); -- 2560
  signal l_data_fifo_5_to_6,   r_data_fifo_5_to_6   : std_logic_vector(width-1 downto 0); -- 3072
  signal l_data_fifo_6_to_7,   r_data_fifo_6_to_7   : std_logic_vector(width-1 downto 0); -- 3584
  signal l_data_fifo_7_to_8,   r_data_fifo_7_to_8   : std_logic_vector(width-1 downto 0); -- 4096
  signal l_data_fifo_8_to_9,   r_data_fifo_8_to_9   : std_logic_vector(width-1 downto 0); -- 4608
  signal l_data_fifo_9_to_O,   r_data_fifo_9_to_O   : std_logic_vector(width-1 downto 0); -- 5120
  
  signal l_fifo_full_0, l_fifo_full_reg0_0, l_fifo_full_reg1_0, r_fifo_full_0, r_fifo_full_reg0_0, r_fifo_full_reg1_0 : std_logic;
  signal l_fifo_full_1, l_fifo_full_reg0_1, l_fifo_full_reg1_1, r_fifo_full_1, r_fifo_full_reg0_1, r_fifo_full_reg1_1 : std_logic;
  signal l_fifo_full_2, l_fifo_full_reg0_2, l_fifo_full_reg1_2, r_fifo_full_2, r_fifo_full_reg0_2, r_fifo_full_reg1_2 : std_logic;
  signal l_fifo_full_3, l_fifo_full_reg0_3, l_fifo_full_reg1_3, r_fifo_full_3, r_fifo_full_reg0_3, r_fifo_full_reg1_3 : std_logic;
  signal l_fifo_full_4, l_fifo_full_reg0_4, l_fifo_full_reg1_4, r_fifo_full_4, r_fifo_full_reg0_4, r_fifo_full_reg1_4 : std_logic;
  signal l_fifo_full_5, l_fifo_full_reg0_5, l_fifo_full_reg1_5, r_fifo_full_5, r_fifo_full_reg0_5, r_fifo_full_reg1_5 : std_logic;
  signal l_fifo_full_6, l_fifo_full_reg0_6, l_fifo_full_reg1_6, r_fifo_full_6, r_fifo_full_reg0_6, r_fifo_full_reg1_6 : std_logic;
  signal l_fifo_full_7, l_fifo_full_reg0_7, l_fifo_full_reg1_7, r_fifo_full_7, r_fifo_full_reg0_7, r_fifo_full_reg1_7 : std_logic;
  signal l_fifo_full_8, l_fifo_full_reg0_8, l_fifo_full_reg1_8, r_fifo_full_8, r_fifo_full_reg0_8, r_fifo_full_reg1_8 : std_logic;
  signal l_fifo_full_O, r_fifo_full_O : std_logic;

  -- signal wave_out_retard : integer;

  -- Components
  component fifo_generator_test is
  port (
    clk   : in std_logic;
    srst  : in std_logic;
    din   : in std_logic_vector(width-1 downto 0);
    wr_en : in std_logic;
    rd_en : in std_logic;
    dout  : out std_logic_vector(width-1 downto 0);
    full  : out std_logic;
    empty : out std_logic
  );
  end component;
      
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        -----------------------------------------------
        l_data_fifo_reg <= (others => (others => '0'));
        r_data_fifo_reg <= (others => (others => '0'));    
        -----------------------------------------------   
        l_data_out_reg <= (others => '0');
        r_data_out_reg <= (others => '0'); 
        -----------------------------------------------
        l_fifo_full_reg0_0 <= '0';
        l_fifo_full_reg0_1 <= '0';
        l_fifo_full_reg0_2 <= '0';
        l_fifo_full_reg0_3 <= '0';
        l_fifo_full_reg0_4 <= '0';
        l_fifo_full_reg0_5 <= '0';
        l_fifo_full_reg0_6 <= '0';
        l_fifo_full_reg0_7 <= '0';
        l_fifo_full_reg0_8 <= '0';
        r_fifo_full_reg0_0 <= '0';
        r_fifo_full_reg0_1 <= '0';
        r_fifo_full_reg0_2 <= '0';
        r_fifo_full_reg0_3 <= '0';
        r_fifo_full_reg0_4 <= '0';
        r_fifo_full_reg0_5 <= '0';
        r_fifo_full_reg0_6 <= '0';
        r_fifo_full_reg0_7 <= '0';
        r_fifo_full_reg0_8 <= '0';
        -----------------------------------------------
        l_fifo_full_reg1_0 <= '0';
        l_fifo_full_reg1_1 <= '0';
        l_fifo_full_reg1_2 <= '0';
        l_fifo_full_reg1_3 <= '0';
        l_fifo_full_reg1_4 <= '0';
        l_fifo_full_reg1_5 <= '0';
        l_fifo_full_reg1_6 <= '0';
        l_fifo_full_reg1_7 <= '0';
        l_fifo_full_reg1_8 <= '0';
        r_fifo_full_reg1_0 <= '0';
        r_fifo_full_reg1_1 <= '0';
        r_fifo_full_reg1_2 <= '0';
        r_fifo_full_reg1_3 <= '0';
        r_fifo_full_reg1_4 <= '0';
        r_fifo_full_reg1_5 <= '0';
        r_fifo_full_reg1_6 <= '0';
        r_fifo_full_reg1_7 <= '0';
        r_fifo_full_reg1_8 <= '0';
        -----------------------------------------------
      elsif(enable_in = '1')then
        -----------------------------------------------
        l_data_fifo_reg <= l_data_fifo_next;
        r_data_fifo_reg <= r_data_fifo_next; 
        -----------------------------------------------
        l_data_out_reg <= l_data_out_next;
        r_data_out_reg <= r_data_out_next;
        -----------------------------------------------
      else
        -----------------------------------------------
        l_fifo_full_reg0_0 <= l_fifo_full_0;
        l_fifo_full_reg0_1 <= l_fifo_full_1;
        l_fifo_full_reg0_2 <= l_fifo_full_2;
        l_fifo_full_reg0_3 <= l_fifo_full_3;
        l_fifo_full_reg0_4 <= l_fifo_full_4;
        l_fifo_full_reg0_5 <= l_fifo_full_5;
        l_fifo_full_reg0_6 <= l_fifo_full_6;
        l_fifo_full_reg0_7 <= l_fifo_full_7;
        l_fifo_full_reg0_8 <= l_fifo_full_8;
        r_fifo_full_reg0_0 <= r_fifo_full_0;
        r_fifo_full_reg0_1 <= r_fifo_full_1;
        r_fifo_full_reg0_2 <= r_fifo_full_2;
        r_fifo_full_reg0_3 <= r_fifo_full_3;
        r_fifo_full_reg0_4 <= r_fifo_full_4;
        r_fifo_full_reg0_5 <= r_fifo_full_5;
        r_fifo_full_reg0_6 <= r_fifo_full_6;
        r_fifo_full_reg0_7 <= r_fifo_full_7;
        r_fifo_full_reg0_8 <= r_fifo_full_8;  
        -----------------------------------------------
        l_fifo_full_reg1_0 <= l_fifo_full_reg0_0;
        l_fifo_full_reg1_1 <= l_fifo_full_reg0_1;
        l_fifo_full_reg1_2 <= l_fifo_full_reg0_2;
        l_fifo_full_reg1_3 <= l_fifo_full_reg0_3;
        l_fifo_full_reg1_4 <= l_fifo_full_reg0_4;
        l_fifo_full_reg1_5 <= l_fifo_full_reg0_5;
        l_fifo_full_reg1_6 <= l_fifo_full_reg0_6;
        l_fifo_full_reg1_7 <= l_fifo_full_reg0_7;
        l_fifo_full_reg1_8 <= l_fifo_full_reg0_8;
        r_fifo_full_reg1_0 <= r_fifo_full_reg0_0;
        r_fifo_full_reg1_1 <= r_fifo_full_reg0_1;
        r_fifo_full_reg1_2 <= r_fifo_full_reg0_2;
        r_fifo_full_reg1_3 <= r_fifo_full_reg0_3;
        r_fifo_full_reg1_4 <= r_fifo_full_reg0_4;
        r_fifo_full_reg1_5 <= r_fifo_full_reg0_5;
        r_fifo_full_reg1_6 <= r_fifo_full_reg0_6;
        r_fifo_full_reg1_7 <= r_fifo_full_reg0_7;
        r_fifo_full_reg1_8 <= r_fifo_full_reg0_8;  
        -----------------------------------------------
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: 
  -------------------------------------------------------------------------------------------------------------------------------
  unit_out_fifo_generator_test_L_0 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_out_reg,
      wr_en => enable_in,
      rd_en => l_fifo_full_0,
      dout  => l_data_fifo_0_to_1,
      full  => l_fifo_full_0,
      empty => open
  );
  unit_out_fifo_generator_test_L_1 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_0_to_1,
      wr_en => l_fifo_full_reg1_0,
      rd_en => l_fifo_full_1,
      dout  => l_data_fifo_1_to_2,
      full  => l_fifo_full_1,
      empty => open
  );
  unit_out_fifo_generator_test_L_2 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_1_to_2,
      wr_en => l_fifo_full_reg1_1,
      rd_en => l_fifo_full_2,
      dout  => l_data_fifo_2_to_3,
      full  => l_fifo_full_2,
      empty => open
  );
  unit_out_fifo_generator_test_L_3 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_2_to_3,
      wr_en => l_fifo_full_reg1_2,
      rd_en => l_fifo_full_3,
      dout  => l_data_fifo_3_to_4,
      full  => l_fifo_full_3,
      empty => open
  );
  unit_out_fifo_generator_test_L_4 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_3_to_4,
      wr_en => l_fifo_full_reg1_3,
      rd_en => l_fifo_full_4,
      dout  => l_data_fifo_4_to_5,
      full  => l_fifo_full_4,
      empty => open
  );
  unit_out_fifo_generator_test_L_5 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_4_to_5,
      wr_en => l_fifo_full_reg1_4,
      rd_en => l_fifo_full_5,
      dout  => l_data_fifo_5_to_6,
      full  => l_fifo_full_5,
      empty => open
  );
  unit_out_fifo_generator_test_L_6 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_5_to_6,
      wr_en => l_fifo_full_reg1_5,
      rd_en => l_fifo_full_6,
      dout  => l_data_fifo_6_to_7,
      full  => l_fifo_full_6,
      empty => open
  );
  unit_out_fifo_generator_test_L_7 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_6_to_7,
      wr_en => l_fifo_full_reg1_6,
      rd_en => l_fifo_full_7,
      dout  => l_data_fifo_7_to_8,
      full  => l_fifo_full_7,
      empty => open
  );
  unit_out_fifo_generator_test_L_8 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_7_to_8,
      wr_en => l_fifo_full_reg1_7,
      rd_en => l_fifo_full_8,
      dout  => l_data_fifo_8_to_9,
      full  => l_fifo_full_8,
      empty => open
  );
  unit_out_fifo_generator_test_L_9 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_8_to_9,
      wr_en => l_fifo_full_reg1_8,
      rd_en => l_fifo_full_O,
      dout  => l_data_fifo_9_to_O,
      full  => l_fifo_full_O,
      empty => open
  );
  -------------------------------------------------------------------------------------------------------------------------------
  unit_out_fifo_generator_test_R_0 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_out_reg,
      wr_en => enable_in,
      rd_en => r_fifo_full_0,
      dout  => r_data_fifo_0_to_1,
      full  => r_fifo_full_0,
      empty => open
  );
  unit_out_fifo_generator_test_R_1 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_0_to_1,
      wr_en => r_fifo_full_reg1_0,
      rd_en => r_fifo_full_1,
      dout  => r_data_fifo_1_to_2,
      full  => r_fifo_full_1,
      empty => open
  );
  unit_out_fifo_generator_test_R_2 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_1_to_2,
      wr_en => r_fifo_full_reg1_1,
      rd_en => r_fifo_full_2,
      dout  => r_data_fifo_2_to_3,
      full  => r_fifo_full_2,
      empty => open
  );
  unit_out_fifo_generator_test_R_3 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_2_to_3,
      wr_en => r_fifo_full_reg1_2,
      rd_en => r_fifo_full_3,
      dout  => r_data_fifo_3_to_4,
      full  => r_fifo_full_3,
      empty => open
  );
  unit_out_fifo_generator_test_R_4 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_3_to_4,
      wr_en => r_fifo_full_reg1_3,
      rd_en => r_fifo_full_4,
      dout  => r_data_fifo_4_to_5,
      full  => r_fifo_full_4,
      empty => open
  );
  unit_out_fifo_generator_test_R_5 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_4_to_5,
      wr_en => r_fifo_full_reg1_4,
      rd_en => r_fifo_full_5,
      dout  => r_data_fifo_5_to_6,
      full  => r_fifo_full_5,
      empty => open
  );
  unit_out_fifo_generator_test_R_6 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_5_to_6,
      wr_en => r_fifo_full_reg1_5,
      rd_en => r_fifo_full_6,
      dout  => r_data_fifo_6_to_7,
      full  => r_fifo_full_6,
      empty => open
  );
  unit_out_fifo_generator_test_R_7 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_6_to_7,
      wr_en => r_fifo_full_reg1_6,
      rd_en => r_fifo_full_7,
      dout  => r_data_fifo_7_to_8,
      full  => r_fifo_full_7,
      empty => open
  );
  unit_out_fifo_generator_test_R_8 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_7_to_8,
      wr_en => r_fifo_full_reg1_7,
      rd_en => r_fifo_full_8,
      dout  => r_data_fifo_8_to_9,
      full  => r_fifo_full_8,
      empty => open
  );
  unit_out_fifo_generator_test_R_9 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_8_to_9,
      wr_en => r_fifo_full_reg1_8,
      rd_en => r_fifo_full_O,
      dout  => r_data_fifo_9_to_O,
      full  => r_fifo_full_O,
      empty => open
  );
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Out_Logic to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_next <= l_data_out_logic;
  r_data_out_next <= r_data_out_logic;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Out to the fifo_sine purpose
  -------------------------------------------------------------------------------------------------------------------------------
  process (l_data_fifo_1_to_2, r_data_fifo_1_to_2, l_data_fifo_reg, r_data_fifo_reg)
  begin
    l_data_fifo_next(0) <= l_data_fifo_1_to_2;
    r_data_fifo_next(0) <= r_data_fifo_1_to_2;
    for i in 1 to max_table_index*2+1 loop
      l_data_fifo_next(i) <= l_data_fifo_reg(i-1);
      r_data_fifo_next(i) <= r_data_fifo_reg(i-1);
    end loop;
  end process;  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Muxed data for out_n Output
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_n_muxed <= l_data_fifo_9_to_O                               when (GNL_selector = Eco_line_active)    else 
                        l_data_fifo_0_to_1                               when (GNL_selector = Reverb_line_active) else 
                        l_data_fifo_reg(0+to_integer(unsigned(Sin_Out))) when (GNL_selector = Chorus_line_active) else (others => '0');         
  r_data_out_n_muxed <= r_data_fifo_9_to_O                               when (GNL_selector = Eco_line_active)    else 
                        r_data_fifo_0_to_1                               when (GNL_selector = Reverb_line_active) else 
                        r_data_fifo_reg(0+to_integer(unsigned(Sin_Out))) when (GNL_selector = Chorus_line_active) else (others => '0');                                                                                  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out_0 <= std_logic_vector(l_data_out_reg);
  r_data_out_0 <= std_logic_vector(r_data_out_reg);
  l_data_out_n <= std_logic_vector(l_data_out_n_muxed);
  r_data_out_n <= std_logic_vector(r_data_out_n_muxed);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Out_Module;