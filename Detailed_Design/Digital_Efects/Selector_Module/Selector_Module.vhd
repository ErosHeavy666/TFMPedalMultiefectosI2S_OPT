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
    SW0          : in std_logic; 
    SW1          : in std_logic; 
    SW2          : in std_logic; 
    SW3          : in std_logic; 
    SW4          : in std_logic; 
    SW5          : in std_logic; 
    SW6          : in std_logic; 
    SW7          : in std_logic; 
    FBK_selector : out std_logic_vector(g_total_feedback_delays-1 downto 0); 
    OUT_selector : out std_logic_vector(g_total_global_effects-1 downto 0)
);
end Selector_Module;

------------------
-- Architecture --
------------------
architecture arch_Selector_Module of Selector_Module is
  
  -- Signals for make discrete inputs into a vector type
  signal SW_Vector : std_logic_vector(g_total_number_switches-1 downto 0);
      
  -- Signals for Output generation
  signal FBK_selector_reg, FBK_selector_next : std_logic_vector(g_total_delays_effects-1 downto 0);
  signal OUT_selector_reg, OUT_selector_next : std_logic_vector(g_total_global_effects-1 downto 0);
  
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if(reset_n = '1') then
        FBK_selector_reg <= (others => '0');
        OUT_selector_reg <= (others => '0');
      elsif(enable_in = '1')then
        FBK_selector_reg <= FBK_selector_next;
        OUT_selector_reg <= OUT_selector_next;
      end if;
    end if;  
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for SW_Vector:
  -------------------------------------------------------------------------------------------------------------------------------
  SW_Vector <= (SW7 & SW6 & SW5 & SW4 & SW3 & SW2 & SW1 & SW0);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for FBK_Selector:
  -------------------------------------------------------------------------------------------------------------------------------
  FBK_selector_next <= (SW2 & SW1 & SW0);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for Out_selector:
  -------------------------------------------------------------------------------------------------------------------------------
  Out_selector_next <= ES_line_active         when (SW_Vector = "00000000") else
                       Feedback_line_active   when (SW_Vector = "00000001" or 
                                                    SW_Vector = "00000010" or 
                                                    SW_Vector = "00000100") else
                       Looper_line_active     when (SW_Vector = "00011000") else
                       Compressor_line_active when (SW_Vector = "00100000") else
                       Overdrive_line_active  when (SW_Vector = "01000000") else
                       Filter_line_active     when (SW_Vector = "10000000") else
                       Disabled_output_line;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  FBK_selector <= FBK_selector_reg;
  Out_selector <= Out_selector_reg;
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Selector_Module;