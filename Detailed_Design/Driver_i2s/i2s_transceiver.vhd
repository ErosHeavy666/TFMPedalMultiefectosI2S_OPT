------------------------------------------
-- Engineer: Samuel Lopez & Eros Garcia --
------------------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------
-- Entity --
------------
entity i2s_transceiver is
    generic (
        g_ms_ratio_w : natural := 3; -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
        g_sw_ratio_w : natural := 6; -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
        g_data_w     : natural := 14
    );
    port (
        clk        : in std_logic;
        n_reset    : in std_logic;

        i_reset_s  : in std_logic;
    
        sclk       : out std_logic;
        ws         : out std_logic;
        sd_in      : in std_logic;
        sd_out     : out std_logic;

        l_in       : out std_logic_vector(g_data_w-1 downto 0);
        r_in       : out std_logic_vector(g_data_w-1 downto 0);
        en_in      : out std_logic;

        l_out      : in std_logic_vector(g_data_w-1 downto 0);
        r_out      : in std_logic_vector(g_data_w-1 downto 0)
    );
end i2s_transceiver;

architecture arch_i2s_transceiver of i2s_transceiver is

  -- State definition
  type tp_i2s_state is (idle, l0, l1, r0, r1);
  signal i2s_state_reg, i2s_state_next: tp_i2s_state;
  
  -- Datapath
  signal scount_reg, scount_next : unsigned(g_ms_ratio_w-2 downto 0);
  signal wcount_reg, wcount_next : unsigned(g_sw_ratio_w-2 downto 0);
  
  -- Datapath: sd_in
  signal l_in_next, l_in_reg : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- bits per channel = 2^(sw_ratio_w-1)
  signal r_in_next, r_in_reg : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- (default = 32)
  
  signal l_out_next, l_out_reg : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- bits per channel = 2^(sw_ratio_w-1)
  signal r_out_next, r_out_reg : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- (default = 32)
  
  signal en : std_logic;
    
