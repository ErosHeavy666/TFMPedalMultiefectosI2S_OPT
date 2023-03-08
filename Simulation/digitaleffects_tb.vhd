----------------------------------
-- Engineer: Eros García Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

------------
-- Entity --
------------
entity tb_digitaleffects is
end tb_digitaleffects;

------------------
-- Architecture --
------------------
architecture tb_digitaleffects_arch of tb_digitaleffects is

  -- Constants
  constant n                     : integer := 5000; 
  constant width                 : integer := 16;   
  constant total_number_switches : integer := 10;
  constant total_delays_effects  : integer := 5;    
  constant total_normal_effects  : integer := 6;   
  
  constant clk_period : time := 45.35us;
  constant haha_duration : time := 1000ms;
  
   -- Signals
  signal clk          : std_logic := '1'; 
  signal reset_n      : std_logic := '0'; 
  signal enable_in    : std_logic := '0'; 
  signal enable_out   : std_logic := '0';
  signal SW0          : std_logic := '0'; 
  signal SW1          : std_logic := '0';  
  signal SW2          : std_logic := '0';  
  signal SW3          : std_logic := '0';  
  signal SW4          : std_logic := '0';  
  signal SW5          : std_logic := '0';  
  signal SW6          : std_logic := '0';  
  signal SW7          : std_logic := '0';  
  signal SW8          : std_logic := '0';  
  signal SW9          : std_logic := '0';  
  signal SW13         : std_logic := '0';  
  signal SW14         : std_logic := '0'; 
  signal sample_in    : std_logic_vector(width-1 downto 0) := (others => '0');
  signal l_sample_out : std_logic_vector(width-1 downto 0) := (others => '0');
  signal r_sample_out : std_logic_vector(width-1 downto 0) := (others => '0');
  
  -- Files
  file data_in_file: text open read_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT_FIFO\MATLAB\haha_sample_in_16b.dat";
  file l_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT_FIFO\MATLAB\l_sample_out_re_arch_v1_FIFO.dat";
  file r_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT_FIFO\MATLAB\r_sample_out_re_arch_v1_FIFO.dat";
  
  -- Components
  component digital_effects is
    port( 
      clk          : in std_logic; -- MCLK                                                
      reset_n      : in std_logic; -- Reset síncrono a nivel alto del sistema global    
      enable_in    : in std_logic; -- Enable proporcionado por el i2s2         
      SW0          : in std_logic; -- Delay
      SW1          : in std_logic; -- Chorus
      SW2          : in std_logic; -- Reverb
      SW3          : in std_logic; -- Vibrato
      SW4          : in std_logic; -- Eco
      SW5          : in std_logic; -- Looper Write
      SW6          : in std_logic; -- Looper Read
      SW7          : in std_logic; -- Compressor
      SW8          : in std_logic; -- Overdrive
      SW9          : in std_logic; -- Filter
      SW13         : in std_logic; -- RSTA
      SW14         : in std_logic; -- Filter Selector
      l_data_in    : in std_logic_vector(width-1 downto 0);                     
      r_data_in    : in std_logic_vector(width-1 downto 0);   
      l_data_out   : out std_logic_vector(width-1 downto 0); -- Datos de salida izquierdos sin retardo;                            
      r_data_out   : out std_logic_vector(width-1 downto 0)  -- Datos de salida derechos sin retardo;          
    );
  end component;
  
begin
  
  clk_process : process
  begin    
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process; 

  unit_digital_effects : digital_effects 
    port map( 
      clk          => clk,
      reset_n      => reset_n,
      enable_in    => enable_in,
      SW0          => SW0,
      SW1          => SW1,
      SW2          => SW2,
      SW3          => SW3,
      SW4          => SW4,
      SW5          => SW5,
      SW6          => SW6,
      SW7          => SW7,
      SW8          => SW8,
      SW9          => SW9,
      SW13         => SW13,
      SW14         => SW14,
      l_data_in    => sample_in,
      r_data_in    => sample_in,
      l_data_out   => l_sample_out,                   
      r_data_out   => r_sample_out
    );

  read_process: process(clk)
  variable in_line : line;
  variable in_read_ok : boolean;
  variable in_int : integer;
  begin
      if (rising_edge(clk)) then
         if not endfile(data_in_file) then
           ReadLine(data_in_file,in_line);
           report "line: " & in_line.all;
           read(in_line, in_int, in_read_ok);
           sample_in <= std_logic_vector(to_signed(in_int,width)); 
         end if;
      end if;
  end process;
  
  write_process: process(clk)
  variable r_out_line : line;
  variable r_out_int : integer;
  variable r_out_integer : integer;
  variable l_out_line : line;
  variable l_out_int : integer;
  variable l_out_integer : integer;
  begin
      if (rising_edge(clk)) then
          if(enable_out = '1') then
            r_out_integer := to_integer(signed(r_sample_out));
            l_out_integer := to_integer(signed(l_sample_out));
            Write(r_out_line, r_out_integer);
            Write(l_out_line, l_out_integer);
            Writeline(r_data_out_file, r_out_line);
            Writeline(l_data_out_file, l_out_line);
          else
            assert false report "Simulation Finished" severity failure;
          end if;
      end if;
  end process;
    
  stim_proc : process
  begin  
      reset_n <= '1';
      enable_out <= '1';
      enable_in <= '0';
      wait for 10*clk_period;
      reset_n <= '0';  
      enable_out <= '1';
      enable_in <= '1';
      --  ---------------------> ES
      --  SW0 <= '0';
      --  SW1 <= '0';
      --  SW2 <= '0';
      --  SW3 <= '0';
      --  SW4 <= '0';
      --  SW5 <= '0';
      --  SW6 <= '0';
      --  SW7 <= '0';
      --  SW8 <= '0';
      --  SW9 <= '0';
      --  ---------------------> Delay
      --  SW0 <= '1';
      --  ---------------------> Chorus
      --  SW1 <= '1';
      --  ---------------------> Reverb
        SW2 <= '1';
      --  ---------------------> Vibrato
      --  SW3 <= '1';
      --  ---------------------> Looper
      --  SW4 <= '1';
      --  ---------------------> Looper_Write
      --  SW5 <= '0';
      --  SW6 <= '1';
      --  ---------------------> Looper_Read
      --  SW5 <= '1';
      --  SW6 <= '1';
      --  SW13 <= '0';
      --  ---------------------> Looper_Read_Mute
      --  SW5 <= '1';
      --  SW6 <= '1';
      --  SW13 <= '1';
      --  ---------------------> Compressor
      --  SW7 <= '1';
      --  ---------------------> Overdrive
      --  SW8 <= '1';
      --  ---------------------> Filter High_Pass
      --  SW9 <= '1';
      --  SW14 <= '0';
      --  ---------------------> Filter Low_Pass
      --  SW9 <= '1';
      --  SW14 <= '0';
      --  ---------------------
      wait for haha_duration;
      reset_n <= '0'; 
      enable_out <= '0';
      enable_in <= '0';
      wait;
  end process;

end tb_digitaleffects_arch;