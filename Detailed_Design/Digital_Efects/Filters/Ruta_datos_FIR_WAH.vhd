----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo y Daniel Payno Zarceño
-- 
-- Create Date: 08.12.2018 21:58:38
-- Design Name: 
-- Module Name: Ruta_datos_Fir - Behavioral
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

entity Ruta_datos_Fir_bankfilter is
GENERIC(
    d_width         :  INTEGER := 16);
Port (  s_M12: in STD_LOGIC_VECTOR(3 downto 0); --Señan de control del Mux con los registros R1 y R2
        s_M3: in STD_LOGIC; --Señal de control del Mux para el registro R3
        clk_12megas: in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
        reset: in STD_LOGIC; --Reset síncrono general del Fir
        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,7>
        Sample_In_enable : in STD_LOGIC;--entrada de control que informa de cuando se ha actualizado el
                                        --valor de Sample_In con un pulso activo durante un ciclo de reloj.
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (d_width-1 downto 0) --Muestras de salida codificadas en <1,7>
       ); 
end Ruta_datos_Fir_bankfilter;

architecture Behavioral of Ruta_datos_Fir_bankfilter is

signal x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15 : std_logic_vector (d_width-1 downto 0); --Señales auxiliares para los registros de la ruta de datos
signal c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15 : std_logic_vector (d_width-1 downto 0);  --Coeficientes del filtrado FIR

component register_d is --Declaracion estructural para el fichero reg
  generic(
    g_width : integer := 16);
  port (
    clk     : in std_logic; --Entrada del reloj general del sistema de 12MHz
    n_reset : in std_logic; --Reset síncrono del sistema 
    i_en    : in std_logic; --Enable que activa el FF de tipo D (se asociará con Sample_In_Enable)
    i_data  : in std_logic_vector(g_width-1 downto 0); --Datos de entrada -> Sample_In -> Xn
    o_data  : out std_logic_vector(g_width-1 downto 0) --Datos de salida -> Xn -> Sample_Out
  );
end component;
   --Señales auxiliares de registros y operaciones de lógica combinacional de la ruta de datos diseñada
    signal R1_reg, R2_reg, R1_next, R2_next : signed((d_width*2 - 2) downto 0); --Registros R1 y R2
    signal mult_aux: signed((d_width*2 - 1) downto 0); --Multiplicación
    signal R3_reg, R3_next: signed(d_width-1 downto 0); --Registros R3
    signal M3_aux, M2_aux, M1_aux : signed(d_width-1 downto 0); 
    signal mult : signed (d_width*2-2 downto 0);
    signal sample_out_aux : signed(d_width-1 downto 0); 
    
begin

--FIR-filter-Ruta de datos-Flujo de los datos Xn con sus Cn
register_d_0: register_d
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => std_logic_vector(Sample_in), --Registramos Sample_In
     o_data => x0
);  
register_d_1: register_d
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x0,
     o_data => x1
);                               
register_d_2: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x1,
     o_data => x2
);                                 
register_d_3: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x2,
     o_data => x3
);                                
register_d_4: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x3,
     o_data => x4
);                                
register_d_5: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x4,
     o_data => x5
);      
register_d_6: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x5,
     o_data => x6
);      
register_d_7: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x6,
     o_data => x7
);      
register_d_8: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x7,
     o_data => x8
);      
register_d_9: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x8,
     o_data => x9
);      
register_d_10: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x9,
     o_data => x10
);      
register_d_11: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x10,
     o_data => x11
);      
register_d_12: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x11,
     o_data => x12
);      
register_d_13: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x12,
     o_data => x13
);      
register_d_14: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x13,
     o_data => x14
);         
register_d_15: register_d                            
GENERIC MAP (g_width => 16)
PORT MAP(
     clk => clk_12megas,  
     n_reset => reset,
     i_en =>  Sample_In_enable,
     i_data => x14,
     o_data => x15
);      
                                                    
process(clk_12megas) --Proceso que si 
begin
    if(rising_edge(clk_12megas)) then --detecta un flanco de subida del reloj general del sistema
        if(reset = '1') then --Y el reset se encuentra activado, pondra a cero los registros R1,R2,R3
            R3_reg <= (others => '0');
            R2_reg <= (others => '0');
            R1_reg <= (others => '0');
        else --Y si esta desactivado cargara en el registro de los registros el valor actualizado antes del flanco 
            R3_reg <= R3_next; --sobre el valor combinacional registrado
            R2_reg <= R2_next;
            R1_reg <= R1_next;
        end if;
    end if;
end process;  

