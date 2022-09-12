----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 17.11.2019 22:28:52
-- Design Name: 
-- Module Name: EfectoLOOPER - Behavioral
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
use IEEE.STD_LOGIc_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EfectoLOOPER is
GENERIC(
    d_width         : INTEGER := 16; --Ancho del bus  
    d_deep          : INTEGER := 19); --Ancho de la memoria RAM
Port ( 
    clk                   : in STD_LOGIC;--MCLK                                            
    reset_n               : in STD_LOGIC;--Reset asíncrono a nivel alto del sistema global 
    SW13                  : in STD_LOGIC;--RSTA                
    enable_in             : IN STD_LOGIC;--Enable proporcionado por el i2s2                
    SW5                   : IN STD_LOGIC;--Switches de control para el looper --> Write
    SW6                   : IN STD_LOGIC;--Switches de control para el looper --> Read
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada izquierdos; 
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida izquierdos; 
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada derechos;   
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida derechos;   
    enable_out            : out STD_LOGIC  --Enable out para la señal i2s2
);
end EfectoLOOPER;

architecture Behavioral of EfectoLOOPER is

signal ena_RAM : STD_LOGIC;
signal wea_RAM : STD_LOGIC_VECTOR (0 downto 0);
signal dina_RAM, douta_RAM : STD_LOGIC_VECTOR ((d_width/2-1) downto 0);
signal addra_RAM : STD_LOGIC_VECTOR (d_deep-1 downto 0);

-- Señales para la máquina de estados
signal addra_reg, addra_next, addra_max_reg, addra_max_next : std_logic_vector(d_deep-1 DOWNTO 0);
signal dina_reg, dina_next: STD_LOGIC_VECTOR ((d_width/2-1) downto 0);
type state_type is(inicio, rec, play_fw); --Lista con el número de estados
signal state_reg, state_next: state_type;

component blk_mem_gen_1 is
PORT (
    clka    : IN STD_LOGIC;
    ena     : IN STD_LOGIC;
    rsta    : IN STD_LOGIC;
    wea     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra   : IN STD_LOGIC_VECTOR(d_deep-1 DOWNTO 0);
    dina    : IN STD_LOGIC_VECTOR((d_width/2-1) DOWNTO 0);
    douta   : OUT STD_LOGIC_VECTOR((d_width/2-1) DOWNTO 0)
);
end component;

begin

Unit_RAM : blk_mem_gen_1 PORT MAP (
    clka  => clk,
    rsta  => SW13,
    ena   => ena_RAM,
    wea   => wea_RAM,
    addra => addra_RAM,
    dina  => dina_RAM,
    douta => douta_ram 
);

--ASMD--------------------------------------------
--state and data registers
    process(clk) 
    begin
    if rising_edge(clk) then 
         state_reg <= state_next;
         addra_reg <= addra_next;
         addra_max_reg <= addra_max_next;
         dina_reg <= dina_next;
    end if;
end process;
process (state_reg, reset_n, dina_reg, r_data_in, wea_RAM, addra_max_reg, addra_reg, enable_in, ena_RAM, SW5, SW6) 
begin
        --Inicialización de las señales
        addra_next <= addra_reg;
        addra_max_next <= addra_max_reg;  
        dina_next <= (others => '0');
        state_next <= inicio;
        
    case state_reg is
        
    when inicio =>
        if (reset_n = '1') then 
            addra_next <= addra_reg + "1";
            dina_next <= (others => '0');
            addra_max_next <= (others => '0');
            state_next <= inicio; 
        elsif (ena_RAM = '1') then
            -- Grabación
            dina_next <= r_data_in(15 downto 8);
            if(wea_RAM = "1") then
                addra_next <= addra_max_reg;
                state_next <= rec;
            -- Reproducción al derecho
            elsif(wea_RAM= "0") then
                addra_next <= (others => '0');
                state_next <= play_fw;
           else
                state_next <= inicio;
                addra_next <= (others => '0');
                addra_max_next <= addra_max_reg;     
           end if;
        else
           addra_next <= (others => '0');
           dina_next <= r_data_in(15 downto 8);
           state_next <= inicio;
        end if;
       
    when rec =>
        if (reset_n = '1') then 
            addra_next <= addra_reg + "1";
            dina_next <= (others => '0');
            addra_max_next <= (others => '0');
            state_next <= inicio;       
        elsif(wea_RAM = "1" and enable_in = '1' and SW6='0' and SW5='1') then
            dina_next <= r_data_in(15 downto 8);
            addra_next <= addra_reg + 1;
            addra_max_next <= addra_reg + 1;
            state_next <= rec;
        elsif(wea_RAM = "1" and SW6='0' and SW5='1') then
            dina_next <= r_data_in(15 downto 8);
            state_next <= rec;
        else
            state_next <= inicio;
        end if;
                          
    when play_fw =>
        if (reset_n = '1') then 
            addra_next <= addra_reg + "1";
            dina_next <= (others => '0');
            addra_max_next <= (others => '0');
            state_next <= inicio;       
        elsif(wea_RAM= "0" and enable_in = '1' and SW6='1' and SW5='1' and (addra_reg=addra_max_reg)) then
            dina_next <= r_data_in(15 downto 8);
            addra_next <= (others => '0');
            state_next <= play_fw;
        elsif(wea_RAM= "0" and enable_in = '1' and SW6='1' and SW5='1' and (addra_reg/=addra_max_reg)) then
                dina_next <= r_data_in(15 downto 8);
                addra_next <= addra_reg + 1;
                state_next <= play_fw;            
        elsif(wea_RAM= "0" and SW6='1' and SW5='1') then
            state_next <= play_fw;
        else
            state_next <= inicio;
        end if;
       
    end case;
end process;
addra_RAM <= (addra_reg);
dina_RAM <= dina_reg;

--RAM_Control
process(SW5, SW6, reset_n)
begin
    if(reset_n = '1')then
        ena_RAM <= '1';
        wea_RAM <= "1";
    else
        if(SW6='0' and SW5='0') then
            ena_RAM <= '0';
            wea_RAM <= "0"; --X;
        elsif(SW6='0' and SW5='1') then --Write
            ena_RAM <= '1';
            wea_RAM <= "1";
        elsif(SW6='1' and SW5='1') then --Read
            ena_RAM <= '1';
            wea_RAM <= "0";
        else
            ena_RAM <= '0';
            wea_RAM <= "0"; --X
        end if;
    end if;
end process;

process(clk, reset_n, SW6, SW5, douta_RAM, enable_in, l_data_in, ena_RAM, wea_RAM)
begin

    if(reset_n = '1') then
        l_data_out <= (others => '0');
        r_data_out <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        --Versión superpuesta para amplificador
        if(SW6 = '1' and SW5 = '1' and wea_RAM = "0") then
            l_data_out <= l_data_in + (douta_RAM & "00000000");
        else
            l_data_out <= douta_RAM & "00000000";
        end if;
        if(SW6 = '1' and SW5 = '1' and wea_RAM = "0") then            
            r_data_out <= r_data_in + (douta_RAM & "00000000");
        else
            r_data_out <= douta_RAM & "00000000";
        end if;
        --Versión full estéreo para auriculares
--        if(SW6 = '1' and SW5 = '1') then
--            l_data_out <= l_data_in;
--        else
--            l_data_out <= douta_RAM & "00000000";
--        end if;
--        if(SW6 = '1' and SW5 = '1' and wea_RAM = "0") then            
--            r_data_out <= douta_RAM & "00000000";
--        else
--            r_data_out <= douta_RAM & "00000000";
--        end if;
    end if;
end process;
      
end Behavioral;
