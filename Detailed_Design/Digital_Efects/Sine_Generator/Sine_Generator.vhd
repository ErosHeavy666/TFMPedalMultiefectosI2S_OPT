----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_sine.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Sine_Generator is
  port ( 
    clk          : in std_logic; --MCLK                                            
    reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in    : in std_logic; --Enable proporcionado por el i2s2
    Sin_In       : out std_logic_vector(sine_vector_width-1 downto 0); --Señal senoidal para seleccionar el retardo modulable         
    Sin_Out      : out std_logic_vector(sine_vector_width-1 downto 0) --Señal senoidal para seleccionar el retardo modulable         
); 
end Sine_Generator;

architecture arch_Sine_Generator of Sine_Generator is
  
  -- Type for FSM Sin  
  type state_type is (counting_up, change_down, counting_down, change_up);
  
  --Signals
  signal state_sin_in, next_state_sin_in : state_type;
  signal state_sin_out, next_state_sin_out : state_type;
  
  signal table_index_sin_in : table_index_type;
  signal table_index_sin_out : table_index_type;
  
  signal positive_cycle_sin_in : boolean;
  signal positive_cycle_sin_out : boolean;
  signal enable_2_55Hz : std_logic;
  signal enable_5_10Hz : std_logic;

  signal counter_reg_2_55Hz, counter_next_2_55Hz : unsigned (23 downto 0);
  signal counter_reg_5_10Hz, counter_next_5_10Hz : unsigned (23 downto 0);
  
begin

  process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset_n = '1') then
        state_sin_in <= counting_up;
      elsif (enable_in = '1' and enable_2_55Hz = '1') then
        state_sin_in <= next_state_sin_in;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset_n = '1') then
        state_sin_out <= counting_up;
      elsif (enable_in = '1' and enable_5_10Hz = '1') then
        state_sin_out <= next_state_sin_out;
      end if;
    end if;
  end process;

  process(state_sin_in, table_index_sin_in)
  begin
    next_state_sin_in <= state_sin_in;
    case state_sin_in is
      when counting_up =>
        if table_index_sin_in = max_table_index then
          next_state_sin_in <= change_down;
        end if;
      when change_down =>
        next_state_sin_in <= counting_down;
      when counting_down =>
        if table_index_sin_in = 0 then
          next_state_sin_in <= change_up;
        end if;
      when others => -- change_up
        next_state_sin_in <= counting_up;
    end case;
  end process;

  process(state_sin_out, table_index_sin_out)
  begin
    next_state_sin_out <= state_sin_out;
    case state_sin_out is
      when counting_up =>
        if table_index_sin_out = max_table_index then
          next_state_sin_out <= change_down;
        end if;
      when change_down =>
        next_state_sin_out <= counting_down;
      when counting_down =>
        if table_index_sin_out = 0 then
          next_state_sin_out <= change_up;
        end if;
      when others => -- change_up
        next_state_sin_out <= counting_up;
    end case;
  end process;
  
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset_n = '1') then
        table_index_sin_in <= 0;
        positive_cycle_sin_in <= true;     
      elsif(enable_in = '1' and enable_2_55Hz = '1') then
        case next_state_sin_in is
          when counting_up =>
            table_index_sin_in <= table_index_sin_in + 1;
          when counting_down =>
            table_index_sin_in <= table_index_sin_in - 1;
          when change_up =>
            positive_cycle_sin_in <= not positive_cycle_sin_in;
          when others =>
            -- nothing to do
        end case;
      end if;
    end if;
  end process;
  
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset_n = '1') then
        table_index_sin_out <= 0;
        positive_cycle_sin_out <= true;     
      elsif(enable_in = '1' and enable_5_10Hz = '1') then
        case next_state_sin_out is
          when counting_up =>
            table_index_sin_out <= table_index_sin_out + 1;
          when counting_down =>
            table_index_sin_out <= table_index_sin_out - 1;
          when change_up =>
            positive_cycle_sin_out <= not positive_cycle_sin_out;
          when others =>
            -- nothing to do
        end case;
      end if;
    end if;
  end process;
  
  process(table_index_sin_in, positive_cycle_sin_in)
    variable table_value_sin_in: table_value_type;
  begin
    table_value_sin_in := get_table_value(table_index_sin_in);
    if (positive_cycle_sin_in) then
      Sin_In <= std_logic_vector(to_signed(table_value_sin_in,sine_vector_width));
    else
      Sin_In <= std_logic_vector(to_signed(-table_value_sin_in,sine_vector_width));
    end if;
  end process;
  
  process(table_index_sin_out, positive_cycle_sin_out)
    variable table_value_sin_out: table_value_type;
  begin
    table_value_sin_out := get_table_value(table_index_sin_out);
    if (positive_cycle_sin_out) then
      Sin_Out <= std_logic_vector(to_signed(table_value_sin_out,sine_vector_width));
    else
      Sin_Out <= std_logic_vector(to_signed(-table_value_sin_out,sine_vector_width));
    end if;
  end process;
  
  process(clk, reset_n)
  begin
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        counter_reg_2_55Hz <= (others => '0');
        counter_reg_5_10Hz <= (others => '0');
      else
        counter_reg_2_55Hz <= counter_next_2_55Hz;
        counter_reg_5_10Hz <= counter_next_5_10Hz;
      end if;
    end if;
  end process;
  
  process (counter_reg_2_55Hz)
  begin
    if (counter_reg_2_55Hz = 54) then
      enable_2_55Hz <= '1';
      counter_next_2_55Hz <= (others => '0');
    else
      enable_2_55Hz <= '0';
      counter_next_2_55Hz <= counter_reg_2_55Hz + 1;
    end if;
  end process;
  
  process (counter_reg_5_10Hz)
  begin
    if (counter_reg_5_10Hz = 28) then 
      enable_5_10Hz <= '1';
      counter_next_5_10Hz <= (others => '0');
    else
      enable_5_10Hz <= '0';
      counter_next_5_10Hz <= counter_reg_5_10Hz + 1;
    end if;
  end process;

end arch_Sine_Generator;
