----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_digital_effects.all;

------------
-- Entity --
------------
entity digital_efects is
  generic(
    d_width    : integer := 16);
  port( 
    clk        : in std_logic;
    reset_n    : in std_logic;
    enable_in  : in std_logic; 
    enable_out : out std_logic;
    BTNR       : in std_logic;
    BTNC       : in std_logic; 
    BTNL       : in std_logic; 
    BTND       : in std_logic; 
    SW0        : in std_logic;
    SW1        : in std_logic;
    SW2        : in std_logic;
    SW3        : in std_logic;
    SW4        : in std_logic;
    SW5        : in std_logic;
    SW6        : in std_logic;
    SW7        : in std_logic;
    SW8        : in std_logic;
    SW9        : in std_logic;
    SW10       : in std_logic;
    SW11       : in std_logic;
    SW12       : in std_logic;
    SW13       : in std_logic;
    SW14       : in std_logic;
    l_data_in  : in std_logic_vector(d_width-1 downto 0);     
    r_data_in  : in std_logic_vector(d_width-1 downto 0); 
    l_data_out : out std_logic_vector(d_width-1 downto 0);
    r_data_out : out std_logic_vector(d_width-1 downto 0)  
  );
end Digital_Efects;

------------------
-- Architecture --
------------------
architecture arch_digital_efects of digital_efects is

  -- Signals to enable each effect
  signal enable_in_es : std_logic;
  signal enable_in_delay : std_logic;
  signal enable_in_chorus : std_logic;
  signal enable_in_vibrato : std_logic;
  signal enable_in_reverb : std_logic;
  signal enable_in_eco : std_logic;
  signal enable_in_compressor : std_logic;
  signal enable_in_overdrive : std_logic;
  signal enable_in_looper : std_logic;
  signal enable_in_bankfilter : std_logic;
  signal enable_in_config_reverb : std_logic;

  -- Signals to redirect the i2s data
  signal r_data_out_es, l_data_out_es, r_data_in_es, l_data_in_es : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_delay, l_data_out_delay, r_data_in_delay, l_data_in_delay : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_chorus, l_data_out_chorus, r_data_in_chorus, l_data_in_chorus : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_vibrato, l_data_out_vibrato, r_data_in_vibrato, l_data_in_vibrato : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_reverb, l_data_out_reverb, r_data_in_reverb, l_data_in_reverb : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_eco, l_data_out_eco, r_data_in_eco, l_data_in_eco : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_compressor, l_data_out_compressor, r_data_in_compressor, l_data_in_compressor : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_overdrive, l_data_out_overdrive, r_data_in_overdrive, l_data_in_overdrive : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_looper, l_data_out_looper, r_data_in_looper, l_data_in_looper : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_bankfilter, l_data_out_bankfilter, r_data_in_bankfilter, l_data_in_bankfilter : std_logic_vector(d_width-1 downto 0);
  signal r_data_out_config_reverb, l_data_out_config_reverb, r_data_in_config_reverb, l_data_in_config_reverb : std_logic_vector(d_width-1  downto 0);

