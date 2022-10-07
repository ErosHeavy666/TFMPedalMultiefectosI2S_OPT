----------------------------------
-- Engineer: Eros García Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.pkg_digital_effects.all;

------------
-- Entity --
------------
entity tb_efecto_config_reverb is
end tb_efecto_config_reverb;

------------------
-- Architecture --
------------------
architecture tb_efecto_config_reverb_arch of tb_efecto_config_reverb is

  -- Constants
  constant g_width : integer := 16;
  constant clk_period : time := 89ns;
  
  signal clk, reset_n, enable_in, enable_out, BTNC, BTNL, BTND, BTNR : std_logic;
  signal l_data_in, l_data_out, r_data_in, r_data_out : std_logic_vector(g_width-1 downto 0);

begin

  Unit_EfectCONFIG_REVERB : efecto_config_reverb
    generic map(n1 => 1500, g_width => 16)
    port map(
      clk        => clk,
      reset_n    => reset_n,
      enable_in  => enable_in,
      BTNC       => BTNC,
      BTNL       => BTNL,
      BTND       => BTND,
      BTNR       => BTNR,
      l_data_in  => l_data_in,
      r_data_in  => r_data_in,
      l_data_out => l_data_out,
      r_data_out => r_data_out
  );

  clk_process :process
  begin    
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
  end process; 
  
  stim_proc: process 
  begin
    reset_n <= '1';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period; 
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;  

    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period; 
     
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;  
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;     
          
    reset_n <= '1';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait;   
                      
  end process;      
end tb_efecto_config_reverb_arch;
