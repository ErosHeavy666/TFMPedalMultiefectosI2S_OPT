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

constant d_width : INTEGER := 16;
constant d_deep  : INTEGER := 19;

component EfectoLOOPER is
GENERIC(
    d_width         : INTEGER := 16;
    d_deep          : INTEGER := 19
    );
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    SW13                  : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    SW5                   : IN STD_LOGIC;
    SW6                   : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

signal clk, reset_n, enable_in, enable_out, SW5, SW6, SW13 : STD_LOGIC;
signal l_data_in, l_data_out, r_data_in, r_data_out : STD_LOGIC_VECTOR (d_width-1  downto 0);

constant  clk_period : time := 89ns;

begin

Unit_EfectLOOPER : EfectoLOOPER 
GENERIC MAP(d_width => 16, 
            d_deep => 19 
            )
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in ,
     SW5 => SW5,
     SW6 => SW6,
     SW13 => SW13,
     l_data_in => l_data_in   , 
     l_data_out => l_data_out  , 
     r_data_in => r_data_in  , 
     r_data_out => r_data_out  ,
     enable_out => enable_out
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
          l_data_in <= "0000111100001111";
          r_data_in <= "1111000011110000";
          wait for 10*clk_period;
          
          reset_n <= '0';
          SW5 <= '0';
          SW6 <= '0';
          SW13 <= '0';
          enable_in <= '0';
          l_data_in <= "0000111100001111";
          r_data_in <= "1111000011110000";
          wait for 10*clk_period;
          
          reset_n <= '0';
          SW5 <= '1';
          SW6 <= '0';
          SW13 <= '0';
          enable_in <= '1';
          l_data_in <= "0000111100001100";
          r_data_in <= "1111000011110011";
          wait for 10*clk_period;
          
          reset_n <= '0';
          SW5 <= '1';
          SW6 <= '0';
          SW13 <= '0';
          enable_in <= '1';
          l_data_in <= "0000100100001100";
          r_data_in <= "1111011011110011";
          wait for 10*clk_period;
          
          reset_n <= '0';
          SW5 <= '1';
          SW6 <= '0';
          SW13 <= '0';
          enable_in <= '1';
          l_data_in <= "1100100100001100";
          r_data_in <= "0011011011110011";
          wait for 10*clk_period;
                              
          reset_n <= '0';
          SW5 <= '1';
          SW6 <= '1';
          SW13 <= '0';
          enable_in <= '1';
          l_data_in <= "0000000000001111";
          r_data_in <= "0011011111110011";
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
          l_data_in <= "0000000000001111";
          r_data_in <= "0011011111110011";
          wait for 100*clk_period;
          
          reset_n <= '0';
          SW5 <= '0';
          SW6 <= '0';
          SW13 <= '0';
          wait;
          
      end process;
end Behavioral;
