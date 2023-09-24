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
entity MIG_Controller is
  port( 
    clk        : in std_logic; --MCLK                                            
    reset_n    : in std_logic; --Reset síncrono a nivel alto del sistema global 
    enable_in  : in std_logic;  --Enable proporcionado por el i2s2                
    --- 
    SW13       : in std_logic; --RSTA     
    SW5        : in std_logic; --Switches de control para el looper --> Write
    SW6        : in std_logic; --Switches de control para el looper --> Read                
    ---
    l_data_out : out std_logic_vector(width-1 downto 0);  
    r_data_out : out std_logic_vector(width-1 downto 0)  
  );
end MIG_Controller;

------------------
-- Architecture --
------------------
architecture arch_MIG_Controller of MIG_Controller is

  --Signals
  -- Commands, Address & Control Ports
  signal app_cmd_reg, app_cmd_next                     : std_logic_vector(2 downto 0);           
  signal app_addr_reg, app_addr_next                   : std_logic_vector(26 downto 0);         
  signal app_en_reg, app_en_next                       : std_logic;            
  signal app_rdy_reg, app_rdy_next                     : std_logic;   
  -- Write Ports
  signal app_wdf_data_reg, app_wdf_data_next           : std_logic_vector(63 downto 0);
  signal app_wdf_end_reg, app_wdf_end_next             : std_logic;
  signal app_wdf_mask_reg, app_wdf_mask_next           : std_logic_vector(7 downto 0);
  signal app_wdf_wren_reg, app_wdf_wren_next           : std_logic;
  signal app_wdf_rdy_reg, app_wdf_rdy_next             : std_logic;
  -- Read Ports
  signal app_rd_data_reg, app_rd_data_next             : std_logic_vector(63 downto 0);
  signal app_rd_data_end_reg, app_rd_data_end_next     : std_logic;
  signal app_rd_data_valid_reg, app_rd_data_valid_next : std_logic;
  -- State_fsm
  type state_type is(inicio, rec, play_fw);             --Lista con el número de estados
  signal state_reg, state_next                         : state_type;
  -- DDR Reset
  signal ddr_rst                                       : std_logic;
  
  signal init_cnt_reg, init_cnt_next                   : unsigned(15 downto 0);
  
  -- Components
  component mig_7series_0 is
    port (
      ddr2_dq                : inout std_logic_vector(15 downto 0);
      ddr2_dqs_p             : inout std_logic_vector(1 downto 0);
      ddr2_dqs_n             : inout std_logic_vector(1 downto 0);
      ddr2_addr              : out   std_logic_vector(12 downto 0);
      ddr2_ba                : out   std_logic_vector(2 downto 0);
      ddr2_ras_n             : out   std_logic;
      ddr2_cas_n             : out   std_logic;
      ddr2_we_n              : out   std_logic;
      ddr2_ck_p              : out   std_logic_vector(0 downto 0);
      ddr2_ck_n              : out   std_logic_vector(0 downto 0);
      ddr2_cke               : out   std_logic_vector(0 downto 0);
      ddr2_cs_n              : out   std_logic_vector(0 downto 0);
      ddr2_dm                : out   std_logic_vector(1 downto 0);
      ddr2_odt               : out   std_logic_vector(0 downto 0);
      app_addr               : in    std_logic_vector(26 downto 0);
      app_cmd                : in    std_logic_vector(2 downto 0);
      app_en                 : in    std_logic;
      app_wdf_data           : in    std_logic_vector(63 downto 0);
      app_wdf_end            : in    std_logic;
      app_wdf_mask           : in    std_logic_vector(7 downto 0);
      app_wdf_wren           : in    std_logic;
      app_rd_data            : out   std_logic_vector(63 downto 0);
      app_rd_data_end        : out   std_logic;
      app_rd_data_valid      : out   std_logic;
      app_rdy                : out   std_logic;
      app_wdf_rdy            : out   std_logic;
      app_sr_req             : in    std_logic;
      app_ref_req            : in    std_logic;
      app_zq_req             : in    std_logic;
      app_sr_active          : out   std_logic;
      app_ref_ack            : out   std_logic;
      app_zq_ack             : out   std_logic;
      ui_clk                 : out   std_logic;
      ui_clk_sync_rst        : out   std_logic;
      init_calib_complete    : out   std_logic;
      -- System Clock Ports
      sys_clk_i              : in    std_logic;
      sys_rst                : in    std_logic
    );
  end component; 
  
