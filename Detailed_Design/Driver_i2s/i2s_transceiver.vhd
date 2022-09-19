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
        g_data_w     : natural := 16
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
        r_out      : in std_logic_vector(g_data_w-1 downto 0);
        en_out     : out std_logic
    );
end i2s_transceiver;

architecture arch_i2s_transceiver of i2s_transceiver is

  -- State definition
  type tp_i2s_state is (idle, l0, l1, r0, r1);
  signal s_i2s_state, r_i2s_state: tp_i2s_state;
  
  -- Datapath
  signal s_scount, r_scount : unsigned(g_ms_ratio_w-2 downto 0);
  signal s_wcount, r_wcount : unsigned(g_sw_ratio_w-2 downto 0);
  
  -- Datapath: sd_in
  signal s_l_in, r_l_in : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- bits per channel = 2^(sw_ratio_w-1)
  signal s_r_in, r_r_in : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- (default = 32)
  
  signal s_l_out, r_l_out : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- bits per channel = 2^(sw_ratio_w-1)
  signal s_r_out, r_r_out : std_logic_vector(2**(g_sw_ratio_w-1)-1 downto 0); -- (default = 32)
  
  signal en : std_logic;
    
begin

  ---
  -- i2s: control: state register
  ---
  ctrl_reg: process (clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
        r_i2s_state <= idle;
      else
        r_i2s_state <= s_i2s_state;
      end if;
    end if;
  end process;

  ---
  -- i2s: control: next-state logic
  ---
  ctrl_nsl: process (r_i2s_state, i_reset_s, s_scount, s_wcount)
  begin
      case r_i2s_state is
          when idle =>
              s_i2s_state <= l0;
          when l0 =>
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  s_i2s_state <= l1;
              else
                  s_i2s_state <= l0;
              end if;
          when l1 =>
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  if (s_wcount = to_unsigned(0, s_wcount'length)) then
                      s_i2s_state <= r0;
                  else
                      s_i2s_state <= l0;
                  end if;
              else
                  s_i2s_state <= l1;
              end if;
          when r0 =>
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  s_i2s_state <= r1;
              else
                  s_i2s_state <= r0;
              end if;
          when r1 =>
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  if (s_wcount = to_unsigned(0, s_wcount'length)) then
                      s_i2s_state <= l0;
                  else
                      s_i2s_state <= r0;
                  end if;
              else
                  s_i2s_state <= r1;
              end if;
      end case;

      -- Switch reset --> Play_enable
      if (i_reset_s = '0') then
          s_i2s_state <= idle;
      end if;
  end process;

  ---
  -- i2s: control: output logic
  ---
  ctrl_out: process (s_i2s_state, r_i2s_state)
  begin
      -- Default values
      sclk <= '0';
      ws   <= '0';
      en   <= '0';

      case r_i2s_state is
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
              if (s_i2s_state = l0) then
                  en <= '1';
              end if;
      end case;
  end process;

  en_in  <= en;
  en_out <= en;

  ---
  -- i2s: datapath: registers
  ---
  dp_reg: process (clk)
  begin  
    if (rising_edge(clk)) then
      if (n_reset = '0') then
         r_scount <= (others => '0');
         r_wcount <= (others => '0');
      else
        r_scount <= s_scount;
        r_wcount <= s_wcount;
      end if;
    end if;
  end process;

  ---
  -- i2s: datapath: functional units
  ---
  dp_fu: process (r_i2s_state, s_scount, r_scount, r_wcount)
  begin
      -- Default values
      s_scount <= r_scount;
      s_wcount <= r_wcount;

      case r_i2s_state is
          when idle =>
              s_scount <= to_unsigned(0, s_scount'length);
              s_wcount <= to_unsigned(0, s_wcount'length);
          when l0 =>
              s_scount <= r_scount + to_unsigned(1, s_scount'length);
          when l1 =>
              s_scount <= r_scount + to_unsigned(1, s_scount'length);
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  s_wcount <= r_wcount + to_unsigned(1, s_wcount'length);
              end if;
          when r0 =>
              s_scount <= r_scount + to_unsigned(1, s_scount'length);
          when r1 =>
              s_scount <= r_scount + to_unsigned(1, s_scount'length);
              if (s_scount = to_unsigned(0, s_scount'length)) then
                  s_wcount <= r_wcount + to_unsigned(1, s_wcount'length);
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
         r_l_in <= (others => '0');
         r_r_in <= (others => '0');
      else
         r_l_in <= s_l_in; 
         r_r_in <= s_r_in; 
      end if;
    end if;
  end process;

  ---
  -- i2s: sd_in datapath: functional units
  ---
  dp_sd_in_fu: process (sd_in, s_i2s_state, r_i2s_state, r_l_in, r_r_in)
  begin
      -- Default values
      s_l_in  <= r_l_in;
      s_r_in  <= r_r_in;

      case r_i2s_state is
          when idle =>
              s_l_in <= (others => '0');
              s_r_in <= (others => '0');
          when l0 =>
              if (s_i2s_state = l1) then
                  s_l_in <= r_l_in(r_l_in'length-2 downto 0) & sd_in;  -- Shift left and shift in new bit
              end if;
          when r0 =>
              if (s_i2s_state = r1) then
                  s_r_in <= r_r_in(r_r_in'length-2 downto 0) & sd_in;  -- Shift left and shift in new bit
              end if;
          when others => null;
      end case;
  end process;

  -- Select valid aligned data from the input registers
  l_in <= r_l_in(r_l_in'length-2 downto r_l_in'length-g_data_w-1);
  r_in <= r_r_in(r_r_in'length-2 downto r_r_in'length-g_data_w-1);

  ---
  -- i2s: sd_out datapath: registers
  ---
  dp_sd_out_reg: process (clk)
  begin
    if (rising_edge(clk)) then
      if (n_reset = '0') then
         r_l_out  <= (others => '0');
         r_r_out  <= (others => '0');
      else
         r_l_out  <= s_l_out; 
         r_r_out  <= s_r_out; 
      end if;
    end if;
  end process;

  ---
  -- i2s: sd_out datapath: functional units
  ---
  dp_sd_out_fu: process (s_i2s_state, r_i2s_state, l_out, r_out, r_l_out, r_r_out, en)
  begin
    -- Default values
    s_l_out <= r_l_out;
    s_r_out <= r_r_out;
    sd_out  <= '0';

    case r_i2s_state is
      when idle =>
        s_l_out <= (others => '0');
        s_r_out <= (others => '0');
      when l0 =>
        sd_out <= r_l_out(r_l_out'length-1);
      when l1 =>
        sd_out <= r_l_out(r_l_out'length-1);

        if (s_i2s_state = l0) then
            s_l_out <= r_l_out(r_l_out'length-2 downto 0) & '0';
        end if;
      when r0 =>
        sd_out <= r_r_out(r_r_out'length-1);
      when r1 =>
        sd_out <= r_r_out(r_r_out'length-1);
        
        if (s_i2s_state = r0) then
            s_r_out <= r_r_out(r_r_out'length-2 downto 0) & '0';
        end if;

        if (en = '1') then
            s_l_out(s_l_out'length-2 downto s_l_out'length-g_data_w-1) <= std_logic_vector(l_out);
            s_r_out(s_r_out'length-2 downto s_r_out'length-g_data_w-1) <= std_logic_vector(r_out);
        end if;
    end case;
  end process;

end arch_i2s_transceiver;