begin
  
  
  -- Instance for ES Difital Efect component
  Unit_EfectES : EfectoES 
    generic map(d_width => 16)
    port map(
     clk => clk,
     reset_n    => reset_n, 
     enable_in  => enable_in_es,
     l_data_in  => l_data_in_es, 
     l_data_out => l_data_out_es, 
     r_data_in  => r_data_in_es, 
     r_data_out => r_data_out_es,
     enable_out => open
  ); 
  
  -- Instance for DELAY Difital Efect component
  Unit_EfectDELAY : EfectoDELAY 
    generic map(n => 4000, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_delay,
       l_data_in  => l_data_in_delay, 
       l_data_out => l_data_out_delay, 
       r_data_in  => r_data_in_delay, 
       r_data_out => r_data_out_delay,
       enable_out => open
  ); 
  
  -- Instance for CHORUS Difital Efect component
  Unit_EfectCHORUS : EfectoCHORUS
    generic map(n => 1000, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_chorus,
       l_data_in  => l_data_in_chorus, 
       l_data_out => l_data_out_chorus, 
       r_data_in  => r_data_in_chorus, 
       r_data_out => r_data_out_chorus,
       enable_out => open
  );
  
  -- Instance for VIBRATO Difital Efect component
  Unit_EfectVIBRATO : EfectoVIBRATO
    generic map(n => 500, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_vibrato,
       l_data_in  => l_data_in_vibrato, 
       l_data_out => l_data_out_vibrato, 
       r_data_in  => r_data_in_vibrato, 
       r_data_out => r_data_out_vibrato,
       enable_out => open
  );
  
  Unit_EfectREVERB : EfectoREVERB
    generic map(n => 500, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_reverb,
       l_data_in  => l_data_in_reverb, 
       l_data_out => l_data_out_reverb, 
       r_data_in  => r_data_in_reverb, 
       r_data_out => r_data_out_reverb,
       enable_out => open
  );
  
  Unit_EfectECO : EfectoECO
    generic map(n => 5000, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_eco,
       l_data_in  => l_data_in_eco, 
       l_data_out => l_data_out_eco, 
       r_data_in  => r_data_in_eco, 
       r_data_out => r_data_out_eco,
       enable_out => open
  );
  
  Unit_EfectCOMPRESSOR : EfectCOMPRESSOR  
    generic map(d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_compressor,
       l_data_in  => l_data_in_compressor, 
       l_data_out => l_data_out_compressor, 
       r_data_in  => r_data_in_compressor, 
       r_data_out => r_data_out_compressor,
       enable_out => open
  ); 
  
  Unit_EfectOVERDRIVE : efecto_overdrive  
    generic map(g_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_overdrive,
       l_data_in  => l_data_in_overdrive, 
       l_data_out => l_data_out_overdrive, 
       r_data_in  => r_data_in_overdrive, 
       r_data_out => r_data_out_overdrive
  ); 
  
  Unit_EfectLOOPER : EfectoLOOPER 
    generic map(d_width => 16, d_deep => 19)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       SW13       => SW13,
       enable_in  => enable_in_looper,
       SW5        => SW5,
       SW6        => SW6,
       l_data_in  => l_data_in_looper, 
       l_data_out => l_data_out_looper, 
       r_data_in  => r_data_in_looper, 
       r_data_out => r_data_out_looper,
       enable_out => open
  ); 
  
  Unit_EfectBANKFILTER : EfectoBANKFILTER  
    generic map(d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_bankfilter,
       SW14       => SW14,
       l_data_in  => l_data_in_bankfilter, 
       l_data_out => l_data_out_bankfilter, 
       r_data_in  => r_data_in_bankfilter, 
       r_data_out => r_data_out_bankfilter,
       enable_out => open
  ); 
  
  Unit_EfectREVERB_PARAMETRIZADO : EfectoREVERB_PARAMETRIZADO
    generic map(n1 => 1500, d_width => 16)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       enable_in  => enable_in_config_reverb,
       BTNC       => BTNC,
       BTNL       => BTNL,
       BTND       => BTND,
       BTNR       => BTNR,
       l_data_in  => l_data_in_config_reverb, 
       l_data_out => l_data_out_config_reverb, 
       r_data_in  => r_data_in_config_reverb, 
       r_data_out => r_data_out_config_reverb,
       enable_out => open
  );

  -- Combinational logic process: Effect Selector (Enable + Input Right/Left_Data)
  --------
  -- ES --
  --------
  -- Enable
  enable_in_es <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                  SW10 = '0'  and SW11 = '0' and SW12 = '0') else '0';
  -- Left_Data                                  
  l_data_in_es <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                  SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_es <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                  SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  ----------- || ----------------------- 
  -- DELAY -- || -- OVERDRIVE + DELAY -- 
  ----------- || ----------------------- 
  -- Enable
  enable_in_delay <= enable_in when ((SW0  = '1'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                      SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                      SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                     (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                      SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                      SW10 = '0'  and SW11 = '1' and SW12 = '0')) else '0';  
  -- Left_Data                                  
  l_data_in_delay <= l_data_in when            (SW0  = '1'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                SW10 = '0'  and SW11 = '0' and SW12 = '0') else
                     l_data_out_overdrive when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                SW10 = '0'  and SW11 = '1' and SW12 = '0') else (others => '0');            
  -- Right_Data                                
  r_data_in_delay <= r_data_in when            (SW0  = '1'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                SW10 = '0'  and SW11 = '0' and SW12 = '0') else
                     r_data_out_overdrive when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                SW10 = '0'  and SW11 = '1' and SW12 = '0') else (others => '0');    
  ------------ || ------------------------- 
  -- CHORUS -- || -- COMPRESSOR + CHORUS -- 
  ------------ || -------------------------
  -- Enable
  enable_in_chorus <= enable_in when ((SW0  = '0'  and SW1  = '1' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                      (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '1')) else '0';  
  -- Left_Data                                  
  l_data_in_chorus <= l_data_in             when (SW0  = '0'  and SW1  = '1' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                  SW10 = '0'  and SW11 = '0' and SW12 = '0') else 
                      l_data_out_compressor when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                  SW10 = '0'  and SW11 = '0' and SW12 = '1') else (others => '0');                
  -- Right_Data                                
  r_data_in_chorus <= r_data_in             when (SW0  = '0'  and SW1  = '1' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                  SW10 = '0'  and SW11 = '0' and SW12 = '0') else 
                      r_data_out_compressor when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                                  SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                                  SW10 = '0'  and SW11 = '0' and SW12 = '1') else (others => '0');    
  ------------
  -- REVERB --
  ------------
  -- Enable
  enable_in_reverb <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '1' and SW3 = '0' and SW4 = '0' and 
                                      SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                      SW10 = '0'  and SW11 = '0' and SW12 = '0') else '0';  
  -- Left_Data                                  
  l_data_in_reverb <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '1' and SW3 = '0' and SW4 = '0' and 
                                      SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                      SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_reverb <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '1' and SW3 = '0' and SW4 = '0' and 
                                      SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                      SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  ---------
  -- ECO --
  ---------
  -- Enable
  enable_in_eco <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '1' and SW4 = '0' and 
                                   SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                   SW10 = '0'  and SW11 = '0' and SW12 = '0') else '0';  
  -- Left_Data                                  
  l_data_in_eco <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '1' and SW4 = '0' and 
                                   SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                   SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_eco <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '1' and SW4 = '0' and 
                                   SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                   SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -------------
  -- VIBRATO --
  -------------
  -- Enable
  enable_in_vibrato <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '1' and 
                                       SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') else '0';  
  -- Left_Data                                  
  l_data_in_vibrato <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '1' and 
                                       SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_vibrato <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '1' and 
                                       SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  ------------
  -- LOOPER --
  ------------
  -- Enable
  enable_in_looper <= enable_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') or
                                      (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '1' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0')) else '0';
  -- Left_Data                                  
  l_data_in_looper <= l_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') or
                                      (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '1' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0')) else (others => '0');
  -- Right_Data                                
  r_data_in_looper <= r_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0') or
                                      (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                       SW5  = '1'  and SW6  = '1' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                       SW10 = '0'  and SW11 = '0' and SW12 = '0')) else (others => '0');
  ----------------
  -- BANKFILTER --
  ----------------
  -- Enable
  enable_in_bankfilter <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '1' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') else '0';  
  -- Left_Data                                  
  l_data_in_bankfilter <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '1' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_bankfilter <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '1' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') else (others => '0');
  --------------- || -----------------------
  -- OVERDRIVE -- || -- OVERDRIVE + DELAY --
  --------------- || -----------------------
  -- Enable
  enable_in_overdrive <= enable_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '1' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                         (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '1' and SW12 = '0')) else '0';
  -- Left_Data                                  
  l_data_in_overdrive <= l_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '1' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                         (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '1' and SW12 = '0')) else (others => '0');
  -- Right_Data                                
  r_data_in_overdrive <= r_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '1' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                         (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                          SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                          SW10 = '0'  and SW11 = '1' and SW12 = '0')) else (others => '0');
  ---------------- || ------------------------- 
  -- COMPRESSOR -- || -- COMPRESSOR + CHORUS -- 
  ---------------- || ------------------------- 
  -- Enable
  enable_in_compressor <= enable_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '1' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                          (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '1')) else '0';  
  -- Left_Data                                  
  l_data_in_compressor <= l_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '1' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                          (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '1')) else (others => '0');
  -- Right_Data                                
  r_data_in_compressor <= r_data_in when ((SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '1' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                          (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '1')) else (others => '0');
  -------------------
  -- CONFIG_REVERB --
  -------------------
  -- Enable
  enable_in_config_reverb <= enable_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                             SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                             SW10 = '1'  and SW11 = '0' and SW12 = '0') else '0';  
  -- Left_Data                                  
  l_data_in_config_reverb <= l_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                             SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                             SW10 = '1'  and SW11 = '0' and SW12 = '0') else (others => '0');
  -- Right_Data                                
  r_data_in_config_reverb <= r_data_in when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                             SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                             SW10 = '1'  and SW11 = '0' and SW12 = '0') else (others => '0');

  
  -- Output process: Effect Selector (Output Right/Left_Data)
  -- Left_Data
                ------------------------------------------------------------------------------------------------                     
  l_data_out <= l_data_out_es when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                    SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                    SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- ES
                ------------------------------------------------------------------------------------------------                     
                l_data_out_delay when ((SW0  = '1'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                       (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '1' and SW12 = '0')) else -- DELAY
                ------------------------------------------------------------------------------------------------                     
                l_data_out_chorus when ((SW0  = '0'  and SW1  = '1' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                        (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '1')) else -- CHORUS
                ------------------------------------------------------------------------------------------------                     
                l_data_out_reverb when (SW0  = '0'  and SW1  = '0' and SW2  = '1' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- REVERB
                ------------------------------------------------------------------------------------------------                     
                l_data_out_eco when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '1' and SW4 = '0' and 
                                     SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                     SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- ECO
                ------------------------------------------------------------------------------------------------                     
                l_data_out_vibrato when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '1' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- VIBRATO
                ------------------------------------------------------------------------------------------------                     
                l_data_out_looper when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '1'  and SW6  = '1' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- LOOPER
                ------------------------------------------------------------------------------------------------                     
                l_data_out_bankfilter when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                            SW5  = '0'  and SW6  = '0' and SW7  = '1' and SW8 = '0' and SW9 = '0' and 
                                            SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- BANKFILTER
                ------------------------------------------------------------------------------------------------                     
                l_data_out_overdrive when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '1' and SW9 = '0' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- OVERDRIVE
                ------------------------------------------------------------------------------------------------                     
                l_data_out_compressor when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                            SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '1' and 
                                            SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- COMPRESSOR
                ------------------------------------------------------------------------------------------------                     
                l_data_out_config_reverb when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                               SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                               SW10 = '1'  and SW11 = '0' and SW12 = '0') else  -- CONFIG_REVERB
                ------------------------------------------------------------------------------------------------    
                (others => '0'); -- STOP   
                ------------------------------------------------------------------------------------------------    
  -- Right_Data                                   
                ------------------------------------------------------------------------------------------------                     
  r_data_out <= r_data_out_es when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                    SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                    SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- ES
                ------------------------------------------------------------------------------------------------                     
                r_data_out_delay when ((SW0  = '1'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                       (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '1' and SW12 = '0')) else -- DELAY
                ------------------------------------------------------------------------------------------------                     
                r_data_out_chorus when ((SW0  = '0'  and SW1  = '1' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '0') or 
                                        (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '1')) else -- CHORUS
                ------------------------------------------------------------------------------------------------                     
                r_data_out_reverb when (SW0  = '0'  and SW1  = '0' and SW2  = '1' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- REVERB
                ------------------------------------------------------------------------------------------------                     
                r_data_out_eco when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '1' and SW4 = '0' and 
                                     SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                     SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- ECO
                ------------------------------------------------------------------------------------------------                     
                r_data_out_vibrato when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '1' and 
                                         SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                         SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- VIBRATO
                ------------------------------------------------------------------------------------------------                     
                r_data_out_looper when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                        SW5  = '1'  and SW6  = '1' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                        SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- LOOPER
                ------------------------------------------------------------------------------------------------                     
                r_data_out_bankfilter when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                            SW5  = '0'  and SW6  = '0' and SW7  = '1' and SW8 = '0' and SW9 = '0' and 
                                            SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- BANKFILTER
                ------------------------------------------------------------------------------------------------                     
                r_data_out_overdrive when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                           SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '1' and SW9 = '0' and 
                                           SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- OVERDRIVE
                ------------------------------------------------------------------------------------------------                     
                r_data_out_compressor when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                            SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '1' and 
                                            SW10 = '0'  and SW11 = '0' and SW12 = '0') else -- COMPRESSOR
                ------------------------------------------------------------------------------------------------                     
                r_data_out_config_reverb when (SW0  = '0'  and SW1  = '0' and SW2  = '0' and SW3 = '0' and SW4 = '0' and 
                                               SW5  = '0'  and SW6  = '0' and SW7  = '0' and SW8 = '0' and SW9 = '0' and 
                                               SW10 = '1'  and SW11 = '0' and SW12 = '0') else  -- CONFIG_REVERB
                ------------------------------------------------------------------------------------------------    
                (others => '0'); -- STOP   
                ------------------------------------------------------------------------------------------------ 

end arch_digital_efects;