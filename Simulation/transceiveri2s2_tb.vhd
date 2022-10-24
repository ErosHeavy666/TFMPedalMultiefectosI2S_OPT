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
entity transceiveri2s2_tb is
end transceiveri2s2_tb;

architecture arch_transceiveri2s2_tb of transceiveri2s2_tb is

  -- Constants
  constant g_data_w     : natural := 14;
  constant g_ms_ratio_w : natural := 3;  
  constant g_sw_ratio_w : natural := 6; 
  constant clk_period   : time := 89ns;

  -- Signals
  signal clk       : std_logic := '1';
  signal n_reset   : std_logic := '0';
  signal i_reset_s : std_logic := '0';
  signal sclk      : std_logic := '0';
  signal ws        : std_logic := '0';
  signal sd_in     : std_logic := '0';
  signal sd_out    : std_logic := '0';
  signal en_in     : std_logic := '0';
  signal en_out    : std_logic := '0';
  signal l_in      : std_logic_vector(g_data_w-1 downto 0) := (others => '0');
  signal r_in      : std_logic_vector(g_data_w-1 downto 0) := (others => '0');
  signal l_out     : std_logic_vector(g_data_w-1 downto 0) := (others => '0');
  signal r_out     : std_logic_vector(g_data_w-1 downto 0) := (others => '0');
    
  -- Components
  component i2s_transceiver is
    generic (
        g_ms_ratio_w : natural := 3; -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
        g_sw_ratio_w : natural := 6; -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
        g_data_w     : natural := 14
    );
    port (
        clk        : in std_logic;
        n_reset    : in std_logic;

        i_reset_s  : in std_logic;
    
        sclk       : out std_logic;
        ws         : out std_logic;
        sd_in      : in std_logic;
        sd_out     : out std_logic;

        l_in       : out std_logic_vector(g_data_w-1 downto 0);
        r_in       : out std_logic_vector(g_data_w-1 downto 0);
        en_in      : out std_logic;

        l_out      : in std_logic_vector(g_data_w-1 downto 0);
        r_out      : in std_logic_vector(g_data_w-1 downto 0);
        en_out     : out std_logic
    );
  end component;
  
begin

  unit_i2s_transceiver : i2s_transceiver 
  generic map(
    g_ms_ratio_w => 3, 
    g_sw_ratio_w => 6, 
    g_data_w     => 12)
  port map(
     clk        => clk,
     n_reset    => n_reset,
     i_reset_s  => i_reset_s,
     sclk       => sclk, 
     ws         => ws, 
     sd_in      => sd_in, 
     sd_out     => sd_out,  
     l_in       => l_in, 
     r_in       => r_in, 
     en_in      => en_in, 
     l_out      => l_out, 
     r_out      => r_out,
     en_out     => en_out 
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
      n_reset   <= '0';
      i_reset_s <= '0';
      sd_in     <= '0';  
      l_out     <= (others => '0');
      r_out     <= (others => '0');         
      wait for 10*clk_period;
      n_reset   <= '1';
      i_reset_s <= '1';
      sd_in     <= '0';  
      l_out     <= (others => '0');
      r_out     <= (others => '0');         
      wait for 46 us;
      n_reset   <= '1';
      i_reset_s <= '1';
      sd_in     <= '1';  
      l_out     <= (others => '1');
      r_out     <= (others => '1');         
      wait for 46 us;    
      n_reset   <= '1';
      i_reset_s <= '1';
      sd_in     <= '0';  
      l_out     <= (others => '0');
      r_out     <= (others => '1');         
      wait;
  end process;

end arch_transceiveri2s2_tb;
