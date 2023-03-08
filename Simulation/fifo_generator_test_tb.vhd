----------------------------------
-- Engineer: Eros García Arroyo --
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
entity fifo_generator_test_tb is
end fifo_generator_test_tb;

------------------
-- Architecture --
------------------
architecture arch_fifo_generator_test_tb of fifo_generator_test_tb is

  -- Constants
  constant d_width     : integer := 16;
  constant d_deep_fifo : integer := 512;
  constant clk_period  : time := 90ns;

  -- Signals
  signal clk                                         : std_logic := '1';
  signal srst                                        : std_logic := '1';
  signal din_1, din_2, din_3, din_4, din_5           : unsigned(d_width-1 downto 0) := (others => '0');
  signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5 : std_logic := '0';
  signal rd_en_1, rd_en_2, rd_en_3, rd_en_4, rd_en_5 : std_logic := '0';
  signal dout_1, dout_2, dout_3, dout_4, dout_5      : std_logic_vector(d_width-1 downto 0) := (others => '0');
  signal full_1, full_2, full_3, full_4, full_5      : std_logic := '0';
  signal empty_1, empty_2, empty_3, empty_4, empty_5 : std_logic := '0';
  
  -- Components
  component fifo_generator_test is
  port (
    clk   : in std_logic;
    srst  : in std_logic;
    din   : in std_logic_vector(15 downto 0);
    wr_en : in std_logic;
    rd_en : in std_logic;
    dout  : out std_logic_vector(15 downto 0);
    full  : out std_logic;
    empty : out std_logic
  );
  end component;
  
begin

  unit_fifo_generator_test_1 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => srst,
      din   => std_logic_vector(din_1),
      wr_en => wr_en_1,
      rd_en => rd_en_1,
      dout  => dout_1,
      full  => full_1,
      empty => empty_1
  );
    
  unit_fifo_generator_test_2 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => srst,
      din   => std_logic_vector(din_2),
      wr_en => wr_en_2,
      rd_en => rd_en_2,
      dout  => dout_2,
      full  => full_2,
      empty => empty_2
  );
    
  unit_fifo_generator_test_3 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => srst,
      din   => std_logic_vector(din_3),
      wr_en => wr_en_3,
      rd_en => rd_en_3,
      dout  => dout_3,
      full  => full_3,
      empty => empty_3
  );
    
  unit_fifo_generator_test_4 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => srst,
      din   => std_logic_vector(din_4),
      wr_en => wr_en_4,
      rd_en => rd_en_4,
      dout  => dout_4,
      full  => full_4,
      empty => empty_4
  );
    
  unit_fifo_generator_test_5 : fifo_generator_test  
    port map(
      clk   => clk,
      srst  => srst,
      din   => std_logic_vector(din_5),
      wr_en => wr_en_5,
      rd_en => rd_en_5,
      dout  => dout_5,
      full  => full_5,
      empty => empty_5
  );
    
  clk_process : process
  begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
  end process;    
                 
  stim_proc: process 
  begin
      --------------------
      -- Test Purpose 1 --
      --------------------
      srst <= '1';
      din_1 <= x"0000";
      wr_en_1 <= '0';
      rd_en_1 <= '0';
      wait for 10*clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0000";
      wr_en_1 <= '0';
      rd_en_1 <= '0';
      wait for 10*clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0004";
      wr_en_1 <= '1';
      rd_en_1 <= '0';
      wait for clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0004";
      wr_en_1 <= '0';
      rd_en_1 <= '0';
      wait for 10*clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0000";
      wr_en_1 <= '0';
      rd_en_1 <= '0';
      wait for 10*clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0000";
      wr_en_1 <= '0';
      rd_en_1 <= '1';
      wait for clk_period;
      --------------------
      srst <= '0';
      din_1 <= x"0000";
      wr_en_1 <= '0';
      rd_en_1 <= '0';
      wait for 50*clk_period;
      --------------------
      for i in 0 to d_deep_fifo-1 loop
          wr_en_1 <= '1';
          rd_en_1 <= '0';
          din_1 <= din_1 + 1;
          wait for clk_period;
      end loop;  
      wr_en_1 <= '0';
      wait for 10*clk_period;
      for i in 0 to d_deep_fifo-1 loop
          wr_en_1 <= '0';
          rd_en_1 <= '1';
          din_1 <= x"0000";
          wait for clk_period;
      end loop;  
      wait for 10*clk_period;
      for i in 0 to d_deep_fifo-1 loop
          wr_en_1 <= '1';
          rd_en_1 <= '1';
          din_1 <= din_1 + 1;
          wait for clk_period;
      end loop;    
      wait for 10*clk_period;
      --------------------
      -- Test Purpose 2 --
      --------------------
      for i in 0 to 2*d_deep_fifo-1 loop
          wr_en_2 <= '1';
          din_2 <= din_2 + 1;
          -- rd_en_2 <= full_2; --> Asignación estática, hacer fuera del process
          wait for clk_period;
          wr_en_2 <= '0';
          din_2 <= din_2;
          wait for 10*clk_period;
      end loop;
      --------------------
      -- Test Purpose 3 --
      --------------------
      for i in 0 to 5*d_deep_fifo-1 loop
          wr_en_3 <= '1';
          din_3 <= din_3 + 1;
          wait for clk_period;
          wr_en_3 <= '0';
          din_3 <= din_3;
          wait for 5*clk_period;
      end loop;    
      wait;
  end process;
  --------------------
  -- Test Purpose 2 --
  --------------------
  rd_en_2 <= full_2;
  --------------------
  -- Test Purpose 3 --
  --------------------
  rd_en_3 <= full_3;
  rd_en_4 <= full_4;
  rd_en_5 <= full_5;
  din_4 <= unsigned(dout_3);
  din_5 <= unsigned(dout_4);
  process(clk) -- What happens if Registers
  begin
    if (rising_edge(clk)) then   
      wr_en_4 <= full_3;
      wr_en_5 <= full_4;
    end if;
  end process; 
    
end arch_fifo_generator_test_tb;
