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
architecture Behavioral of tb_randomEfect is

  constant d_width : integer := 16;
  constant clk_period : time := 10ns;
  
  signal clk, reset_n, enable_in, enable_out : std_logic :='0';

  file data_in_file: text open read_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\sample_in.dat";
  file l_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\l_sample_out.dat";
  file r_data_out_file: text open write_mode IS "C:\Users\eros_\Downloads\TFMPedalMultiefectosI2S_OPT\MATLAB\r_sample_out.dat";
  
  signal sample_in, l_sample_out, r_sample_out : std_logic_vector(15 downto 0);
  signal SW14 : std_logic := '1';

begin
  
  clk_process : process
  begin    
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process; 

--enable_process :process
--begin    
--    enable_in <= '1';
--    wait for clk_period;
--    enable_in <= '0';
--    wait for 64*clk_period;
--end process; 

--Unit_EfectES : EfectoES 
--GENERIC MAP(d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

--Unit_EfectDELAY : EfectoDELAY 
--GENERIC MAP(n => 4000, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

--Unit_EfectCHORUS : EfectoCHORUS
--GENERIC MAP(n => 1000, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

--Unit_EfectVIBRATO : EfectoVIBRATO
--GENERIC MAP(n => 500, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--);

--Unit_EfectREVERB : EfectoREVERB
--GENERIC MAP(n => 500, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

--Unit_EfectoECO : EfectoECO
--GENERIC MAP(n => 5000, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

--Unit_EfectCOMPRESSOR : EfectCOMPRESSOR
--GENERIC MAP(d_width => 16
--            )
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

Unit_EfectOVERDRIVE : efecto_overdrive
  generic map(g_width => 16)
  port map(
    clk => clk,
    reset_n => reset_n, 
    enable_in => enable_in,
    l_data_in => sample_in, 
    r_data_in => sample_in, 
    l_data_out => l_sample_out, 
    r_data_out => r_sample_out
  ); 

--Unit_EfectoBANKFILTER : EfectoBANKFILTER
--GENERIC MAP(d_width => 16
--            )
--PORT MAP(
--     clk          => clk,
--     reset_n      => reset_n, 
--     enable_in    => enable_in,
--     SW14         => SW14,
--     l_data_in    => Sample_In, 
--     l_data_out   => open,      
--     r_data_in    => Sample_In, 
--     r_data_out   => Sample_out,
--     enable_out   => enable_out 
--);

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
           sample_in <= std_logic_vector(to_signed(in_int, 16)); -- 16 = the bit width
           enable_in <= '1';
         else
           assert false report "Simulation Finished" severity failure;           
         end if;
      end if;
  end process;

  l_write_process: process(clk)
  variable out_line : line;
  variable out_int : integer;
  variable out_integer : integer;
  begin
      if (rising_edge(clk)) then
          if(enable_out = '1') then
              out_integer := to_integer(signed(l_sample_out));
              Write(out_line, out_integer);
              Writeline(l_data_out_file, out_line);
          end if;
      end if;
  end process;
  
  r_write_process: process(clk)
  variable out_line : line;
  variable out_int : integer;
  variable out_integer : integer;
  begin
      if (rising_edge(clk)) then
          if(enable_out = '1') then
              out_integer := to_integer(signed(r_sample_out));
              Write(out_line, out_integer);
              Writeline(r_data_out_file, out_line);
          end if;
      end if;
  end process;

  stim_proc : process
  begin
      reset_n <= '1';
      wait for CLK_period*10;
      reset_n <= '0';  
      enable_out <= enable_in;     
      wait;
  end process;

end Behavioral;
