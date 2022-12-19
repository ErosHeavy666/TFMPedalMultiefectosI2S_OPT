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
  constant n                     : integer := 50;
  constant width                 : integer := 16;
  constant total_feedback_delays : integer := 3;
  constant total_number_switches : integer := 8;
  constant total_number_buttons  : integer := 5;
  constant total_delays_states   : integer := 8; 
  constant total_gain_states     : integer := 4; 
  constant total_effects         : integer := 8; 
     
  -- Constants for Encoding Input/Output LUTRAM selectors
  constant delays_effects_binary : integer := integer(ceil(log2(real(total_delays_states))));
  
  constant Disabled_delay_line : std_logic_vector(delays_effects_binary-1 downto 0) := "000";
  constant Enabled_4999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "001";
  constant Enabled_3999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "010";
  constant Enabled_3499_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "011";
  constant Enabled_2999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "100";
  constant Enabled_1999_line   : std_logic_vector(delays_effects_binary-1 downto 0) := "101";
  constant Enabled_999_line    : std_logic_vector(delays_effects_binary-1 downto 0) := "110";
  constant Enabled_499_line    : std_logic_vector(delays_effects_binary-1 downto 0) := "111";

  -- Constants for Encoding Input/Output Gain in Shift_Register 
  constant gain_effects_binary   : integer := integer(ceil(log2(real(total_gain_states))));
  
  constant Enabled_Unit_Input_Gain    : std_logic_vector(gain_effects_binary-1 downto 0) := "00";
  constant Enabled_Half_Input_Gain    : std_logic_vector(gain_effects_binary-1 downto 0) := "01";
  constant Enabled_Quarter_Input_Gain : std_logic_vector(gain_effects_binary-1 downto 0) := "10";
  constant Enabled_Eight_Input_Gain   : std_logic_vector(gain_effects_binary-1 downto 0) := "11"; 
  
  constant Enabled_Half_Output_Gain    : std_logic_vector(gain_effects_binary-1 downto 0) := "00";
  constant Enabled_Quarter_Output_Gain : std_logic_vector(gain_effects_binary-1 downto 0) := "01";
  constant Enabled_Eight_Output_Gain   : std_logic_vector(gain_effects_binary-1 downto 0) := "10"; 
  constant Enabled_Sixteen_Output_Gain : std_logic_vector(gain_effects_binary-1 downto 0) := "11"; 
  
  -- Constants for OUTPUT Selector line
  constant total_effects_binary : integer := integer(ceil(log2(real(total_effects))));

  constant ES_line_active            : std_logic_vector(total_effects_binary-1 downto 0) := "000";
  constant Feedback_1_2_lines_active : std_logic_vector(total_effects_binary-1 downto 0) := "001";
  constant Feedback_3_lines_active   : std_logic_vector(total_effects_binary-1 downto 0) := "010";
  constant Looper_line_active        : std_logic_vector(total_effects_binary-1 downto 0) := "011";
  constant Compressor_line_active    : std_logic_vector(total_effects_binary-1 downto 0) := "100";
  constant Overdrive_line_active     : std_logic_vector(total_effects_binary-1 downto 0) := "101";
  constant Filter_line_active        : std_logic_vector(total_effects_binary-1 downto 0) := "110";
  constant Disabled_output_line      : std_logic_vector(total_effects_binary-1 downto 0) := "111";
    
end pkg_project;