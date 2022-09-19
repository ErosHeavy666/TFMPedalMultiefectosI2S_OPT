----------------------------------
-- Engineer: Eros García Arroyo --
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
entity leds_tb is
end leds_tb;

------------------
-- Architecture --
------------------
architecture arch_leds_tb of leds_tb is

  -- Constants
  constant d_width    : integer := 16;
  constant clk_period : time := 90ns;

  -- Signals
  signal clk             : std_logic := '1';
  signal n_reset         : std_logic := '0';
  signal s_i_play_enable : std_logic := '0';
  signal s_i_r_data_rx   : signed (d_width-1 downto 0) := (others => '0');
  signal s_i_l_data_rx   : signed (d_width-1 downto 0) := (others => '0');
  signal s_o_leds        : std_logic_vector (d_width-1 downto 0);
  
  -- Components
  component leds is
    generic(
      g_width       : integer := 16);  -- Data width
    port ( 
      clk           : in std_logic; -- MCLK
      n_reset       : in std_logic; -- Reset síncrono a nivel bajo del sistema global
      i_play_enable : in std_logic; -- Enable que activa el sistema 
      i_r_data_rx   : in std_logic_vector (g_width-1 downto 0); -- Canal derecho de audio a la entrada
      i_l_data_rx   : in std_logic_vector (g_width-1 downto 0); -- Canal izquierdo de audio a la entrada
      o_leds        : out std_logic_vector (g_width-1 downto 0) -- Vector de 15 Leds 
    );
  end component;

begin

  unit_leds : leds  
    generic map(g_width => 16)
    port map(
      clk           => clk,
      n_reset       => n_reset,
      i_play_enable => s_i_play_enable,
      i_r_data_rx   => std_logic_vector(s_i_r_data_rx),
      i_l_data_rx   => std_logic_vector(s_i_l_data_rx),
      o_leds        => s_o_leds       
  );
    
  clk_process : process
  begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
  end process;    
                
  stim_proc: process 
  begin
  
      s_i_r_data_rx <= "0000000000001100";
      s_i_l_data_rx <= "0000000000001100";
      n_reset <= '0';
      s_i_play_enable <= '0';
      wait for 10*clk_period;
  
      s_i_r_data_rx <= "1100000000000110";
      s_i_l_data_rx <= "1100000000000110";    
      n_reset <= '1';
      s_i_play_enable <= '0';
      wait for 10*clk_period;
      
      n_reset <= '1';
      s_i_play_enable <= '1';
      s_i_r_data_rx <= "0000000000000000";
      s_i_l_data_rx <= "0000000000000000";     
      
      wait for 2*clk_period;    
      for i in 0 to 524288 loop
          s_i_r_data_rx <= s_i_r_data_rx + 1;
          s_i_l_data_rx <= s_i_l_data_rx + 1;
          wait for 2*clk_period;
      end loop;    
             
      n_reset <= '1';
      s_i_play_enable <= '0';
      wait for 10*clk_period;
      
      n_reset <= '0';
      s_i_play_enable <= '0';
      wait; 
  end process;
  
end arch_leds_tb;
