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
package pkg_sine is

  constant max_table_value: integer := 7;
  subtype table_value_type is integer range 0 to max_table_value;

  constant max_table_index: integer := 7;
  subtype table_index_type is integer range 0 to max_table_index;
  
  constant sine_vector_width : integer := 4;

  function get_table_value (table_index: table_index_type) return table_value_type;

end pkg_sine;

------------------
-- Package Body --
------------------
package body pkg_sine is

  function get_table_value (table_index: table_index_type) return table_value_type is
    variable table_value: table_value_type;
  begin
    case table_index is
      when 0 =>
        table_value := 0;
      when 1 =>
        table_value := 1;
      when 2 =>
        table_value := 2;
      when 3 =>
        table_value := 3;
      when 4 =>
        table_value := 4;
      when 5 =>
        table_value := 5;
      when 6 =>
        table_value := 6;
      when 7 =>
        table_value := 7;
    end case;
    return table_value;
  end;

end pkg_sine;