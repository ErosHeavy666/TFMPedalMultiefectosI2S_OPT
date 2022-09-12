----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 22.12.2019 16:19:35
-- Design Name: 
-- Module Name: sine_wave_chorus - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sine_package2.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sine_wave_chorus is
  port( clk, reset_n, enable_in: in std_logic;
      wave_out: out sine_vector_type);
end sine_wave_chorus;

architecture Behavioral of sine_wave_chorus is
type state_type is ( counting_up, change_down, counting_down, change_up );
signal state, next_state : state_type;
signal table_index : table_index_type;
signal positive_cycle : boolean;
signal enable_5HZ : STD_LOGIC:= '0';

signal counter_reg, counter_next : unsigned (23 downto 0) := (others => '0');
  
begin

process( clk, reset_n, enable_in, enable_5HZ )
begin
  if reset_n = '1' then
    state <= counting_up;
  elsif rising_edge( clk ) then
    if (enable_in = '1' and enable_5HZ = '1') then
      state <= next_state;
    end if;
  end if;
end process;

process( state, table_index )
begin
  next_state <= state;
  case state is
    when counting_up =>
      if table_index = max_table_index then
        next_state <= change_down;
      end if;
    when change_down =>
      next_state <= counting_down;
    when counting_down =>
      if table_index = 0 then
        next_state <= change_up;
      end if;
    when others => -- change_up
      next_state <= counting_up;
  end case;
end process;

process( clk, reset_n, enable_in, enable_5HZ )
begin
  if reset_n = '1' then
    table_index <= 0;
    positive_cycle <= true;
  elsif rising_edge( clk ) then
    if( enable_in = '1' and enable_5HZ = '1') then
      case next_state is
        when counting_up =>
          table_index <= table_index + 1;
        when counting_down =>
          table_index <= table_index - 1;
        when change_up =>
          positive_cycle <= not positive_cycle;
        when others =>
          -- nothing to do
      end case;
    end if;
  end if;
end process;

process( table_index, positive_cycle )
  variable table_value: table_value_type;
begin
  table_value := get_table_value( table_index );
  if positive_cycle then
    wave_out <= std_logic_vector(to_signed(table_value,sine_vector_type'length));
  else
    wave_out <= std_logic_vector(to_signed(-table_value,sine_vector_type'length));
  end if;
end process;

process(clk, reset_n)
begin
    if reset_n = '1' then
        counter_reg <= (others => '0');
    elsif (rising_edge(clk)) then --MCLK
        counter_reg <= counter_next;
    end if;
end process;

process (counter_reg, enable_5HZ)
begin
    if counter_reg = 54 then
        enable_5HZ <= '1';
        counter_next <= (others => '0');
    else
        enable_5HZ <= '0';
        counter_next <= counter_reg + 1;
    end if;
end process;

end Behavioral;
