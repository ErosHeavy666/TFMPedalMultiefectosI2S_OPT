----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Control_Selector_Module is
  port ( 
    clk           : in std_logic; 
    reset_n       : in std_logic; 
    enable_in     : in std_logic; 
    BTNC          : in std_logic;
    BTNU          : in std_logic; 
    BTNL          : in std_logic; 
    BTNR          : in std_logic;     
    BTND          : in std_logic;  
    BTNL_selector : out std_logic_vector(delays_effects_binary-1 downto 0);
    BTNR_selector : out std_logic_vector(delays_effects_binary-1 downto 0);
    BTNU_selector : out std_logic_vector(gain_effects_binary-1 downto 0);
    BTNC_selector : out std_logic_vector(gain_effects_binary-1 downto 0);
    BTND_selector : out std_logic_vector(gain_effects_binary-1 downto 0)
);
end Control_Selector_Module;

------------------
-- Architecture --
------------------
architecture arch_Control_Selector_Module of Control_Selector_Module is
  
  -- Signals for register the input buttons
  signal BTNC_reg, BTNC_next : std_logic;
  signal BTNU_reg, BTNU_next : std_logic;
  signal BTNL_reg, BTNL_next : std_logic;
  signal BTNR_reg, BTNR_next : std_logic;
  signal BTND_reg, BTND_next : std_logic;
   
  -- Signals for Rising_Edge detection 
  signal BTNC_re_reg, BTNC_re_next : std_logic;
  signal BTNU_re_reg, BTNU_re_next : std_logic;
  signal BTNL_re_reg, BTNL_re_next : std_logic;
  signal BTNR_re_reg, BTNR_re_next : std_logic;
  signal BTND_re_reg, BTND_re_next : std_logic;
  
  -- Signals for Selector Delay and Gain 
  signal BTNL_selector_reg,  BTNL_selector_next : unsigned(delays_effects_binary-1 downto 0);
  signal BTNR_selector_reg,  BTNR_selector_next : unsigned(delays_effects_binary-1 downto 0);
  signal BTNU_selector_reg,  BTNU_selector_next : unsigned(gain_effects_binary-1 downto 0);
  signal BTNC_selector_reg,  BTNC_selector_next : unsigned(gain_effects_binary-1 downto 0);
  signal BTND_selector_reg,  BTND_selector_next : unsigned(gain_effects_binary-1 downto 0);
  
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin
    if (rising_edge(clk)) then --MCLK
      if(reset_n = '1') then
        BTNC_reg <= '0';
        BTNU_reg <= '0';
        BTNL_reg <= '0';
        BTNR_reg <= '0';
        BTND_reg <= '0';
        BTNC_re_reg <= '0';
        BTNU_re_reg <= '0';
        BTNL_re_reg <= '0';
        BTNR_re_reg <= '0';
        BTND_re_reg <= '0';
        BTNL_selector_reg <= (others => '0');
        BTNR_selector_reg <= (others => '0');
        BTNU_selector_reg <= (others => '0');
        BTNC_selector_reg <= (others => '0');
        BTND_selector_reg <= (others => '0');
      elsif(enable_in = '1')then
        BTNC_reg <= BTNC_next;
        BTNU_reg <= BTNU_next;
        BTNL_reg <= BTNL_next;
        BTNR_reg <= BTNR_next;
        BTND_reg <= BTND_next;
        BTNC_re_reg <= BTNC_re_next;
        BTNU_re_reg <= BTNU_re_next;
        BTNL_re_reg <= BTNL_re_next;
        BTNR_re_reg <= BTNR_re_next;
        BTND_re_reg <= BTND_re_next;
        BTNL_selector_reg <= BTNL_selector_next;
        BTNR_selector_reg <= BTNR_selector_next;
        BTNU_selector_reg <= BTNU_selector_next;
        BTNC_selector_reg <= BTNC_selector_next;
        BTND_selector_reg <= BTND_selector_next;
      end if;
    end if;  
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for Register the Button Input
  -------------------------------------------------------------------------------------------------------------------------------
  BTNC_next <= BTNC;
  BTNU_next <= BTNU;
  BTNL_next <= BTNL;
  BTNR_next <= BTNR;
  BTND_next <= BTND;  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for Rising_Edge flag detection
  -------------------------------------------------------------------------------------------------------------------------------
  BTNC_re_next <= '1' when (BTNC_reg = '0' and BTNC_next = '1') else '0';  
  BTNU_re_next <= '1' when (BTNU_reg = '0' and BTNU_next = '1') else '0';  
  BTNL_re_next <= '1' when (BTNL_reg = '0' and BTNL_next = '1') else '0';  
  BTNR_re_next <= '1' when (BTNR_reg = '0' and BTNR_next = '1') else '0';  
  BTND_re_next <= '1' when (BTND_reg = '0' and BTND_next = '1') else '0';  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process for Change the Gain/Delay State. One RE detection --> +1
  -------------------------------------------------------------------------------------------------------------------------------
  BTNL_selector_next <= BTNL_selector_reg + 1 when (BTNL_re_reg = '1') else BTNL_selector_reg;
  BTNR_selector_next <= BTNR_selector_reg + 1 when (BTNR_re_reg = '1') else BTNR_selector_reg;
  BTNU_selector_next <= BTNU_selector_reg + 1 when (BTNU_re_reg = '1') else BTNU_selector_reg;
  BTNC_selector_next <= BTNC_selector_reg + 1 when (BTNC_re_reg = '1') else BTNC_selector_reg;
  BTND_selector_next <= BTND_selector_reg + 1 when (BTND_re_reg = '1') else BTND_selector_reg;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------
  BTNL_selector <= std_logic_vector(BTNL_selector_reg);
  BTNR_selector <= std_logic_vector(BTNR_selector_reg);
  BTNU_selector <= std_logic_vector(BTNU_selector_reg);
  BTNC_selector <= std_logic_vector(BTNC_selector_reg);
  BTND_selector <= std_logic_vector(BTND_selector_reg);
  -------------------------------------------------------------------------------------------------------------------------------
end arch_Control_Selector_Module;