begin

  ---
  -- i2s: control: state register
  ---
  ctrl_reg: process (clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
        i2s_state_reg <= idle;
      else
        i2s_state_reg <= i2s_state_next;
      end if;
    end if;
  end process;

  ---
  -- i2s: control: next-state logic
  ---
  ctrl_nsl: process (i2s_state_reg, i_reset_s, scount_next, wcount_next)
  begin
      case i2s_state_reg is
          when idle =>
              i2s_state_next <= l0;
          when l0 =>
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  i2s_state_next <= l1;
              else
                  i2s_state_next <= l0;
              end if;
          when l1 =>
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  if (wcount_next = to_unsigned(0, wcount_next'length)) then
                      i2s_state_next <= r0;
                  else
                      i2s_state_next <= l0;
                  end if;
              else
                  i2s_state_next <= l1;
              end if;
          when r0 =>
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  i2s_state_next <= r1;
              else
                  i2s_state_next <= r0;
              end if;
          when r1 =>
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  if (wcount_next = to_unsigned(0, wcount_next'length)) then
                      i2s_state_next <= l0;
                  else
                      i2s_state_next <= r0;
                  end if;
              else
                  i2s_state_next <= r1;
              end if;
      end case;

      -- Switch reset --> Play_enable
      if (i_reset_s = '0') then
          i2s_state_next <= idle;
      end if;
  end process;

  ---
  -- i2s: control: output logic
  ---
  ctrl_out: process (i2s_state_next, i2s_state_reg)
  begin
      -- Default values
      sclk <= '0';
      ws   <= '0';
      en   <= '0';

      case i2s_state_reg is
          when idle =>
              sclk <= '0';
              ws   <= '0';
          when l0 =>
              sclk <= '0';
              ws   <= '0';
          when l1 =>
              sclk <= '1';
              ws   <= '0';
          when r0 =>
              sclk <= '0';
              ws   <= '1';
          when r1 =>
              sclk <= '1';
              ws   <= '1';
              if (i2s_state_next = l0) then
                  en <= '1';
              end if;
      end case;
  end process;

  en_in  <= en;

  ---
  -- i2s: datapath: registers
  ---
  dp_reg: process (clk)
  begin  
    if (rising_edge(clk)) then
      if (n_reset = '0') then
         scount_reg <= (others => '0');
         wcount_reg <= (others => '0');
      else
        scount_reg <= scount_next;
        wcount_reg <= wcount_next;
      end if;
    end if;
  end process;

  ---
  -- i2s: datapath: functional units
  ---
  dp_fu: process (i2s_state_reg, scount_next, scount_reg, wcount_reg)
  begin
      -- Default values
      scount_next <= scount_reg;
      wcount_next <= wcount_reg;

      case i2s_state_reg is
          when idle =>
              scount_next <= to_unsigned(0, scount_next'length);
              wcount_next <= to_unsigned(0, wcount_next'length);
          when l0 =>
              scount_next <= scount_reg + to_unsigned(1, scount_next'length);
          when l1 =>
              scount_next <= scount_reg + to_unsigned(1, scount_next'length);
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  wcount_next <= wcount_reg + to_unsigned(1, wcount_next'length);
              end if;
          when r0 =>
              scount_next <= scount_reg + to_unsigned(1, scount_next'length);
          when r1 =>
              scount_next <= scount_reg + to_unsigned(1, scount_next'length);
              if (scount_next = to_unsigned(0, scount_next'length)) then
                  wcount_next <= wcount_reg + to_unsigned(1, wcount_next'length);
              end if;
      end case;
  end process;

  ---
  -- i2s: sd_in datapath: registers
  ---
  dp_sd_in_reg: process (clk)
  begin     
    if (rising_edge(clk)) then
      if (n_reset = '0') then
         l_in_reg <= (others => '0');
         r_in_reg <= (others => '0');
      else
         l_in_reg <= l_in_next; 
         r_in_reg <= r_in_next; 
      end if;
    end if;
  end process;

  ---
  -- i2s: sd_in datapath: functional units
  ---
  dp_sd_in_fu: process (sd_in, i2s_state_next, i2s_state_reg, l_in_reg, r_in_reg)
  begin
      -- Default values
      l_in_next  <= l_in_reg;
      r_in_next  <= r_in_reg;

      case i2s_state_reg is
          when idle =>
              l_in_next <= (others => '0');
              r_in_next <= (others => '0');
          when l0 =>
              if (i2s_state_next = l1) then
                  l_in_next <= l_in_reg(l_in_reg'length-2 downto 0) & sd_in;  -- Shift left and shift in new bit
              end if;
          when r0 =>
              if (i2s_state_next = r1) then
                  r_in_next <= r_in_reg(r_in_reg'length-2 downto 0) & sd_in;  -- Shift left and shift in new bit
              end if;
          when others => null;
      end case;
  end process;

  -- Select valid aligned data from the input registers
  l_in <= l_in_reg(l_in_reg'length-2 downto l_in_reg'length-g_data_w-1);
  r_in <= r_in_reg(r_in_reg'length-2 downto r_in_reg'length-g_data_w-1);

  ---
  -- i2s: sd_out datapath: registers
  ---
  dp_sd_out_reg: process (clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
         l_out_reg  <= (others => '0');
         r_out_reg  <= (others => '0');
      else
         l_out_reg  <= l_out_next; 
         r_out_reg  <= r_out_next; 
      end if;
    end if;
  end process;

  ---
  -- i2s: sd_out datapath: functional units
  ---
  dp_sd_out_fu: process (i2s_state_next, i2s_state_reg, l_out, r_out, l_out_reg, r_out_reg, en)
  begin
    -- Default values
    l_out_next <= l_out_reg;
    r_out_next <= r_out_reg;
    sd_out  <= '0';

    case i2s_state_reg is
      when idle =>
        l_out_next <= (others => '0');
        r_out_next <= (others => '0');
      when l0 =>
        sd_out <= l_out_reg(l_out_reg'length-1);
      when l1 =>
        sd_out <= l_out_reg(l_out_reg'length-1);

        if (i2s_state_next = l0) then
            l_out_next <= l_out_reg(l_out_reg'length-2 downto 0) & '0';
        end if;
      when r0 =>
        sd_out <= r_out_reg(r_out_reg'length-1);
      when r1 =>
        sd_out <= r_out_reg(r_out_reg'length-1);
        
        if (i2s_state_next = r0) then
            r_out_next <= r_out_reg(r_out_reg'length-2 downto 0) & '0';
        end if;

        if (en = '1') then
            l_out_next(l_out_next'length-2 downto l_out_next'length-g_data_w-1) <= std_logic_vector(l_out);
            r_out_next(r_out_next'length-2 downto r_out_next'length-g_data_w-1) <= std_logic_vector(r_out);
        end if;
    end case;
  end process;

end arch_i2s_transceiver;
