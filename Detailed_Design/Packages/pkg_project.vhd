----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

-------------
-- Package --
-------------
package pkg_project is
  
  -- Constants for bus width
  constant n                       : integer := 5000;
  constant g_width                 : integer := 16;
  constant g_total_feedback_delays : integer := 3;
  constant g_total_number_switches : integer := 8;
  constant g_total_number_buttons  : integer := 5;
  constant g_total_delays_effects  : integer := 8; 
  constant g_total_gain_effects    : integer := 4; 
  constant g_total_global_effects  : integer := 6; 
     
  -- Constants for Encoding Input/Output LUTRAM selectors
  constant delays_effects_binary : integer := integer(ceil(log2(real(g_total_delays_effects))));
  constant gain_effects_binary   : integer := integer(ceil(log2(real(g_total_gain_effects))));
  
  constant Disabled_delay_line : std_logic_vector(delays_effects_binary-1 downto 0) := "000";
  constant Enabled_4999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "001";
  constant Enabled_3999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "010";
  constant Enabled_3499_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "011";
  constant Enabled_2999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "100";
  constant Enabled_1999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "101";
  constant Enabled_999_line    : std_logic_vector(delays_effects_binary-1 downto 0) := "110";
  constant Enabled_499_line    : std_logic_vector(delays_effects_binary-1 downto 0) := "111";

  -- Constants for Encoding Out selectors
  constant Disabled_output_line   : std_logic_vector(g_total_normal_effects-1 downto 0) := "000000";
  constant ES_line_active         : std_logic_vector(g_total_normal_effects-1 downto 0) := "000001";
  constant Looper_line_active     : std_logic_vector(g_total_normal_effects-1 downto 0) := "000010";
  constant Compressor_line_active : std_logic_vector(g_total_normal_effects-1 downto 0) := "000100";
  constant Overdrive_line_active  : std_logic_vector(g_total_normal_effects-1 downto 0) := "001000";
  constant Filter_line_active     : std_logic_vector(g_total_normal_effects-1 downto 0) := "010000";
  constant Feedback_line_active   : std_logic_vector(g_total_normal_effects-1 downto 0) := "100000";
    
end pkg_project;