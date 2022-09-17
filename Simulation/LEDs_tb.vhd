----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2019 14:11:36
-- Design Name: 
-- Module Name: LEDs_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LEDs_tb is
--  Port ( );
end LEDs_tb;

architecture Behavioral of LEDs_tb is

constant  d_width  :  INTEGER := 16;

component LEDs is
GENERIC(
    d_width          :  INTEGER := 16);  --data width
Port ( 
    clk  : in STD_LOGIC;
    reset : in STD_LOGIC;
    play_enable : in STD_LOGIC;
    r_data_rx : in STD_LOGIC_VECTOR (d_width-1 downto 0);
    LEDs : out STD_LOGIC_VECTOR (d_width-1 downto 0)
);
end component;

signal clk, reset, play_enable : STD_LOGIC;
signal r_data_rx, LED : STD_LOGIC_VECTOR (d_width-1 downto 0);

constant clk_period : time := 89ns;

begin

    unit_leds : LEDs  
    GENERIC MAP(d_width => 16)
    PORT MAP(
        clk         =>  clk ,
        reset       =>  reset ,
        play_enable =>  play_enable,
        r_data_rx   =>  r_data_rx  ,
        LEDs        =>  LED       
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
    r_data_rx <= "0000000000001100";
    reset <= '1';
    play_enable <= '0';
    wait for 10*clk_period;
    
    reset <= '0';
    play_enable <= '0';
    wait for 10*clk_period; 
                   
    reset <= '0';
    play_enable <= '1';
    wait for 10*clk_period;
    
    r_data_rx <= "1000000000001100";
    reset <= '0';
    play_enable <= '1';
    wait for 10*clk_period;
    
    r_data_rx <= "1111100000000110";
    reset <= '0';
    play_enable <= '1';
    wait for 10*clk_period;
    
    reset <= '0';
    play_enable <= '0';
    wait for 10*clk_period;
    
    reset <= '1';
    play_enable <= '0';
    wait;
    
end process;
end Behavioral;
