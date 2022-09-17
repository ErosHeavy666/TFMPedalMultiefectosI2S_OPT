--------------------------------------------------------------------------------
--
--   FileName:         i2s_playback.vhd
--   Dependencies:     i2s_transceiver.vhd, clk_wiz_0 (PLL)
--   Design Software:  Vivado v2017.2
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 04/19/2019 Scott Larson
--     Initial Public Release
-- 
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY i2s_playback IS
    GENERIC(
        d_width     :  INTEGER := 16);                    --data width
    PORT(
        clock       : IN  STD_LOGIC;                     --system clock (100 MHz on Basys board)
        reset_n     : IN  STD_LOGIC;                     --active low asynchronous reset
        play_enable : in STD_LOGIC;
        BTNR        : in STD_LOGIC;
        BTNC        : in STD_LOGIC; 
        BTNL        : in STD_LOGIC; 
        BTND        : in STD_LOGIC;     
        SW0         : in STD_LOGIC;
        SW1         : in STD_LOGIC;
        SW2         : in STD_LOGIC;
        SW3         : in STD_LOGIC;
        SW4         : in STD_LOGIC;
        SW5         : in STD_LOGIC;
        SW6         : in STD_LOGIC;
        SW7         : in STD_LOGIC;
        SW8         : in STD_LOGIC;
        SW9         : in STD_LOGIC;
        SW10        : in STD_LOGIC;
        SW11        : in STD_LOGIC;
        SW12        : in STD_LOGIC;
        SW13        : in STD_LOGIC;
        SW14        : in STD_LOGIC;                
        mclk        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  --master clock
        sclk        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  --serial clock (or bit clock)
        ws          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  --word select (or left-right clock)
        sd_in       : IN  STD_LOGIC;                     --serial data in
        sd_out      : OUT STD_LOGIC;
        seg         : out STD_LOGIC_VECTOR (6 downto 0);
        an          : out STD_LOGIC_VECTOR (7 downto 0);
        LED         : out STD_LOGIC_VECTOR (d_width-1 downto 0)

        );                    --serial data out
END i2s_playback;

ARCHITECTURE logic OF i2s_playback IS
    
    SIGNAL master_clk   :  STD_LOGIC;                             --internal master clock signal
    SIGNAL serial_clk   :  STD_LOGIC := '0';                      --internal serial clock signal
    SIGNAL word_select  :  STD_LOGIC := '0';                      --internal word select signal
    SIGNAL l_data_rx    :  signed(d_width-1 DOWNTO 0);  --left channel data received from I2S Transceiver component
    SIGNAL r_data_rx    :  signed(d_width-1 DOWNTO 0);  --right channel data received from I2S Transceiver component
    SIGNAL l_data_tx    :  std_logic_vector(d_width-1 DOWNTO 0);  --left channel data to transmit using I2S Transceiver component
    SIGNAL r_data_tx    :  std_logic_vector(d_width-1 DOWNTO 0);  --right channel data to transmit using I2S Transceiver component
    SIGNAL en_rx, en_tx :  STD_LOGIC;  
    type global_state_var is (PLAY, PAUSE, STOP);
    signal state, state_next : global_state_var := STOP;        
         
    signal global_state : STD_LOGIC_VECTOR (1 downto 0) := "00";
    
    --declare PLL to create 11.29 MHz master clock from 100 MHz system clock
    COMPONENT clk_wiz_1
        PORT(
            clk_in1     :  IN STD_LOGIC  := '0';
            clk_out1    :  OUT STD_LOGIC);
        END COMPONENT;

    --declare I2S Transceiver component
    component i2s is
        generic (
            ms_ratio_w: natural := 3;       -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
            sw_ratio_w: natural := 6;       -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
            
            data_w:     natural := 16
        );
        port (
            clk:       in  std_logic;
            n_reset_a: in  std_logic;
    
            reset_s:   in  std_logic;
        
            sclk:      out std_logic;
            ws:        out std_logic;
            sd_in:     in  std_logic;
            sd_out:    out std_logic;
    
            l_in:      out signed(data_w-1 downto 0);
            r_in:      out signed(data_w-1 downto 0);
            en_in:     out std_logic;
    
            l_out:     in  signed(data_w-1 downto 0);
            r_out:     in  signed(data_w-1 downto 0);
            en_out:    out std_logic
        );
    end component;
    
    component display_interface port(
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            state : in STD_LOGIC_VECTOR (1 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0);
            an : out STD_LOGIC_VECTOR (7 downto 0)
    ); end component;
    
    component Digital_Efects is
    GENERIC(
        d_width         :  INTEGER := 16);
    Port ( 
        clk                   : in STD_LOGIC;
        reset_n               : in STD_LOGIC;
        enable_in             : in STD_LOGIC; 
        enable_out            : out STD_LOGIC;
        BTNR                  : in STD_LOGIC;
        BTNC                  : in STD_LOGIC; 
        BTNL                  : in STD_LOGIC; 
        BTND                  : in STD_LOGIC; 
        SW0                   : in STD_LOGIC;
        SW1                   : in STD_LOGIC;
        SW2                   : in STD_LOGIC;
        SW3                   : in STD_LOGIC;
        SW4                   : in STD_LOGIC;
        SW5                   : in STD_LOGIC;
        SW6                   : in STD_LOGIC;
        SW7                   : in STD_LOGIC;
        SW8                   : in STD_LOGIC;
        SW9                   : in STD_LOGIC;
        SW10                  : in STD_LOGIC;
        SW11                  : in STD_LOGIC;
        SW12                  : in STD_LOGIC;
        SW13                  : in STD_LOGIC;
        SW14                  : in STD_LOGIC;
        l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
        l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
        r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
        r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
    );
    end component;
     
    component LEDs is
    GENERIC(
        d_width          :  INTEGER := 16);  --data width
    Port ( 
        clk             : in STD_LOGIC;
        reset           :in STD_LOGIC;
        play_enable     : in STD_LOGIC;
        --l_data_rx   : in STD_LOGIC_VECTOR (d_width-1 downto 0);
        r_data_rx   : in STD_LOGIC_VECTOR (d_width-1 downto 0);
        LEDs        : out STD_LOGIC_VECTOR (d_width-1 downto 0)
    );
    end component;
      
      signal i2s_reset, play_enable_SW0 : std_logic;