process(filter_select) --Selección del tipo de filtrado que deseamos realizar
begin                
    if (filter_select = '1') then --LPF   
        c0 <= "1111111111011111";
        c1 <= "0000001011110010";
        c2 <= "0000011000000100";
        c3 <= "0000011011001001";
        c4 <= "0000101000111101";
        c5 <= "0000110000001000";
        c6 <= "0000111000010100";
        c7 <= "0000111011011001";
        c8 <= "0000111011011001";
        c9 <= "0000111000010100";
        c10 <= "0000110000001000";
        c11 <= "0000101000111101";
        c12 <= "0000011011001001";  
        c13 <= "0000011000000100";
        c14 <= "0000001011110010";
        c15 <= "1111111111011111";   
    else  --HPF      
        c0 <= "0000000101001000";
        c1 <= "0000001011110010";
        c2 <= "1111001110010111";
        c3 <= "1111111110011110";
        c4 <= "1110101010100000";   
        c5 <= "0000000111101100"; 
        c6 <= "1101010111000011"; 
        c7 <= "0100000010000011"; 
        c8 <= "0100000010000011"; 
        c9 <= "1101010111000011";  
        c10 <= "0000000111101100";  
        c11 <= "1110101010100000"; 
        c12 <= "1111111110011110"; 
        c13 <= "1111001110010110"; 
        c14 <= "0000001011110010";
        c15 <= "0000000101001000";    
            
    end if;
end process;

--Proceso encargado de suministrar los coeficientes de Cn a las señales de ruta Xn
process (s_M12,M1_aux,M2_aux,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,
                             x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15) 
begin
    case s_M12 is
      when "0000"  => 
            M1_aux <= signed(c0);
            M2_aux <= signed(x0);
      when "0001"  => 
            M1_aux <= signed(c1);
            M2_aux <= signed(x1);
      when "0010"  =>
            M1_aux <= signed(c2);
            M2_aux <= signed(x2);
      when "0011"  =>
            M1_aux <= signed(c3);
            M2_aux <= signed(x3);
      when "0100"  =>
            M1_aux <= signed(c4);
            M2_aux <= signed(x4);    
      when "0101"  =>
            M1_aux <= signed(c5);
            M2_aux <= signed(x5);
      when "0110"  =>    
            M1_aux <= signed(c6);      
            M2_aux <= signed(x6);
      when "0111"  =>          
            M1_aux <= signed(c7);      
            M2_aux <= signed(x7);     
      when "1000"  =>          
            M1_aux <= signed(c8);      
            M2_aux <= signed(x8);   
      when "1001"  =>          
            M1_aux <= signed(c9);      
            M2_aux <= signed(x9);      
      when "1010"  =>    
            M1_aux <= signed(c10);      
            M2_aux <= signed(x10);
      when "1011"  =>     
            M1_aux <= signed(c11);
            M2_aux <= signed(x11);
      when "1100"  =>     
            M1_aux <= signed(c12);
            M2_aux <= signed(x12);
      when "1101"  =>     
            M1_aux <= signed(c13);
            M2_aux <= signed(x13);
      when "1110"  =>     
            M1_aux <= signed(c14);
            M2_aux <= signed(x14);               
      when others  => 
            M1_aux <= signed(c15);
            M2_aux <= signed(x15);   
    end case;
end process;

--Proceso que multiplica las señales del flujo por los correspondientes coeficientes       
process(M1_aux, M2_aux, mult_aux)
begin
    mult_aux <= M1_aux * M2_aux; --Cn*Xn
    mult <= mult_aux(d_width*2-2 downto 0);
end process;

--Proceso que carga en R1 el valor de mult    
process(mult)
begin
    R1_next <= mult;    
end process;

--Proceso que carga en R2 el valor de R1, la síntesis esto la va a asociar como dos medios multiplicadores
process(R1_reg)
begin    
    R2_next <= R1_reg;    
end process;

--Proceso que coloca a la salida del Mux3 el R3 o "00000000"
process(s_M3, R3_reg)
begin
    if(s_M3 = '1') then
         M3_aux <=  R3_reg;
    else 
         M3_aux <= (others => '0');
    end if;            
end process;

--Proceso que suma la salida del Mux3 con los 8 bits más significativos del registro R2 y los asocia a R3
process(R2_reg, M3_aux)
begin         
    R3_next <= R2_reg(d_width*2-2 downto d_width*2-2-15) + M3_aux;
end process;

--Proceso que asigna a la señal auxiliar de salida el valor del registro R3 calcilado anteriormente 
process(R3_reg)
begin 
    sample_out_aux <= R3_reg(d_width-1 downto 0);
end process;

--Output
Sample_out <= sample_out_aux;
        
end Behavioral;
