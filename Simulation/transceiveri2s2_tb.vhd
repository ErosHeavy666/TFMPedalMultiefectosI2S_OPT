----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 19:23:46
-- Design Name: 
-- Module Name: transceiveri2s2_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transceiveri2s2_tb is
--  Port ( );
end transceiveri2s2_tb;

architecture Behavioral of transceiveri2s2_tb is

constant data_w : natural := 16;
constant ms_ratio_w: natural := 3;  
constant sw_ratio_w: natural := 6; 

component i2s is
    generic (
        ms_ratio_w: natural := 3;       -- clk to sclk ratio = 2^ms_ratio_w (default = 8)
        sw_ratio_w: natural := 6;       -- sclk to ws ratio  = 2^sw_ratio_w (default = 64)
        
        data_w:     natural := 16
    );
    port (
        clk         :  in  std_logic;
        n_reset_a   :  in  std_logic;

        reset_s     :  in  std_logic;
    
        sclk        :  out std_logic;
        ws          :  out std_logic;
        sd_in       :  in  std_logic;
        sd_out      :  out std_logic;

        l_in        :  out signed(data_w-1 downto 0);
        r_in        :  out signed(data_w-1 downto 0);
        en_in       :  out std_logic;

        l_out       :  in  signed(data_w-1 downto 0);
        r_out       :  in  signed(data_w-1 downto 0);
        en_out      :  out std_logic
    );
end component;

signal clk, n_reset_a, reset_s, sclk, ws, sd_in, sd_out, en_in, en_out : STD_LOGIC;
signal l_in, r_in, l_out, r_out : signed(data_w-1 downto 0);

constant  clk_period : time := 10ns;

begin

unit_i2s : i2s 
GENERIC MAP(ms_ratio_w => 3, 
            sw_ratio_w => 6, 
            data_w => 16
            )
PORT MAP(
   clk        => clk        ,
   n_reset_a  => n_reset_a  ,
   reset_s    => reset_s    ,
   sclk       => sclk       ,
   ws         => ws         ,
   sd_in      => sd_in      ,
   sd_out     => sd_out     ,
   l_in       => l_in       ,
   r_in       => r_in       ,
   en_in      => en_in      ,
   l_out      => l_out      ,
   r_out      => r_out      ,
   en_out     => en_out     
); 

clk_process :process
begin    
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process; 
 
stim_proc: process 
begin
    n_reset_a <= '0';
    reset_s  <= '0';
    sd_in <= '0';  
    l_out <= (others => '0');
    r_out <= (others => '0');         
    wait for 10*clk_period;
    n_reset_a <= '1';
    reset_s  <= '0';
    sd_in <= '1';  
    l_out <= (others => '0');
    r_out <= (others => '0');         
    wait;
end process;
end Behavioral;
