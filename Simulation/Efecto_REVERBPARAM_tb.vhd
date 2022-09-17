----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2019 12:45:46
-- Design Name: 
-- Module Name: Efecto_REVERBPARAM_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Efecto_REVERBPARAM_tb is
--  Port ( );
end Efecto_REVERBPARAM_tb;

architecture Behavioral of Efecto_REVERBPARAM_tb is

component EfectoREVERB_PARAMETRIZADO is
GENERIC(
    n1              : INTEGER := 1500;
    d_width         : INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    BTNC                  : in STD_LOGIC; 
    BTNL                  : in STD_LOGIC; 
    BTND                  : in STD_LOGIC; 
    BTNR                  : in STD_LOGIC; --Control de la línea de retardo
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

constant d_width : INTEGER := 16;
signal clk, reset_n, enable_in, enable_out, BTNC, BTNL, BTND, BTNR : STD_LOGIC;
signal l_data_in, l_data_out, r_data_in, r_data_out : STD_LOGIC_VECTOR (d_width-1  downto 0);
constant  clk_period : time := 89ns;

begin

Unit_EfectREVERB_PARAMETRIZADO : EfectoREVERB_PARAMETRIZADO
GENERIC MAP(n1 => 1500, d_width => 16)
PORT MAP(
      clk         =>  clk         ,
      reset_n     =>  reset_n     ,
      enable_in   =>  enable_in   ,
      BTNC        =>  BTNC        ,
      BTNL        =>  BTNL        ,
      BTND        =>  BTND        ,
      BTNR        =>  BTNR        ,
      l_data_in   =>  l_data_in   ,
      l_data_out  =>  l_data_out  ,
      r_data_in   =>  r_data_in   ,
      r_data_out  =>  r_data_out  ,
      enable_out  =>  enable_out  
);

clk_process :process
begin    
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process; 

stim_proc: process 
begin
    reset_n <= '1';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period; 
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;  

    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period; 
     
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;  
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '0';
    BTNL <= '0';
    BTND <= '0';
    BTNR <= '0';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;   
    
    reset_n <= '0';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait for 10*clk_period;     
          
    reset_n <= '1';
    BTNC <= '1';
    BTNL <= '1';
    BTND <= '1';
    BTNR <= '1';
    enable_in <= '1';
    l_data_in <= "0000111100001111";
    r_data_in <= "1111000011110000";
    wait;   
                      
end process;      
end Behavioral;
