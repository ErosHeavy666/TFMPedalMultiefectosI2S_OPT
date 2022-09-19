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
entity display_states is
  port (  
    clk             : in std_logic;
    n_reset         : in std_logic;
    i_play_enable   : in std_logic;
    o_display_state : out std_logic_vector(1 downto 0)
  );
end display_states;

------------------
-- Architecture --
------------------
architecture arch_display_states of display_states is
  
  -- Types
  type global_states is (PLAY, PAUSE, STOP);
  signal r_state, s_state : global_states;   
    
  -- Signals
  signal r_display_state, s_display_state : std_logic_vector(1 downto 0);
    
begin

  -- Register process:
  r_display_counter_process : process(clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
        r_state <= STOP;
        r_display_state <= (others => '0');
      else
        r_state <= s_state;
        r_display_state <= s_display_state;
      end if;
    end if;
  end process;
    
  -- Combinational logic process:
  change_state_logic : process(r_state, i_play_enable)
  begin
    -- Default value
    s_state <= r_state;
    case r_state is
      ------------
      when STOP => 
        if (i_play_enable = '1') then
            s_state <= PLAY;
        else
            s_state <= PAUSE;
        end if;
      ------------
      when PLAY =>
        if (i_play_enable = '0') then
            s_state <= PAUSE;
        end if;
      ------------
      when PAUSE =>
        if (i_play_enable = '1') then
            s_state <= PLAY;
        end if;
      ------------
      when others => null;
      ------------
    end case;
  end process;
  ---------------------------------------------------------------
  state_output_logic : process(r_state)
  begin    
    case r_state is
      ------------
      when STOP => 
        s_display_state <= "00";
      ------------
      when PLAY =>
        s_display_state <= "11";
      ------------
      when PAUSE =>
        s_display_state <= "01";
      ------------
      when others =>
        s_display_state <= "00";
      ------------
    end case;
  end process;

  -- Output process:
  o_display_state <= r_display_state; 
  
end arch_display_states;