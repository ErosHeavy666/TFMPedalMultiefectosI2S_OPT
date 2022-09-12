----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo y Daniel Payno Zarceño
-- 
-- Create Date: 05.12.2018 12:46:40
-- Design Name: 
-- Module Name: register - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
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

entity reg is
GENERIC(
    d_width         :  INTEGER := 16);
Port (
        clk_12megas: in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
        enable: in STD_LOGIC; --Enable que activa el FF de tipo D (se asociará con Sample_In_Enable)
        reset: in STD_LOGIC; --Reset síncrono del sistema 
        dato_in : in SIGNED(d_width-1 downto 0); --Datos de entrada -> Sample_In -> Xn
        dato_out: out SIGNED(d_width-1 downto 0) --Datos de salida -> Xn -> Sample_Out
        );
end reg;

architecture Behavioral of reg is

begin

process(clk_12megas) --Proceso sensible a los flancos de subida del reloj general del sistema
    begin
        if(rising_edge(clk_12megas))  then
            if(reset = '1') then --Si el reset esta a uno en un evento de subida del reloj
                dato_out <= (others => '0'); --Se escribe un "00000000" a la salida del registro
            elsif (enable = '1') then --Si el reset no esta activado y se detecta que enable esta a uno en
                dato_out <= dato_in;  --un evento de subida del reloj, este coloca en la salida 
            end if;                   --el valor de la entrada
        end if;
    end process;  
end Behavioral;
