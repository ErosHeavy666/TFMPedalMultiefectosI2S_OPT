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
package pkg_letters is

  -- Every available display letters
  constant off : std_logic_vector (6 downto 0) := "1111111"; 
  constant a   : std_logic_vector (6 downto 0) := "0001000";
  constant b   : std_logic_vector (6 downto 0) := "0000011";
  constant c   : std_logic_vector (6 downto 0) := "1000110";
  constant d   : std_logic_vector (6 downto 0) := "0100001";
  constant e   : std_logic_vector (6 downto 0) := "0000110";
  constant f   : std_logic_vector (6 downto 0) := "0001110";
  constant h   : std_logic_vector (6 downto 0) := "0001001";
  constant i   : std_logic_vector (6 downto 0) := "1111011";
  constant l   : std_logic_vector (6 downto 0) := "1000111";
  constant n   : std_logic_vector (6 downto 0) := "0101011";
  constant o   : std_logic_vector (6 downto 0) := "1000000";
  constant p   : std_logic_vector (6 downto 0) := "0001100";
  constant r   : std_logic_vector (6 downto 0) := "0101111";
  constant s   : std_logic_vector (6 downto 0) := "0010010";
  constant u   : std_logic_vector (6 downto 0) := "1000001";
  constant y   : std_logic_vector (6 downto 0) := "0010001"; 
    
end pkg_letters;