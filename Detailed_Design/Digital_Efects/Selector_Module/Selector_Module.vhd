----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Selector_Module is
  port ( 
    clk          : in std_logic; --MCLK                                                
    reset_n      : in std_logic; --Reset síncrono a nivel alto del sistema global    
    enable_in    : in std_logic; --Enable proporcionado por el i2s2             
    SW0          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW1          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW2          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW3          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW4          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW5          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW6          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW7          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW8          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    SW9          : in std_logic; --Switches de entrada para selección del modo de funcionamiento
    GNL_selector : out std_logic_vector(total_delays_effects-1 downto 0); -- Gain, N, Logic Selector
    Out_selector : out std_logic_vector(total_normal_effects-1 downto 0) -- Out Selector
);
end Selector_Module;

------------------
-- Architecture --
------------------
architecture arch_Selector_Module of Selector_Module is
    
  -- Signals for Output generation
  signal GNL_selector_reg, GNL_selector_next : std_logic_vector(total_delays_effects-1 downto 0);
  signal Out_selector_reg, Out_selector_next : std_logic_vector(total_normal_effects-1 downto 0);
  
  -- Signals for make discrete inputs into a vector type
  signal SW_Vector : std_logic_vector(total_number_switches-1 downto 0);
  
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if(reset_n = '1') then
        GNL_selector_reg <= (others => '0');
        Out_selector_reg <= (others => '0');
      elsif(enable_in = '1')then
        GNL_selector_reg <= GNL_selector_next;
        Out_selector_reg <= Out_selector_next;
      end if;
    end if;  
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for SW_Vector:
  -------------------------------------------------------------------------------------------------------------------------------
  SW_Vector <= (SW9 & SW8 & SW7 & SW6 & SW5 & SW4 & SW3 & SW2 & SW1 & SW0);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for GNL_Selector:
  -------------------------------------------------------------------------------------------------------------------------------
  GNL_selector_next <= Delay_line_active   when (SW_Vector = "0000000001") else
                       Chorus_line_active  when (SW_Vector = "0000000010") else
                       Reverb_line_active  when (SW_Vector = "0000000100") else
                       Vibrato_line_active when (SW_Vector = "0000001000") else
                       Eco_line_active     when (SW_Vector = "0000010000") else
                       Disabled_delay_line;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for Out_selector:
  -------------------------------------------------------------------------------------------------------------------------------
  Out_selector_next <= ES_line_active         when (SW_Vector = "0000000000") else
                       Feedback_line_active   when (SW_Vector = "0000000001" or 
                                                    SW_Vector = "0000000010" or 
                                                    SW_Vector = "0000000100" or 
                                                    SW_Vector = "0000001000" or 
                                                    SW_Vector = "0000010000") else
                       Looper_line_active     when (SW_Vector = "0001100000") else
                       Compressor_line_active when (SW_Vector = "0010000000") else
                       Overdrive_line_active  when (SW_Vector = "0100000000") else
                       Filter_line_active     when (SW_Vector = "1000000000") else
                       Disabled_output_line;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  GNL_selector <= GNL_selector_reg;
  Out_selector <= Out_selector_reg;
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Selector_Module;