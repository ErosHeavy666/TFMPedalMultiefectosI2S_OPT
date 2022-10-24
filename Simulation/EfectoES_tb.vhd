----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:32:23
-- Design Name: 
-- Module Name: EfectoES_tb - Behavioral
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

entity EfectoLOOPER_tb is
--  Port ( );
end EfectoLOOPER_tb;

architecture Behavioral of EfectoLOOPER_tb is

constant g_width : INTEGER := 14;
constant d_deep  : INTEGER := 19;

component efecto_looper is
  generic(
    g_width : integer := 14; --Ancho del bus  
    d_deep  : integer := 19); --Ancho de la memoria RAM
  port( 
    clk        : in std_logic; --MCLK                                            
    reset_n    : in std_logic; --Reset asíncrono a nivel alto del sistema global 
    SW13       : in std_logic; --RSTA                
    enable_in  : in std_logic; --Enable proporcionado por el i2s2                
    SW5        : in std_logic; --Switches de control para el looper --> Write
    SW6        : in std_logic; --Switches de control para el looper --> Read                
    l_data_in  : in std_logic_vector(g_width-1 downto 0);             
    r_data_in  : in std_logic_vector(g_width-1 downto 0);                             
    l_data_out : out std_logic_vector(g_width-1 downto 0);                        
    r_data_out : out std_logic_vector(g_width-1 downto 0)
);
end component;

signal clk, reset_n, enable_in, enable_out, SW5, SW6, SW13 : std_logic;
signal l_data_in, l_data_out, r_data_in, r_data_out : std_logic_vector(g_width-1  downto 0);

constant clk_period : time := 89ns;

begin

  Unit_EfectLOOPER : efecto_looper
    generic map(g_width => 14, d_deep => 19)
    port map(
       clk        => clk,
       reset_n    => reset_n, 
       SW13       => SW13,
       enable_in  => enable_in,
       SW5        => SW5,
       SW6        => SW6,
       l_data_in  => l_data_in, 
       r_data_in  => r_data_in, 
       l_data_out => l_data_out, 
       r_data_out => r_data_out
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
       reset_n <= '1';
       SW5 <= '0';
       SW6 <= '0';
       SW13 <= '0';
       enable_in <= '0';
       l_data_in <= "00001111000011";
       r_data_in <= "11110000111100";
       wait for 10*clk_period;
       
       reset_n <= '0';
       SW5 <= '0';
       SW6 <= '0';
       SW13 <= '0';
       enable_in <= '0';
       l_data_in <= "00001111000011";
       r_data_in <= "11110000111100";
       wait for 10*clk_period;
       
       reset_n <= '0';
       SW5 <= '1';
       SW6 <= '0';
       SW13 <= '0';
       enable_in <= '1';
       l_data_in <= "00001111000011";
       r_data_in <= "11110000111100";
       wait for 10*clk_period;
       
       reset_n <= '0';
       SW5 <= '1';
       SW6 <= '0';
       SW13 <= '0';
       enable_in <= '1';
       l_data_in <= "00001001000011";
       r_data_in <= "11110110111100";
       wait for 10*clk_period;
       
       reset_n <= '0';
       SW5 <= '1';
       SW6 <= '0';
       SW13 <= '0';
       enable_in <= '1';
       l_data_in <= "11001001000011";
       r_data_in <= "00110110111100";
       wait for 10*clk_period;
                           
       reset_n <= '0';
       SW5 <= '1';
       SW6 <= '1';
       SW13 <= '0';
       enable_in <= '1';
       l_data_in <= "00000000000000";
       r_data_in <= "00110111111111";
       wait for 90*clk_period;
       
       reset_n <= '1';
       SW5 <= '1';
       SW6 <= '0';
       SW13 <= '0';
       wait for 200*clk_period;
       
       reset_n <= '0';
       SW5 <= '1';
       SW6 <= '1';
       SW13 <= '0';
       enable_in <= '1';
       l_data_in <= "00000000000000";
       r_data_in <= "00110111111111";
       wait for 100*clk_period;
       
       reset_n <= '0';
       SW5 <= '0';
       SW6 <= '0';
       SW13 <= '0';
       wait;
       
   end process;
end Behavioral;
