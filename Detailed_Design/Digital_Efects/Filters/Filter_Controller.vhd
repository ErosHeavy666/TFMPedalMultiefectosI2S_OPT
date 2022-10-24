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
entity Filter_Controller is
  port(                                    
    clk               : in std_logic;                
    reset_n           : in std_logic;               
    M12               : out std_logic_vector(3 downto 0); 
    M3                : out std_logic;   
    data_in_ready     : in std_logic;       
    data_out_ready    : out std_logic                     
  );
end Filter_Controller;

architecture Filter_Controller_arch of Filter_Controller is
  
  -- Signals       
  signal state_cnt_reg, state_cnt_next: unsigned(3 downto 0); 
                                          
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process: Counter that stims the state of counter
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk) 
  begin
    if rising_edge(clk) then 
      if(reset_n = '1')then
         state_cnt_reg <= (others => '0');       
      else
         state_cnt_reg <= state_cnt_next;      
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Counter start_up and controller set-up
  -------------------------------------------------------------------------------------------------------------------------------
  process(state_cnt_reg, data_in_ready)
  begin
    if (state_cnt_reg = 0) then
      if(data_in_ready = '1') then
        state_cnt_next <= state_cnt_reg + 1;
      else
        state_cnt_next <= state_cnt_reg;
      end if;
    else
      state_cnt_next <= state_cnt_reg + 1;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------    
  data_out_ready <= '1' when (state_cnt_reg = 13) else '0';
  M12 <= std_logic_vector(state_cnt_reg);
  M3 <= '0' when (state_cnt_reg = 0 or state_cnt_reg = 1 or state_cnt_reg = 2) else '1';
  -------------------------------------------------------------------------------------------------------------------------------    
end Filter_Controller_arch;