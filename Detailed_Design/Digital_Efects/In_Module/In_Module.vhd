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
    clk           : in std_logic; 
    reset_n       : in std_logic; 
    enable_in     : in std_logic; 
    Sin_In        : in std_logic_vector(sine_vector_width-1 downto 0); 
    BTNL_selector : in std_logic_vector(delays_effects_binary-1 downto 0); 
    l_data_in     : in std_logic_vector(width-1 downto 0);         
    r_data_in     : in std_logic_vector(width-1 downto 0);           
    l_data_in_0   : out std_logic_vector(width-1 downto 0);                        
    r_data_in_0   : out std_logic_vector(width-1 downto 0);                    
    l_data_in_n   : out std_logic_vector(width-1 downto 0);                        
    r_data_in_n   : out std_logic_vector(width-1 downto 0) 
); 
end In_Module;

------------------
-- Architecture --
------------------
architecture arch_In_Module of In_Module is
  
  -- Type for fifo delay  
  type fifo_t is array (0 to n-1) of signed(width-1 downto 0);
  
  --Signals
  signal l_data_in_reg, l_data_in_next : fifo_t;
  signal r_data_in_reg, r_data_in_next : fifo_t;
  signal l_data_in_n_muxed, r_data_in_n_muxed : signed(width-1 downto 0);
  signal wave_in_retard : integer;
  
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
      elsif(enable_in = '1')then
        l_data_in_reg <= l_data_in_next;
        r_data_in_reg <= r_data_in_next;
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
  -- Combinational logic process: Sin_In for Vibrato 
  -------------------------------------------------------------------------------------------------------------------------------
  wave_in_retard <= to_integer(unsigned(Sin_In)) when (BTNL_selector = Enabled_499_line) else 0;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Muxed data for in_n Output
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_n_muxed <= l_data_in_reg(4999)                when (BTNL_selector = Enabled_4999_line) else 
                       l_data_in_reg(3999)                when (BTNL_selector = Enabled_3999_line) else
                       l_data_in_reg(3499)                when (BTNL_selector = Enabled_3499_line) else
                       l_data_in_reg(2999)                when (BTNL_selector = Enabled_2999_line) else
                       l_data_in_reg(1999)                when (BTNL_selector = Enabled_1999_line) else
                       l_data_in_reg(999)                 when (BTNL_selector = Enabled_999_line)  else
                       l_data_in_reg(499-wave_in_retard)  when (BTNL_selector = Enabled_499_line)  else (others => '0');                                                                                                           
  r_data_in_n_muxed <= r_data_in_reg(4999)                when (BTNL_selector = Enabled_4999_line) else 
                       r_data_in_reg(3999)                when (BTNL_selector = Enabled_3999_line) else
                       r_data_in_reg(3499)                when (BTNL_selector = Enabled_3499_line) else
                       r_data_in_reg(2999)                when (BTNL_selector = Enabled_2999_line) else
                       r_data_in_reg(1999)                when (BTNL_selector = Enabled_1999_line) else
                       r_data_in_reg(999)                 when (BTNL_selector = Enabled_999_line)  else
                       r_data_in_reg(499-wave_in_retard)  when (BTNL_selector = Enabled_499_line)  else (others => '0');  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_in_0 <= std_logic_vector(l_data_in_reg(0));
  r_data_in_0 <= std_logic_vector(r_data_in_reg(0));
  l_data_in_n <= std_logic_vector(l_data_in_n_muxed);
  r_data_in_n <= std_logic_vector(r_data_in_n_muxed);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_In_Module;