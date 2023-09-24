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
entity MIG_Controller_tb is
end MIG_Controller_tb;

------------------
-- Architecture --
------------------
architecture arch_MIG_Controller_tb of MIG_Controller_tb is

  -- Constants
  constant width      : integer := 16;
  constant clk_period : time := 90 ns;

  -- Signals
  signal clk        : std_logic := '1';
  signal reset_n    : std_logic := '0';
  signal enable_in  : std_logic := '0';
  signal SW13       : std_logic := '0';
  signal SW5        : std_logic := '0';
  signal SW6        : std_logic := '0';
  signal l_data_out : std_logic_vector(width-1 downto 0) := (others => '0');
  signal r_data_out : std_logic_vector(width-1 downto 0) := (others => '0');
  
  -- Components
  component MIG_Controller is
  port( 
    clk        : in std_logic; --MCLK                                            
    reset_n    : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in  : in std_logic;  --Enable proporcionado por el i2s2                
    --- 
    SW13       : in std_logic; --RSTA     
    SW5        : in std_logic; --Switches de control para el looper --> Write
    SW6        : in std_logic; --Switches de control para el looper --> Read                
    ---
    l_data_out : out std_logic_vector(width-1 downto 0);  
    r_data_out : out std_logic_vector(width-1 downto 0)  
  );
  end component;

begin

  unit_MIG_Controller : MIG_Controller  
    port map(
      clk        => clk       ,
      reset_n    => reset_n   ,
      enable_in  => enable_in ,
      SW13       => SW13      ,
      SW5        => SW5       ,
      SW6        => SW6       ,
      l_data_out => l_data_out,
      r_data_out => r_data_out  
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
  
    reset_n <= '1';
    wait for 1000*clk_period;

    reset_n <= '0';
    wait for 1000*clk_period;

    SW5 <= '1';
    wait for 100*clk_period;

    enable_in <= '1';
    wait for clk_period;

    enable_in <= '0';
    wait for 100*clk_period;

    SW6 <= '1';
    wait for 10*clk_period;

    enable_in <= '1';
    wait for clk_period;

    SW5 <= '1';
    SW6 <= '1';
    wait for 10*clk_period;
    
    wait; 
      
  end process;
  
end arch_MIG_Controller_tb;
