----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 13.10.2019 10:44:14
-- Design Name: 
-- Module Name: LEDs - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Este fichero toma una funciñon de vumetro con el canal derecho, a través de los 15 Leds
--              que dispone la Nexys podemos ver que nivel de señal esta entrado y procesando.
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

entity LEDs is
GENERIC(
    d_width          :  INTEGER := 16);  --data width
Port ( 
    clk  : in STD_LOGIC; --MCLK
    reset : in STD_LOGIC; --Reset asíncrono a nivel alto del sistema global
    play_enable : in STD_LOGIC; --Enable que activa el sistema 
    r_data_rx : in STD_LOGIC_VECTOR (d_width-1 downto 0); --Canal derecho de audio a la entrada
    LEDs : out STD_LOGIC_VECTOR (d_width-1 downto 0) --Vector de 15 Leds en la Nexys A7
);
end LEDs;

architecture Behavioral of LEDs is

begin
  
process(clk, r_data_rx, play_enable, reset) --Proceso sensible al reloj de MCLK
begin
    if rising_edge(clk) then
        if(reset = '1') then
          LEDs <= "0000000000000000";
        elsif(play_enable = '1') then
            if(r_data_rx <= "000000000000000") then
              LEDs <= "0000000000000000"; --Señal nula
              
            elsif(r_data_rx <= "1000000000000000") then
              LEDs <= "0000000000000001"; 
              
            elsif(r_data_rx <= "1100000000000000") then
              LEDs <= "0000000000000011";
              
            elsif(r_data_rx <= "1110000000000000") then
              LEDs <= "0000000000000111";
              
            elsif(r_data_rx <= "1111000000000000") then
              LEDs <= "0000000000001111";
              
            elsif(r_data_rx <= "1111100000000000") then
              LEDs <= "0000000000011111";
              
            elsif(r_data_rx <= "1111110000000000") then
              LEDs <= "0000000000111111";
              
            elsif(r_data_rx <= "1111111000000000") then
              LEDs <= "0000000001111111";
              
            elsif(r_data_rx <= "1111111100000000") then
              LEDs <= "0000000011111111";
              
            elsif(r_data_rx <= "1111111110000000") then
              LEDs <= "0000000111111111";
                
            elsif(r_data_rx <= "1111111111000000") then
              LEDs <= "0000001111111111";
              
            elsif(r_data_rx <= "1111111111100000") then
              LEDs <= "0000011111111111";
              
            elsif(r_data_rx <= "1111111111110000") then
              LEDs <= "0000111111111111";
              
            elsif(r_data_rx <= "1111111111111000") then
              LEDs <= "0001111111111111"; 
              
            elsif(r_data_rx <= "1111111111111100") then
              LEDs <= "0011111111111111";
              
            elsif(r_data_rx <= "1111111111111110") then
              LEDs <= "0111111111111111"; 
              
            elsif(r_data_rx <= "1111111111111111") then
              LEDs <= "1111111111111111";     
            else
              LEDs <= "0000000000000000";
            end if;
        else
            LEDs <= "1001101001011001"; --Si el dispostivo esta pausado, se muestra una secuencia
        end if;                         --de Leds arbitraria no consecutiva.
    end if;
end process;
  
end Behavioral;