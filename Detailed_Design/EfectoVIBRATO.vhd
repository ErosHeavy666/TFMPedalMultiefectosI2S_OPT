----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros Garcia Arroyo
-- 
-- Create Date: 03.10.2019 21:11:55
-- Design Name: 
-- Module Name: 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: Se toma únicamente la señal retardada y se modula su retardo mediante una sinusoide
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

entity EfectoVIBRATO is
GENERIC(
    n               :  INTEGER := 500; --Línea de retardo
    d_width         :  INTEGER := 16); --Ancho del bus    
Port ( 
    clk                   : in STD_LOGIC;--MCLK                                            
    reset_n               : in STD_LOGIC;--Reset asíncrono a nivel alto del sistema global 
    enable_in             : in STD_LOGIC;--Enable proporcionado por el i2s2                
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada izquierdos;  
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida izquierdos;  
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada derechos;    
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida derechos;    
    enable_out            : out STD_LOGIC  --Enable out para la señal i2s2
); 
end EfectoVIBRATO;

architecture Behavioral of EfectoVIBRATO is
type fifo_t is array (0 to n-1) of signed(d_width-1 downto 0);
signal l_data_next, l_data_reg, r_data_reg, r_data_next : fifo_t; 
signal wave_out_retard : sine_vector_type;

component sine_wave is
  port( clk, reset_n, enable_in: in std_logic;
        wave_out: out sine_vector_type);
end component;

begin

Unit_sine_wave : sine_wave 
PORT MAP(
    clk => clk,
    reset_n => reset_n,
    enable_in => enable_in,
    wave_out => wave_out_retard
);

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_reg <= (others => (others => '0'));
        r_data_reg <= (others => (others => '0'));  
    elsif (rising_edge(clk)) then --MCLK
        if(enable_in = '1')then
            l_data_reg <= l_data_next;
            r_data_reg <= r_data_next;
        end if;
    end if;
end process;

process (l_data_in, l_data_reg, r_data_in, r_data_reg)
begin
    l_data_next(0) <= signed(l_data_in);
    r_data_next(0) <= signed(r_data_in);
    for i in 1 to n-1 loop
        l_data_next(i) <= l_data_reg(i-1);
        r_data_next(i) <= r_data_reg(i-1);
    end loop;
 end process;

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_out <= (others => '0');
        r_data_out <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            l_data_out <= std_logic_vector(shift_right(l_data_reg(n-to_integer(unsigned(wave_out_retard))-1),1));
            r_data_out <= std_logic_vector(shift_right(r_data_reg(n-to_integer(unsigned(wave_out_retard))-1),1));
        end if;
    end if;
end process;

end Behavioral;
