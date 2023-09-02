----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;

-------------
-- Package --
-------------
package pkg_project is
  
  -- Constants for bus width
  constant total_number_switches : integer := 10;
  constant total_delays_effects  : integer := 5; 
  constant total_normal_effects  : integer := 6; 
  constant n                     : integer := 5000;
  constant width                 : integer := 12;
    
  -- Constants for Encoding GNL selectors
  constant Disabled_delay_line : std_logic_vector(total_delays_effects-1 downto 0) := "00000";
  constant Delay_line_active   : std_logic_vector(total_delays_effects-1 downto 0) := "00001";
  constant Chorus_line_active  : std_logic_vector(total_delays_effects-1 downto 0) := "00010";
  constant Reverb_line_active  : std_logic_vector(total_delays_effects-1 downto 0) := "00100";
  constant Vibrato_line_active : std_logic_vector(total_delays_effects-1 downto 0) := "01000";
  constant Eco_line_active     : std_logic_vector(total_delays_effects-1 downto 0) := "10000";
  
  -- Constants for Encoding Out selectors
  constant Disabled_output_line   : std_logic_vector(total_normal_effects-1 downto 0) := "000000";
  constant ES_line_active         : std_logic_vector(total_normal_effects-1 downto 0) := "000001";
  constant Looper_line_active     : std_logic_vector(total_normal_effects-1 downto 0) := "000010";
  constant Compressor_line_active : std_logic_vector(total_normal_effects-1 downto 0) := "000100";
  constant Overdrive_line_active  : std_logic_vector(total_normal_effects-1 downto 0) := "001000";
  constant Filter_line_active     : std_logic_vector(total_normal_effects-1 downto 0) := "010000";
  constant Feedback_line_active   : std_logic_vector(total_normal_effects-1 downto 0) := "100000";
    
end pkg_project;