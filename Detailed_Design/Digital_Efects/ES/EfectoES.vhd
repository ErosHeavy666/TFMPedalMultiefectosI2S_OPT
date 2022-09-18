----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 03.10.2019 21:11:55
-- Design Name: 
-- Module Name: 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Efecto de bypass. La señal de entrada se registra y sale tal cual a la salida. 
--              Se podría definir como efecto buffer para probar que el i2s2 funciona 
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

entity EfectoES is
GENERIC(
    d_width         :  INTEGER := 16); --Ancho del bus
Port ( 
    clk                   : in STD_LOGIC; --MCLK
    reset_n               : in STD_LOGIC; --Reset asíncrono a nivel alto del sistema global 
    enable_in             : IN STD_LOGIC; --Enable proporcionado por el i2s2                
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada izquierdos;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida izquierdos;
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada derechos;  
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida derechos;  
    enable_out            : out STD_LOGIC --Enable out para la señal i2s2
);
end EfectoES;

architecture Behavioral of EfectoES is

begin 

process(clk, reset_n, enable_in)
begin
    if(reset_n = '1') then
        l_data_out <= (others => '0');
        r_data_out <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            l_data_out <= l_data_in;
            r_data_out <= r_data_in;
        end if;
    end if;
end process;

end Behavioral;
