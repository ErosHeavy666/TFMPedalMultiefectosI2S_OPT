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
use work.sine_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EfectoBANKFILTER is
GENERIC(
    d_width         :  INTEGER := 16); --Ancho del bus
Port ( 
    clk                   : in STD_LOGIC; --MCLK
    reset_n               : in STD_LOGIC; --Reset asíncrono a nivel alto del sistema global
    enable_in             : in STD_LOGIC; --Enable proporcionado por el i2s2 
    SW14                  : IN STD_LOGIC; --Switch de control para el tipo de filtro
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada izquierdos;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida izquierdos;
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada derechos;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida derechos;
    enable_out            : out STD_LOGIC --Enable out para la señal i2s2
); 
end EfectoBANKFILTER;

architecture Behavioral of EfectoBANKFILTER is
            
    signal l_data_reg, r_data_reg: signed(d_width-1 downto 0);    
    --signal wave_out_retard : sine_vector_type;
    signal filter_select_aux : STD_LOGIC;    
    signal sample_out_ready_aux : STD_LOGIC;
    
component Fir_Filter_bankfilter is
GENERIC(
    d_width         :  INTEGER := 16);
Port (  clk_12megas : in STD_LOGIC; --MCLK
        Reset : in STD_LOGIC;  --Reset asíncrono a nivel alto del sistema global
        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,15>
        Sample_In_enable : in STD_LOGIC; --Enable proporcionado por el i2s2                                       
        filter_select: in STD_LOGIC; --0 lowpass 1 highpass
        Sample_Out : out signed (d_width-1 downto 0); --Muestras de salida codificadas en <1,15>
        Sample_Out_ready : out STD_LOGIC); --Enable out para la señal filtrada
                                                 
end component;

--******

--component sine_wave_bankfilter is
--  port( clk, reset_n, enable_in: in std_logic;
--        wave_out: out sine_vector_type);
--end component;

begin

--Unit_sine_wave_bankfilter : sine_wave_bankfilter 
--PORT MAP(
--    clk => clk,
--    reset_n => reset_n,
--    enable_in => enable_in,
--    wave_out => wave_out_retard
--);

--process(wave_out_retard) --Filtrado automático cada segundo --> Si se quiere así hay que descomentar las líneas con * y comentar el process siguiente
--begin
--    if(wave_out_retard >= "00000000" and wave_out_retard <= "01111111") then
--        filter_select_aux <= '1';                          
--    else  
--        filter_select_aux <= '0';
--    end if;
--end process;

process(SW14) --Elección del filtrado manual --> Si se habilita el filtrado automático hay que comentar estas líneas 
begin
    if(SW14 = '1') then --HPF
        filter_select_aux <= '1';                          
    else  --LPF
        filter_select_aux <= '0';
    end if;
end process;

--******

Unit_FIR_Filter_bankfilter_L : Fir_Filter_bankfilter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => signed(l_data_in),
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => l_data_reg,
    Sample_Out_ready => sample_out_ready_aux
);

Unit_FIR_Filter_bankfilter_R : Fir_Filter_bankfilter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => signed(r_data_in),
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => r_data_reg,
    Sample_Out_ready => open
);

process(clk, reset_n, sample_out_ready_aux, enable_in)
begin
    if reset_n = '1' then
        l_data_out <= (others => '0');
        r_data_out <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(sample_out_ready_aux = '1')then
            l_data_out <= std_logic_vector(l_data_reg);
            r_data_out <= std_logic_vector(r_data_reg);         
        end if;
    end if;
end process;

end Behavioral;
