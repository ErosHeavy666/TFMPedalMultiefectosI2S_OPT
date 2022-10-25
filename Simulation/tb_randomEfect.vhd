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
use work.pkg_digital_effects.all;

------------
-- Entity --
------------
entity tb_randomEfect is
end tb_randomEfect;

------------------
-- Architecture --
------------------
architecture tb_randomEfect_arch of tb_randomEfect is

  -- Constants
  constant g_width : integer := 18;
  constant clk_period : time := 45.35us;
  constant haha_duration : time := 1000ms;
  
   -- Signals
  signal clk, reset_n, enable_out : std_logic := '1';
  signal enable_in : std_logic := '0';
  signal sample_in, l_sample_out, r_sample_out : std_logic_vector(g_width-1 downto 0);
  signal SW14 : std_logic := '0';
  
  -- Files
  file data_in_file: text open read_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\haha_sample_in_18b.dat";
  file l_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\l_sample_out_18b.dat";
  file r_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\r_sample_out_18b.dat";

begin
  
  clk_process : process
  begin    
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process; 

--  Unit_EfectES : efecto_es 
--  generic map(g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

--  Unit_EfectDELAY : efecto_delay 
--  generic map(n => 4000, g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

--  Unit_EfectCHORUS : efecto_chorus 
--  generic map(n => 1000, g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

--  Unit_EfectVIBRATO : efecto_vibrato 
--  generic map(n => 500, g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

  Unit_EfectREVERB : efecto_reverb
  generic map(n => 500, g_width => 18)
  port map(
    clk => clk,
    reset_n => reset_n, 
    enable_in => enable_in,
    l_data_in => sample_in, 
    r_data_in => sample_in, 
    l_data_out => l_sample_out, 
    r_data_out => r_sample_out
  ); 
  
--  Unit_EfectECO : efecto_eco
--  generic map(n => 5000, g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

--Unit_EfectCOMPRESSOR : efecto_compressor
--  generic map(g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

--Unit_EfectOVERDRIVE : efecto_overdrive
--  generic map(g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 


--Unit_EfectoFILTER : efecto_filter
--  generic map(g_width => 14)
--  port map(
--    clk => clk,
--    reset_n => reset_n, 
--    enable_in => enable_in,
--    SW14 => SW14,
--    l_data_in => sample_in, 
--    r_data_in => sample_in, 
--    l_data_out => l_sample_out, 
--    r_data_out => r_sample_out
--  ); 

  process(clk)
  variable in_line : line;
  variable in_read_ok : boolean;
  variable in_int : integer;
  begin
      if (rising_edge(clk)) then
         if not endfile(data_in_file) then
           ReadLine(data_in_file,in_line);
           report "line: " & in_line.all;
           read(in_line, in_int, in_read_ok);
           sample_in <= std_logic_vector(to_signed(in_int, g_width)); 
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
      wait for CLK_period*10;
      reset_n <= '0';  
      enable_out <= '1';
      enable_in <= '1';
      wait for haha_duration;
      reset_n <= '0'; 
      enable_out <= '0';
      enable_in <= '0';
      wait;
  end process;

end tb_randomEfect_arch;