begin 

  -------------------------------------------------------------------------------------------------------------------------------
  -- Component Instances: Selector_Module
  -------------------------------------------------------------------------------------------------------------------------------
  mig_7series_0_unit : mig_7series_0
    port map(
      -- Commands, Address & Control Ports
      app_cmd                => app_cmd_reg           ,
      app_addr               => app_addr_reg          ,
      app_en                 => app_en_reg            ,
      app_rdy                => app_rdy_next          ,
      -- Write Ports
      app_wdf_data           => app_wdf_data_reg      ,
      app_wdf_end            => app_wdf_end_reg       ,
      app_wdf_mask           => app_wdf_mask_reg      ,
      app_wdf_wren           => app_wdf_wren_reg      ,
      app_wdf_rdy            => app_wdf_rdy_next      ,
      -- Read Ports
      app_rd_data            => app_rd_data_next      ,
      app_rd_data_end        => app_rd_data_end_next  ,
      app_rd_data_valid      => app_rd_data_valid_next,
      -- Not Used
      app_sr_req             => '0'                   ,
      app_ref_req            => '0'                   ,
      app_zq_req             => '0'                   ,
      -- System Clock Ports
      sys_clk_i              => clk                   ,
      sys_rst                => ddr_rst
  );
  
  ddr_rst <= not (reset_n);
  --ddr_rst <= (reset_n);
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------
  process(clk)
  begin 
    if (rising_edge(clk)) then --MCLK
      if (reset_n = '1') then
        -- Commands, Address & Control Ports
        app_cmd_reg           <= (others => '1');                        
        app_addr_reg          <= (others => '0');  
        app_en_reg            <= '0';
        --app_rdy_reg           <= '0';
        -- Write Ports
        app_wdf_data_reg      <= (others => '0');     
        app_wdf_end_reg       <= '0';  
        app_wdf_mask_reg      <= (others => '0');
        app_wdf_wren_reg      <= '0';
        app_wdf_rdy_reg       <= '0';
        -- Read Ports
        app_rd_data_reg       <= (others => '0');
        app_rd_data_end_reg   <= '0';
        app_rd_data_valid_reg <= '0';
        -- State_fsm
        state_reg             <= inicio;
        init_cnt_reg          <= (others => '0');
      --elsif(enable_in = '1')then
      else
        -- Commands, Address & Control Ports
        app_cmd_reg           <= app_cmd_next;                        
        app_addr_reg          <= app_addr_next; 
        app_en_reg            <= app_en_next;  
        app_rdy_reg           <= app_rdy_next; 
        -- Write Ports
        app_wdf_data_reg      <= app_wdf_data_next;     
        app_wdf_end_reg       <= app_wdf_end_next; 
        app_wdf_mask_reg      <= app_wdf_mask_next;
        app_wdf_wren_reg      <= app_wdf_wren_next;
        app_wdf_rdy_reg       <= app_wdf_rdy_next;
        -- Read Ports
        app_rd_data_reg       <= app_rd_data_next;
        app_rd_data_end_reg   <= app_rd_data_end_next;
        app_rd_data_valid_reg <= app_rd_data_valid_next; 
        -- State_fsm
        state_reg             <= state_next;
        init_cnt_reg          <= init_cnt_next;
      end if;
    end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: 
  -------------------------------------------------------------------------------------------------------------------------------
  process(state_reg, enable_in, app_cmd_reg, app_addr_reg, app_en_reg, app_rdy_reg, 
          app_wdf_data_reg, app_wdf_end_reg, app_wdf_mask_reg, app_wdf_wren_reg, app_wdf_rdy_reg,
          app_rd_data_reg, app_rd_data_end_reg, app_rd_data_valid_reg)
  begin
    -- Init to avoid latches in the fsm signal data-flow                        
      app_addr_next          <= app_addr_reg; 
      --app_rdy_next           <= app_rdy_reg; 
      -- Write Ports
      app_wdf_data_next      <= app_wdf_data_reg;     
      app_wdf_end_next       <= app_wdf_end_reg; 
      app_wdf_mask_next      <= (others => '0');
      app_wdf_wren_next      <= app_wdf_wren_reg;
      --app_wdf_rdy_next       <= app_wdf_rdy_reg;
      -- Read Ports
      --app_rd_data_next       <= app_rd_data_reg;
      --app_rd_data_end_next   <= app_rd_data_end_reg;
      --app_rd_data_valid_next <= app_rd_data_valid_reg; 
      -- State_fsm
      state_next             <= state_reg;    
    -- Case declaration for states
    case state_reg is
    
      --------------
      when inicio => 
      --------------
        --if (app_cmd_reg = "000" and app_rdy_reg = '1' and enable_in = '1') then
        if (app_cmd_reg = "000" and enable_in = '1') then
          app_addr_next <= x"001000" & "000";
          app_wdf_data_next <= x"0000011000000001";
          app_wdf_wren_next <= '1';
          app_wdf_end_next <= '1';
          if (app_rdy_reg = '1' ) then
            state_next <= rec; 
          end if;
          
        elsif (app_cmd_reg = "001" and app_rdy_reg = '1' and enable_in = '1') then
          app_addr_next <= x"000000" & "001";
          state_next <= play_fw; 
        
        else
          state_next <= inicio;
        end if;
      
      -----------
      when rec =>    
      -----------
        app_addr_next <= x"000000" & "000";
        app_wdf_data_next <= x"0000000000000000";
        app_wdf_wren_next <= '0';
        app_wdf_end_next <= '0';
        state_next <= inicio; 
          
      ---------------
      when play_fw => 
      ---------------
        state_next <= inicio; 
        
    end case;      
    
  end process;
  
  -- DDR_Control
  app_cmd_next <= "001" when (SW6 = '1' and SW5 = '1'  and init_cnt_reg = x"0111") else
                  "000" when (init_cnt_reg = x"0111") else app_cmd_reg;
  
  init_cnt_next <= x"0111" when init_cnt_reg = x"0111" else
                   init_cnt_reg + 1;
                  
  app_en_next  <= '1' when ((SW6 = '0' and SW5 = '1' and init_cnt_reg = x"0111") or 
                            (SW6 = '1' and SW5 = '1' and init_cnt_reg = x"0111")) else
                  '0';   
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process:
  -------------------------------------------------------------------------------------------------------------------------------
  l_data_out <= app_rd_data_reg(15 downto 0);
  r_data_out <= app_rd_data_reg(15 downto 0);
  -------------------------------------------------------------------------------------------------------------------------------  
end arch_MIG_Controller;