BEGIN
    i2s_reset <= not reset_n;
    play_enable_SW0 <= not play_enable;
    
    --instantiate PLL to create master clock
    i2s_clock: clk_wiz_1 
    PORT MAP(
        clk_in1 => clock, 
        clk_out1 => master_clk
    );
  
    --instantiate I2S Transceiver component
    unit_i2s: i2s
        PORT MAP(
        clk => master_clk,
        n_reset_a => i2s_reset, 
        reset_s => play_enable_SW0,
        
        sclk => serial_clk, 
        ws => word_select, 
        sd_in => sd_in, 
        sd_out => sd_out,
        
        l_in => l_data_rx, 
        r_in => r_data_rx, 
        
        en_in     => en_rx,
        l_out => signed(l_data_tx), 
        r_out => signed(r_data_tx),
        en_out => open
    );

    unit_digital_efects : Digital_Efects
    GENERIC MAP(d_width => 16)
    PORT MAP(
         clk => master_clk , 
         reset_n => reset_n ,
         enable_in => en_rx ,
         enable_out => open,
         BTNR => BTNR,
         BTNC => BTNC,
         BTNL => BTNL,
         BTND => BTND,
         SW0 => SW0,
         SW1 => SW1,
         SW2 => SW2,
         SW3 => SW3,
         SW4 => SW4,
         SW5 => SW5,
         SW6 => SW6,
         SW7 => SW7,
         SW8 => SW8,
         SW9 => SW9,
         SW10 => SW10,
         SW11 => SW11,
         SW12 => SW12,
         SW13 => SW13,
         SW14 => SW14,
         l_data_in => std_LOGIC_VECTOR(l_data_rx) , 
         l_data_out => l_data_tx, 
         r_data_in => std_LOGIC_VECTOR(r_data_rx) , 
         r_data_out => r_data_tx
    ); 

    
    displays : display_interface port map (
          clk => clock,
          reset => reset_n,
          state => global_state,
          seg => seg,
          an => an
    );
    
    unit_leds : LEDs  
    GENERIC MAP(d_width => 16)
    PORT MAP(
        clk         =>  master_clk ,
        reset       =>  reset_n ,
        play_enable =>  play_enable,
        --l_data_rx   =>  std_logic_vector(l_data_rx)  ,
        r_data_rx   =>  std_logic_vector(r_data_rx)  ,
        LEDs        =>  LED       
    );
    
    
    change_state_logic : process(state, play_enable)
            begin
                state_next <= state;
                case state is
                    when STOP => 
                        if play_enable = '1' then
                            state_next <= PLAY;
                        else
                            state_next <= PAUSE;
                        end if;
                    when PLAY =>
                        if play_enable = '0' then
                            state_next <= PAUSE;
                        end if;
                    when PAUSE =>
                        if play_enable = '1' then
                            state_next <= PLAY;
                        end if;
                    when others =>
                end case;
        end process;
        
        reg_logic : process(clock, reset_n)
            begin
                if reset_n = '1' then 
                    state <= STOP;
                elsif rising_edge(clock) then
                    state <= state_next;
                end if;
        end process;
        
        output_logic : process(state)
            begin
                global_state <= "00";           
                case state is
                    when STOP => 
                        global_state <= "00";
                        
                    when PLAY =>
                        global_state <= "11";
                        
                    when PAUSE =>
                        global_state <= "01";
                        
                    when others =>
                        global_state <= "00";
                end case;
        end process;
        
    mclk(0) <= master_clk;  --output master clock to ADC
    mclk(1) <= master_clk;  --output master clock to DAC
    sclk(0) <= serial_clk;  --output serial clock (from I2S Transceiver) to ADC
    sclk(1) <= serial_clk;  --output serial clock (from I2S Transceiver) to DAC
    ws(0) <= word_select;   --output word select (from I2S Transceiver) to ADC
    ws(1) <= word_select;   --output word select (from I2S Transceiver) to DAC
                    
END logic;
