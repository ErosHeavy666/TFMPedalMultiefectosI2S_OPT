----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 16.11.2019 16:36:38
-- Design Name: 
-- Module Name: EfectoOVERDRIVE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Si las señales de entrada tienen una ganancia superior al umbral fijado se saturan y 
--              quedan acotadas a la ganancia de este umbral
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

entity EfectoOVERDRIVE is
GENERIC(
    d_width         : INTEGER := 16 --Ancho del bus 
    );
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
end EfectoOVERDRIVE;

architecture Behavioral of EfectoOVERDRIVE is

signal l_data_in_reg, l_data_in_next, r_data_in_reg, r_data_in_next: signed (d_width-1  downto 0);
signal l_data_out_aux, r_data_out_aux: signed ((d_width-1) downto 0);
signal Vth_negative : signed (d_width-1  downto 0) := "1110000000000000"; --Umbral negativo
signal Vth_positive : signed (d_width-1  downto 0) := "0011000000000000"; --Umbral positivo

begin

--State register
process(clk, reset_n, enable_in)
begin
    if(reset_n = '1') then
        l_data_in_reg <= (others => '0');
        r_data_in_reg <= (others => '0');
    elsif (rising_edge(clk)) then --MCLK
        if(enable_in = '1')then
            l_data_in_reg <= l_data_in_next;
            r_data_in_reg <= r_data_in_next;
        end if;
    end if;  
end process;

--Next state
process(clk, reset_n, enable_in, l_data_in, r_data_in, enable_in, l_data_in_reg, r_data_in_reg, Vth_positive, Vth_negative)
begin
    if reset_n = '1' then
        l_data_out_aux <= (others => '0');
        r_data_out_aux <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            l_data_in_next <= signed(l_data_in);
            r_data_in_next <= signed(r_data_in);
            if((0 <= l_data_in_reg) and (l_data_in_reg < Vth_positive)) then
                l_data_out_aux <= l_data_in_reg;
                
            elsif(l_data_in_reg >= Vth_positive) then
                l_data_out_aux <= Vth_positive;
                
            elsif((l_data_in_reg > Vth_negative) and (l_data_in_reg < 0))then
                l_data_out_aux <= l_data_in_reg;
                
            elsif(l_data_in_reg <= Vth_negative) then
                l_data_out_aux <= Vth_negative;
                
            end if;
            
            if((0 <= r_data_in_reg) and (r_data_in_reg < Vth_positive))then
                r_data_out_aux <= r_data_in_reg;
                
            elsif(r_data_in_reg > Vth_positive) then
                r_data_out_aux <= Vth_positive;
                
            elsif((r_data_in_reg > Vth_negative) and (r_data_in_reg < 0))then
                r_data_out_aux <= r_data_in_reg;
                
            elsif(r_data_in_reg <= Vth_negative) then
                r_data_out_aux <= Vth_negative;
            end if;
        end if;
    end if;  
end process; 

--Output logic
l_data_out <= STD_LOGIC_VECTOR(l_data_out_aux);   
r_data_out <= STD_LOGIC_VECTOR(r_data_out_aux); 

end Behavioral;
