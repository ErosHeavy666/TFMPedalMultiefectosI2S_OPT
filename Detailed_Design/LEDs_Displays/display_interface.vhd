----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_letters.all;

------------
-- Entity --
------------
entity display_interface is 
  Port ( 
    clk           : in std_logic;
    n_reset       : in std_logic;
    i_play_enable : in std_logic;
    o_seg         : out std_logic_vector(6 downto 0);
    o_an          : out std_logic_vector(7 downto 0)
  );
end display_interface;

------------------
-- Architecture --
------------------
architecture arch_display_interface of display_interface is
    
  -- Signals
  signal s_disp_rate : std_logic;  
  signal s_display_state : std_logic_vector(1 downto 0);
  signal r_curr_display, s_curr_display : unsigned(2 downto 0);
  signal r_display1, r_display2, r_display3, r_display4, r_display5, r_display6, r_display7, r_display8 : std_logic_vector(6 downto 0);
  signal s_display1, s_display2, s_display3, s_display4, s_display5, s_display6, s_display7, s_display8 : std_logic_vector(6 downto 0);
  
  -- Components
  component display_counter is
    port (  
      clk         : in std_logic;
      n_reset     : in std_logic;
      o_disp_rate : out std_logic
    );
  end component; 

  component display_states is
    port (  
      clk             : in std_logic;
      n_reset         : in std_logic;
      i_play_enable   : in std_logic;
      o_display_state : out std_logic_vector(1 downto 0)
    );
  end component;
     
begin
    
    -- Display counter instance
    unit_display_counter : display_counter 
      port map(
        clk         => clk,
        n_reset     => n_reset,
        o_disp_rate => s_disp_rate
    );
   
   -- Display states instance
   unit_display_states : display_states 
    port map(  
      clk             => clk,
      n_reset         => n_reset,
      i_play_enable   => i_play_enable,
      o_display_state => s_display_state
    );
       
    -- Register process:
    r_display_interface_process : process(clk)
    begin
      if (rising_edge(clk)) then
        if (n_reset = '0') then
          r_curr_display <= (others => '0');
          ----------------------------------
          r_display1 <= (others => '0');
          r_display2 <= (others => '0');
          r_display3 <= (others => '0');
          r_display4 <= (others => '0');
          r_display5 <= (others => '0');
          r_display6 <= (others => '0');
          r_display7 <= (others => '0');
          r_display8 <= (others => '0');
        else
          r_curr_display <= s_curr_display;         
          ----------------------------------
          r_display1 <= s_display1;
          r_display2 <= s_display2;
          r_display3 <= s_display3;
          r_display4 <= s_display4;
          r_display5 <= s_display5;
          r_display6 <= s_display6;
          r_display7 <= s_display7;
          r_display8 <= s_display8;
        end if;
      end if;
    end process;   
    
    -- Combinational logic process:
    ------------------------------------------------------------------
    s_curr_display <= r_curr_display + 1 when (s_disp_rate = '1') else 
                      r_curr_display;
    ------------------------------------------------------------------
    process(s_display_state)
    begin
      case s_display_state is
        when "01" => -- "pause"
            s_display1 <= off;
            s_display2 <= e;
            s_display3 <= s;
            s_display4 <= u;
            s_display5 <= a;
            s_display6 <= p;
            s_display7 <= off;
            s_display8 <= off;
        when "11" => -- "play"
            s_display1 <= off;
            s_display2 <= off;
            s_display3 <= y;
            s_display4 <= a;
            s_display5 <= l;
            s_display6 <= p;
            s_display7 <= off;
            s_display8 <= off;
        when others => -- "error"                    
            s_display1 <= off;
            s_display2 <= r;
            s_display3 <= o;
            s_display4 <= r;
            s_display5 <= r;
            s_display6 <= e;
            s_display7 <= off;
            s_display8 <= off;
        end case;
     end process;
    -----------------------------------------------------------
    -- Output process:
     ---------------------------------------------------------- 
    -- Switches between different displays    
    with r_curr_display select 
      o_an <= "01111111" when "000",
              "10111111" when "001",
              "11011111" when "010",
              "11101111" when "011",
              "11110111" when "100",
              "11111011" when "101",
              "11111101" when "110",
              "11111110" when "111",
              "11111111" when others;
     ---------------------------------------------------------- 
     -- Shows the right letter depending on the current display           
     with r_curr_display select 
       o_seg <= r_display1 when "000",
                r_display2 when "001",
                r_display3 when "010",
                r_display4 when "011",
                r_display5 when "100",
                r_display6 when "101",
                r_display7 when "110",
                r_display8 when others;
     ---------------------------------------------------------- 
end arch_display_interface;