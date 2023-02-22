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
entity In_Module is
  port ( 
    clk          : in std_logic; --MCLK                                            
    reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in    : in std_logic; --Enable proporcionado por el i2s2
    Sin_In       : in std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable    
    GNL_selector : in std_logic_vector(total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
    l_data_in    : in std_logic_vector(width-1 downto 0); -- Datos de entrada izquierdos;                        
    r_data_in    : in std_logic_vector(width-1 downto 0); -- Datos de entrada derechos;                            
    l_data_in_0  : out std_logic_vector(width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
    r_data_in_0  : out std_logic_vector(width-1 downto 0);  -- Datos de salida derechos sin retardo;                         
    l_data_in_n  : out std_logic_vector(width-1 downto 0); -- Datos de salida izquierdos con retardo;                            
    r_data_in_n  : out std_logic_vector(width-1 downto 0)  -- Datos de salida derechos con retardo;      
); 
end In_Module;

------------------
-- Architecture --
------------------
architecture arch_In_Module of In_Module is
  
  --Signals
  signal l_data_in_reg, l_data_in_next              : std_logic_vector(width-1 downto 0);
  signal r_data_in_reg, r_data_in_next              : std_logic_vector(width-1 downto 0);
  signal l_data_in_n_muxed, r_data_in_n_muxed       : std_logic_vector(width-1 downto 0);
  
  signal l_data_fifo_0_to_1,   r_data_fifo_0_to_1   : std_logic_vector(width-1 downto 0); -- 256
  signal l_data_fifo_1_to_2,   r_data_fifo_1_to_2   : std_logic_vector(width-1 downto 0); -- 512
  signal l_data_fifo_2_to_3,   r_data_fifo_2_to_3   : std_logic_vector(width-1 downto 0); -- 768
  signal l_data_fifo_3_to_4,   r_data_fifo_3_to_4   : std_logic_vector(width-1 downto 0); -- 1024
  signal l_data_fifo_4_to_5,   r_data_fifo_4_to_5   : std_logic_vector(width-1 downto 0); -- 1280
  signal l_data_fifo_5_to_6,   r_data_fifo_5_to_6   : std_logic_vector(width-1 downto 0); -- 1536
  signal l_data_fifo_6_to_7,   r_data_fifo_6_to_7   : std_logic_vector(width-1 downto 0); -- 1792
  signal l_data_fifo_7_to_8,   r_data_fifo_7_to_8   : std_logic_vector(width-1 downto 0); -- 2048
  signal l_data_fifo_8_to_9,   r_data_fifo_8_to_9   : std_logic_vector(width-1 downto 0); -- 2304
  signal l_data_fifo_9_to_10,  r_data_fifo_9_to_10  : std_logic_vector(width-1 downto 0); -- 2560
  signal l_data_fifo_10_to_11, r_data_fifo_10_to_11 : std_logic_vector(width-1 downto 0); -- 2816
  signal l_data_fifo_11_to_12, r_data_fifo_11_to_12 : std_logic_vector(width-1 downto 0); -- 3072
  signal l_data_fifo_12_to_13, r_data_fifo_12_to_13 : std_logic_vector(width-1 downto 0); -- 3328
  signal l_data_fifo_13_to_14, r_data_fifo_13_to_14 : std_logic_vector(width-1 downto 0); -- 3584
  signal l_data_fifo_14_to_15, r_data_fifo_14_to_15 : std_logic_vector(width-1 downto 0); -- 3840
  signal l_data_fifo_15_to_16, r_data_fifo_15_to_16 : std_logic_vector(width-1 downto 0); -- 4096
  signal l_data_fifo_16_to_17, r_data_fifo_16_to_17 : std_logic_vector(width-1 downto 0); -- 4352
  signal l_data_fifo_17_to_18, r_data_fifo_17_to_18 : std_logic_vector(width-1 downto 0); -- 4608
  signal l_data_fifo_18_to_19, r_data_fifo_18_to_19 : std_logic_vector(width-1 downto 0); -- 4864
  signal l_data_fifo_19_to_O,  r_data_fifo_19_to_O  : std_logic_vector(width-1 downto 0); -- 5120
  
  signal l_fifo_full_0,  l_fifo_full_1,  l_fifo_full_2,  l_fifo_full_3  : std_logic;
  signal l_fifo_full_4,  l_fifo_full_5,  l_fifo_full_6,  l_fifo_full_7  : std_logic;
  signal l_fifo_full_8,  l_fifo_full_9,  l_fifo_full_10, l_fifo_full_11 : std_logic;
  signal l_fifo_full_12, l_fifo_full_13, l_fifo_full_14, l_fifo_full_15 : std_logic;
  signal l_fifo_full_16, l_fifo_full_17, l_fifo_full_18, l_fifo_full_19 : std_logic;
  signal r_fifo_full_0,  r_fifo_full_1,  r_fifo_full_2,  r_fifo_full_3  : std_logic;
  signal r_fifo_full_4,  r_fifo_full_5,  r_fifo_full_6,  r_fifo_full_7  : std_logic;
  signal r_fifo_full_8,  r_fifo_full_9,  r_fifo_full_10, r_fifo_full_11 : std_logic;
  signal r_fifo_full_12, r_fifo_full_13, r_fifo_full_14, r_fifo_full_15 : std_logic;
  signal r_fifo_full_16, r_fifo_full_17, r_fifo_full_18, r_fifo_full_19 : std_logic;
  
  -- signal wave_in_retard : integer;
  
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
        l_data_in_reg <= (others => '0');
        r_data_in_reg <= (others => '0'); 
      elsif(enable_in = '1')then
        l_data_in_reg <= l_data_in_next;
        r_data_in_reg <= r_data_in_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: 
  -------------------------------------------------------------------------------------------------------------------------------
  unit_in_fifo_generator_test_L_0 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_in_reg,
      wr_en => enable_in,
      rd_en => l_fifo_full_0,
      dout  => l_data_fifo_0_to_1,
      full  => l_fifo_full_0,
      empty => open
  );
  unit_in_fifo_generator_test_L_1 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_0_to_1,
      wr_en => l_fifo_full_0,
      rd_en => l_fifo_full_1,
      dout  => l_data_fifo_1_to_2,
      full  => l_fifo_full_1,
      empty => open
  );
  unit_in_fifo_generator_test_L_2 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_1_to_2,
      wr_en => l_fifo_full_1,
      rd_en => l_fifo_full_2,
      dout  => l_data_fifo_2_to_3,
      full  => l_fifo_full_2,
      empty => open
  );
  unit_in_fifo_generator_test_L_3 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_2_to_3,
      wr_en => l_fifo_full_2,
      rd_en => l_fifo_full_3,
      dout  => l_data_fifo_3_to_4,
      full  => l_fifo_full_3,
      empty => open
  );
  unit_in_fifo_generator_test_L_4 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_3_to_4,
      wr_en => l_fifo_full_3,
      rd_en => l_fifo_full_4,
      dout  => l_data_fifo_4_to_5,
      full  => l_fifo_full_4,
      empty => open
  );
  unit_in_fifo_generator_test_L_5 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_4_to_5,
      wr_en => l_fifo_full_4,
      rd_en => l_fifo_full_5,
      dout  => l_data_fifo_5_to_6,
      full  => l_fifo_full_5,
      empty => open
  );
  unit_in_fifo_generator_test_L_6 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_5_to_6,
      wr_en => l_fifo_full_5,
      rd_en => l_fifo_full_6,
      dout  => l_data_fifo_6_to_7,
      full  => l_fifo_full_6,
      empty => open
  );
  unit_in_fifo_generator_test_L_7 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_6_to_7,
      wr_en => l_fifo_full_6,
      rd_en => l_fifo_full_7,
      dout  => l_data_fifo_7_to_8,
      full  => l_fifo_full_7,
      empty => open
  );
  unit_in_fifo_generator_test_L_8 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_7_to_8,
      wr_en => l_fifo_full_7,
      rd_en => l_fifo_full_8,
      dout  => l_data_fifo_8_to_9,
      full  => l_fifo_full_8,
      empty => open
  );
  unit_in_fifo_generator_test_L_9 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_8_to_9,
      wr_en => l_fifo_full_8,
      rd_en => l_fifo_full_9,
      dout  => l_data_fifo_9_to_10,
      full  => l_fifo_full_9,
      empty => open
  );
  unit_in_fifo_generator_test_L_10 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_9_to_10,
      wr_en => l_fifo_full_9,
      rd_en => l_fifo_full_10,
      dout  => l_data_fifo_10_to_11,
      full  => l_fifo_full_10,
      empty => open
  );
  unit_in_fifo_generator_test_L_11 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_10_to_11,
      wr_en => l_fifo_full_10,
      rd_en => l_fifo_full_11,
      dout  => l_data_fifo_11_to_12,
      full  => l_fifo_full_11,
      empty => open
  );
  unit_in_fifo_generator_test_L_12 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_11_to_12,
      wr_en => l_fifo_full_11,
      rd_en => l_fifo_full_12,
      dout  => l_data_fifo_12_to_13,
      full  => l_fifo_full_12,
      empty => open
  );
  unit_in_fifo_generator_test_L_13 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_12_to_13,
      wr_en => l_fifo_full_12,
      rd_en => l_fifo_full_13,
      dout  => l_data_fifo_13_to_14,
      full  => l_fifo_full_13,
      empty => open
  );
  unit_in_fifo_generator_test_L_14 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_13_to_14,
      wr_en => l_fifo_full_13,
      rd_en => l_fifo_full_14,
      dout  => l_data_fifo_14_to_15,
      full  => l_fifo_full_14,
      empty => open
  );
  unit_in_fifo_generator_test_L_15 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_14_to_15,
      wr_en => l_fifo_full_14,
      rd_en => l_fifo_full_15,
      dout  => l_data_fifo_15_to_16,
      full  => l_fifo_full_15,
      empty => open
  );
  unit_in_fifo_generator_test_L_16 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_15_to_16,
      wr_en => l_fifo_full_15,
      rd_en => l_fifo_full_16,
      dout  => l_data_fifo_16_to_17,
      full  => l_fifo_full_16,
      empty => open
  );
  unit_in_fifo_generator_test_L_17 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_16_to_17,
      wr_en => l_fifo_full_16,
      rd_en => l_fifo_full_17,
      dout  => l_data_fifo_17_to_18,
      full  => l_fifo_full_17,
      empty => open
  );
  unit_in_fifo_generator_test_L_18 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_17_to_18,
      wr_en => l_fifo_full_17,
      rd_en => l_fifo_full_18,
      dout  => l_data_fifo_18_to_19,
      full  => l_fifo_full_18,
      empty => open
  );
  unit_in_fifo_generator_test_L_19 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => l_data_fifo_18_to_19,
      wr_en => l_fifo_full_18,
      rd_en => l_fifo_full_19,
      dout  => l_data_fifo_19_to_O,
      full  => l_fifo_full_19,
      empty => open
  );
  -------------------------------------------------------------------------------------------------------------------------------
  unit_in_fifo_generator_test_R_0 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_in_reg,
      wr_en => enable_in,
      rd_en => r_fifo_full_0,
      dout  => r_data_fifo_0_to_1,
      full  => r_fifo_full_0,
      empty => open
  );
  unit_in_fifo_generator_test_R_1 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_0_to_1,
      wr_en => r_fifo_full_0,
      rd_en => r_fifo_full_1,
      dout  => r_data_fifo_1_to_2,
      full  => r_fifo_full_1,
      empty => open
  );
  unit_in_fifo_generator_test_R_2 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_1_to_2,
      wr_en => r_fifo_full_1,
      rd_en => r_fifo_full_2,
      dout  => r_data_fifo_2_to_3,
      full  => r_fifo_full_2,
      empty => open
  );
  unit_in_fifo_generator_test_R_3 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_2_to_3,
      wr_en => r_fifo_full_2,
      rd_en => r_fifo_full_3,
      dout  => r_data_fifo_3_to_4,
      full  => r_fifo_full_3,
      empty => open
  );
  unit_in_fifo_generator_test_R_4 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_3_to_4,
      wr_en => r_fifo_full_3,
      rd_en => r_fifo_full_4,
      dout  => r_data_fifo_4_to_5,
      full  => r_fifo_full_4,
      empty => open
  );
  unit_in_fifo_generator_test_R_5 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_4_to_5,
      wr_en => r_fifo_full_4,
      rd_en => r_fifo_full_5,
      dout  => r_data_fifo_5_to_6,
      full  => r_fifo_full_5,
      empty => open
  );
  unit_in_fifo_generator_test_R_6 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_5_to_6,
      wr_en => r_fifo_full_5,
      rd_en => r_fifo_full_6,
      dout  => r_data_fifo_6_to_7,
      full  => r_fifo_full_6,
      empty => open
  );
  unit_in_fifo_generator_test_R_7 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_6_to_7,
      wr_en => r_fifo_full_6,
      rd_en => r_fifo_full_7,
      dout  => r_data_fifo_7_to_8,
      full  => r_fifo_full_7,
      empty => open
  );
  unit_in_fifo_generator_test_R_8 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_7_to_8,
      wr_en => r_fifo_full_7,
      rd_en => r_fifo_full_8,
      dout  => r_data_fifo_8_to_9,
      full  => r_fifo_full_8,
      empty => open
  );
  unit_in_fifo_generator_test_R_9 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_8_to_9,
      wr_en => r_fifo_full_8,
      rd_en => r_fifo_full_9,
      dout  => r_data_fifo_9_to_10,
      full  => r_fifo_full_9,
      empty => open
  );
  unit_in_fifo_generator_test_R_10 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_9_to_10,
      wr_en => r_fifo_full_9,
      rd_en => r_fifo_full_10,
      dout  => r_data_fifo_10_to_11,
      full  => r_fifo_full_10,
      empty => open
  );
  unit_in_fifo_generator_test_R_11 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_10_to_11,
      wr_en => r_fifo_full_10,
      rd_en => r_fifo_full_11,
      dout  => r_data_fifo_11_to_12,
      full  => r_fifo_full_11,
      empty => open
  );
  unit_in_fifo_generator_test_R_12 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_11_to_12,
      wr_en => r_fifo_full_11,
      rd_en => r_fifo_full_12,
      dout  => r_data_fifo_12_to_13,
      full  => r_fifo_full_12,
      empty => open
  );
  unit_in_fifo_generator_test_R_13 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_12_to_13,
      wr_en => r_fifo_full_12,
      rd_en => r_fifo_full_13,
      dout  => r_data_fifo_13_to_14,
      full  => r_fifo_full_13,
      empty => open
  );
  unit_in_fifo_generator_test_R_14 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_13_to_14,
      wr_en => r_fifo_full_13,
      rd_en => r_fifo_full_14,
      dout  => r_data_fifo_14_to_15,
      full  => r_fifo_full_14,
      empty => open
  );
  unit_in_fifo_generator_test_R_15 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_14_to_15,
      wr_en => r_fifo_full_14,
      rd_en => r_fifo_full_15,
      dout  => r_data_fifo_15_to_16,
      full  => r_fifo_full_15,
      empty => open
  );
  unit_in_fifo_generator_test_R_16 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_15_to_16,
      wr_en => r_fifo_full_15,
      rd_en => r_fifo_full_16,
      dout  => r_data_fifo_16_to_17,
      full  => r_fifo_full_16,
      empty => open
  );
  unit_in_fifo_generator_test_R_17 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_16_to_17,
      wr_en => r_fifo_full_16,
      rd_en => r_fifo_full_17,
      dout  => r_data_fifo_17_to_18,
      full  => r_fifo_full_17,
      empty => open
  );
  unit_in_fifo_generator_test_R_18 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_17_to_18,
      wr_en => r_fifo_full_17,
      rd_en => r_fifo_full_18,
      dout  => r_data_fifo_18_to_19,
      full  => r_fifo_full_18,
      empty => open
  );
  unit_in_fifo_generator_test_R_19 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => reset_n,
      din   => r_data_fifo_18_to_19,
      wr_en => r_fifo_full_18,
      rd_en => r_fifo_full_19,
      dout  => r_data_fifo_19_to_O,
      full  => r_fifo_full_19,
      empty => open
  );  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Data_Input to the fifo_t
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_next <= l_data_in;
  r_data_in_next <= r_data_in;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Sin_In for Vibrato 
  -------------------------------------------------------------------------------------------------------------------------------
  -- wave_in_retard <= to_integer(unsigned(Sin_In)) when (GNL_selector = Vibrato_line_active) else 0;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Muxed data for in_n Output
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_n_muxed <= l_data_fifo_11_to_12 when (GNL_selector = Delay_line_active)   else 
                       l_data_fifo_19_to_O  when (GNL_selector = Eco_line_active)     else 
                       l_data_fifo_1_to_2   when (GNL_selector = Reverb_line_active or 
                                                  GNL_selector = Vibrato_line_active) else (others => '0');                     
  r_data_in_n_muxed <= r_data_fifo_11_to_12 when (GNL_selector = Delay_line_active)   else 
                       r_data_fifo_19_to_O  when (GNL_selector = Eco_line_active)     else 
                       r_data_fifo_1_to_2   when (GNL_selector = Reverb_line_active or 
                                                  GNL_selector = Vibrato_line_active) else (others => '0');                     
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_0 <= std_logic_vector(l_data_in_reg);
  r_data_in_0 <= std_logic_vector(r_data_in_reg);
  l_data_in_n <= std_logic_vector(l_data_in_n_muxed);
  r_data_in_n <= std_logic_vector(r_data_in_n_muxed);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_In_Module;