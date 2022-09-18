----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo y Daniel Payno Zarceño
-- 
-- Create Date: 12.12.2018 12:52:04
-- Design Name: 
-- Module Name: controlador_fir - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_fir_bankfilter is
Port (                                    
    clk_12megas       : in STD_LOGIC;                
    reset             : in STD_LOGIC; 
    sample_in_enable  : in STD_LOGIC;                     
    s_M12             : out STD_LOGIC_VECTOR (3 downto 0); 
    s_M3              : out STD_LOGIC;   
    Sample_Out_Ready  : out STD_LOGIC                     
);
end controlador_fir_bankfilter;

architecture Behavioral of controlador_fir_bankfilter is

     type state_type is(idle, op);             --Hay dos posibles estados, el Idle y Op
     signal state_reg, state_next: state_type; --Señales para tener los diferentes estados del ASMD implementado
     signal cuenta_reg, cuenta_next: unsigned(3 downto 0); --Señales para llevar la cuenta del control, va de 0 a 7
     signal sample_out_ready_aux: STD_LOGIC; --Salida auxliar de Sample_out_ready
     signal s_M12_aux: STD_LOGIC_VECTOR (3 downto 0); --Señal selectora de los Mux 1 y 2
     signal s_M3_aux : STD_LOGIC; --Señal selectora del Mux 3 
                                           


begin


process(clk_12megas) --Proceso sensible al reloj de 12 MHz
    begin
        if rising_edge(clk_12megas) then --Detectamos un cambio de 0 a 1
            --Cada flanco de reloj de subida actualizamos los registros de estado
             state_reg <= state_next;  
             cuenta_reg <= cuenta_next;      
        end if;
    end process;

process(reset, state_next, state_reg, cuenta_next, cuenta_reg, sample_in_enable) --Ponemos en la lista todos los procesos sensibles a cambio    
       
        begin
        --Inicialización de las señales
        cuenta_next <= cuenta_reg;
        state_next <= op;
        sample_out_ready_aux <= '0';
        s_M3_aux <= '0';
        s_M12_aux <= (others => '0');

        case state_reg is               --Case para los posibles estados del diagrama ASMD
            
            when idle =>                --Lógica del estado idle del diagrama ASMD
                state_next <= op;

            when op =>
                if(reset = '1') then
                    cuenta_next <= (others => '0');
                    state_next <= op;
                    sample_out_ready_aux <= '0';
                    s_M3_aux <= '0';
                    s_M12_aux <= (others => '0');

                else --Si el reset no esta activado pasamos a comprobar la cuenta del proceso
                    if((cuenta_reg >= 0) and (cuenta_reg <= 14)) then
                        sample_out_ready_aux <= '0';

                        case cuenta_reg is
                              when "0000"  => 
                                    if (sample_in_enable ='1') then
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '0';
                                    cuenta_next <= cuenta_reg + 1;
                                    end if;
                              when "0001"  => 
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '0';
                                    cuenta_next <= cuenta_reg + 1;
                              when "0010"  =>
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '0';
                                    cuenta_next <= cuenta_reg + 1;
                              when "0011"  =>
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '1';
                                    cuenta_next <= cuenta_reg + 1;
                              when "0100"  => 
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '1'; 
                                    cuenta_next <= cuenta_reg + 1;
                              when "0101" =>
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '1';
                                    cuenta_next <= cuenta_reg + 1;
                              when "0110" =>
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '1';
                                    cuenta_next <= cuenta_reg + 1;
                              when "0111" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1; 
                              when "1000" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1;
                              when "1001" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1;   
                              when "1010" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1;  
                              when "1011" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1;
                              when "1100" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1; 
                              when "1101" =>                                        
                                    s_M12_aux <= std_logic_vector(cuenta_reg);      
                                    s_M3_aux <= '1';                                
                                    cuenta_next <= cuenta_reg + 1;                                                             
                              when others =>
                                    s_M12_aux <= std_logic_vector(cuenta_reg);
                                    s_M3_aux <= '1';
                                    cuenta_next <= cuenta_reg + 1;
                        end case;
                        state_next <= op;

                    else--Cuando la cuenta llegue a 7 se pone todo a cero y se muestra una salida
                       --Para ello, asiganmos sample_out_ready = '1' durante un ciclo de reloj
                        cuenta_next <= (others => '0');
                        sample_out_ready_aux <= '1';
                        s_M12_aux <= std_logic_vector(cuenta_reg);
                        s_M3_aux <= '1';
                        state_next <= op;
                    end if;
                end if;
        end case;
    end process;




    --Asignación de las señales auxiliares del control con las salidas generales que se usaran en el fichero principal 
    --del filtro Fir
    Sample_Out_Ready <= sample_out_ready_aux; 
    s_M3 <= s_M3_aux;
    s_M12 <= s_M12_aux;


end Behavioral;