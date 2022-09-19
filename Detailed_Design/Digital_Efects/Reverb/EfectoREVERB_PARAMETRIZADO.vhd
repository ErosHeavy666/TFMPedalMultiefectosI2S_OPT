----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros García Arroyo
-- 
-- Create Date: 08.12.2019 12:02:32
-- Design Name: 
-- Module Name: EfectoREVERB_PARAMETRIZADO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Efecto Reverb descrito anteriormente pero ahora se puede modelar
--              las ganancias de las 3 señales que componen la salida y ajustar la 
--              línea de retardo
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

entity EfectoREVERB_PARAMETRIZADO is
GENERIC(
    n1              : INTEGER := 1500;--Línea de retardo  
    d_width         : INTEGER := 16); --Ancho del bus     
Port ( 
    clk                   : in STD_LOGIC; --MCLK                                             
    reset_n               : in STD_LOGIC; --Reset asíncrono a nivel alto del sistema global  
    enable_in             : in STD_LOGIC; --Enable proporcionado por el i2s2                 
    BTNC                  : in STD_LOGIC; --Volumen muestra retardada entrada
    BTNL                  : in STD_LOGIC; --Volumen muestra original
    BTND                  : in STD_LOGIC; --Volumen muestra retardada salida
    BTNR                  : in STD_LOGIC; --Control de la línea de retardo
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada izquierdos;                
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida izquierdos;                
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de entrada derechos;                  
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC -> Datos de salida derechos;                  
    enable_out            : out STD_LOGIC  --Enable out para la señal i2s2
); 
end EfectoREVERB_PARAMETRIZADO;

architecture Behavioral of EfectoREVERB_PARAMETRIZADO is
   
   signal g1 : integer; --Volumen muestra original --> BTNL
   signal g2 : integer; --Volumen muestra retardada salida --> BTND
   signal g3 : integer; --Volumen muestra retardada entrada --> BTNC
    
   type fifo_t1 is array (0 to n1-1) of signed(d_width-1 downto 0);
   signal l_data_next1, l_data_reg1, r_data_reg1, r_data_next1, l_data_next_aux1, r_data_next_aux1, l_data_reg_aux1, r_data_reg_aux1: fifo_t1;
   
   signal l_data_out_aux1, r_data_out_aux1: STD_LOGIC_VECTOR(d_width-1 downto 0); 
   signal state_n : unsigned(1 downto 0) := "00"; 
   signal state_g1, state_g2, state_g3 : unsigned(1 downto 0) := "00";
   signal button_n : STD_LOGIC := '1'; 
   signal button_g1, button_g2, button_g3 : STD_LOGIC := '1'; --Flag de control para no saturar el pulsador
   signal enable_n1, enable_n2 : STD_LOGIC := '0'; 
   signal enable_n3, enable_n4 : STD_LOGIC := '0';
   
begin

--Parametrización de n
process(clk, reset_n, BTNR, state_n, button_n)
begin
    if reset_n = '1' then
        state_n <= "00";
        button_n <= '1';
    elsif(rising_edge(clk))then
        if(BTNR = '1' and button_n = '1')then
            state_n <= state_n + 1; 
            button_n <= '0';
        elsif(BTNR = '1' and button_n = '0')then
            state_n <= state_n; 
            button_n <= '0';            
        else
            button_n <= '1';
            state_n <= state_n;
        end if;
    end if;
end process;

process(state_n)
begin
    if(state_n = "00")then
        enable_n1 <= '1';
        enable_n2 <= '0';
        enable_n3 <= '0';
        enable_n4 <= '0';
    elsif(state_n = "01")then
        enable_n1 <= '0';
        enable_n2 <= '1';
        enable_n3 <= '0';
        enable_n4 <= '0';
    elsif(state_n = "10")then
        enable_n1 <= '0';
        enable_n2 <= '0';
        enable_n3 <= '1';
        enable_n4 <= '0';
    else
        enable_n1 <= '0';
        enable_n2 <= '0';
        enable_n3 <= '0';
        enable_n4 <= '1';
    end if;      
end process;

--Parametrización de g1
process(clk, reset_n, BTNL, state_g1, button_g1)
begin
    if reset_n = '1' then
        state_g1 <= "00"; 
        button_g1 <= '1';   
    elsif(rising_edge(clk))then
        if(BTNL = '1' and button_g1 = '1')then
            state_g1 <= state_g1 + 1; 
            button_g1 <= '0';
        elsif(BTNL = '1' and button_g1 = '0')then
            state_g1 <= state_g1; 
            button_g1 <= '0';            
        else
            button_g1 <= '1';
            state_g1 <= state_g1;
        end if;
    end if;
end process;

process(state_g1)
begin
    if(state_g1 = "00")then
        g1 <= 1;
    elsif(state_g1 = "01")then
        g1 <= 2;
    elsif(state_g1 = "10")then
        g1 <= 3;  
    else
        g1 <= 4;
    end if;      
end process;

--Parametrización de g2
process(clk, reset_n, BTND, state_g2, button_g2)
begin
    if reset_n = '1' then
        state_g2 <= "00";
        button_g2 <= '1';   
    elsif(rising_edge(clk))then
        if(BTND = '1' and button_g2 = '1')then
            state_g2 <= state_g2 + 1; 
            button_g2 <= '0';
        elsif(BTND = '1' and button_g2 = '0')then
            state_g2 <= state_g2; 
            button_g2 <= '0';            
        else
            button_g2 <= '1';
            state_g2 <= state_g2;
        end if;
    end if;
end process;

process(state_g2)
begin
    if(state_g2 = "00")then
        g2 <= 1;
    elsif(state_g2 = "01")then
        g2 <= 2;
    elsif(state_g2 = "10")then
        g2 <= 3;  
    else
        g2 <= 4;
    end if;      
end process;

--Parametrización de g3
process(clk, reset_n, BTNC, state_g3, button_g3)
begin
    if reset_n = '1' then
        state_g3 <= "00";
        button_g3 <= '1';   
    elsif(rising_edge(clk))then
        if(BTNC = '1' and button_g3 = '1')then
            state_g3 <= state_g3 + 1; 
            button_g3 <= '0';
        elsif(BTNC = '1' and button_g3 = '0')then
            state_g3 <= state_g3; 
            button_g3 <= '0';            
        else
            button_g3 <= '1';
            state_g3 <= state_g3;
        end if;
    end if;
end process;

process(state_g3)
begin
    if(state_g3 = "00")then
        g3 <= 0;
    elsif(state_g3 = "01")then
        g3 <= 1;
    elsif(state_g3 = "10")then
        g3 <= 2;  
    else
        g3 <= 3;
    end if;      
end process;
   
process(clk, reset_n, enable_in)   
begin
   if reset_n = '1' then
       l_data_reg1 <= (others => (others => '0'));
       r_data_reg1 <= (others => (others => '0'));  
       l_data_reg_aux1 <= (others => (others => '0')); 
       r_data_reg_aux1 <= (others => (others => '0'));
   elsif (rising_edge(clk)) then --MCLK
       if(enable_in = '1') then
           l_data_reg1 <= l_data_next1;
           r_data_reg1 <= r_data_next1;
           l_data_reg_aux1 <= l_data_next_aux1;
           r_data_reg_aux1 <= r_data_next_aux1;              
       end if;
   end if;
end process;

--n1
process (l_data_in, l_data_reg1, r_data_in, r_data_reg1)
begin
   l_data_next1(0) <= signed(l_data_in);
   r_data_next1(0) <= signed(r_data_in);
        for i in 1 to n1-1 loop
            l_data_next1(i) <= l_data_reg1(i-1);
            r_data_next1(i) <= r_data_reg1(i-1);
        end loop;
end process;

process (l_data_out_aux1, r_data_out_aux1, l_data_reg_aux1, r_data_reg_aux1)
begin
   l_data_next_aux1(0) <= signed(l_data_out_aux1);
   r_data_next_aux1(0) <= signed(r_data_out_aux1);
        for i in 1 to n1-1 loop
            l_data_next_aux1(i) <= l_data_reg_aux1(i-1);
            r_data_next_aux1(i) <= r_data_reg_aux1(i-1);
        end loop;
end process;

process(clk, reset_n, enable_in, enable_n1, enable_n2, enable_n3, enable_n4)
begin
   if reset_n = '1' then
       l_data_out_aux1 <= (others => '0');
       r_data_out_aux1 <= (others => '0');                 
       enable_out <= '0';
   elsif (rising_edge(clk)) then --MCLK
       enable_out <= enable_in;
       if(enable_in = '1' and enable_n1 = '1') then
           l_data_out_aux1 <= std_logic_vector(-signed(l_data_in)/g1 + shift_right(l_data_reg1(n1-1),g3) + shift_right(l_data_reg_aux1(n1-1),g2));
           r_data_out_aux1 <= std_logic_vector(-signed(r_data_in)/g1 + shift_right(r_data_reg1(n1-1),g3) + shift_right(r_data_reg_aux1(n1-1),g2));
       elsif(enable_in = '1' and enable_n2 = '1') then
           l_data_out_aux1 <= std_logic_vector(-signed(l_data_in)/g1 + shift_right(l_data_reg1(n1-501),g3) + shift_right(l_data_reg_aux1(n1-501),g2));
           r_data_out_aux1 <= std_logic_vector(-signed(r_data_in)/g1 + shift_right(r_data_reg1(n1-501),g3) + shift_right(r_data_reg_aux1(n1-501),g2));
       elsif(enable_in = '1' and enable_n3 = '1') then
           l_data_out_aux1 <= std_logic_vector(-signed(l_data_in)/g1 + shift_right(l_data_reg1(n1-1001),g3) + shift_right(l_data_reg_aux1(n1-1001),g2));
           r_data_out_aux1 <= std_logic_vector(-signed(r_data_in)/g1 + shift_right(r_data_reg1(n1-1001),g3) + shift_right(r_data_reg_aux1(n1-1001),g2));
       elsif(enable_in = '1' and enable_n4 = '1') then
           l_data_out_aux1 <= std_logic_vector(-signed(l_data_in)/g1 + shift_right(l_data_reg1(n1-1499),g3) + shift_right(l_data_reg_aux1(n1-1499),g2));
           r_data_out_aux1 <= std_logic_vector(-signed(r_data_in)/g1 + shift_right(r_data_reg1(n1-1499),g3) + shift_right(r_data_reg_aux1(n1-1499),g2));    
       end if;
   end if;
end process;

l_data_out <= l_data_out_aux1;
r_data_out <= r_data_out_aux1; 
 
end Behavioral;
