----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2019 16:43:01
-- Design Name: 
-- Module Name: Digital_Efects - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Digital_Efects is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC; 
    enable_out            : out STD_LOGIC;
    BTNR                  : in STD_LOGIC;
    BTNC                  : in STD_LOGIC; 
    BTNL                  : in STD_LOGIC; 
    BTND                  : in STD_LOGIC; 
    SW0                   : in STD_LOGIC;
    SW1                   : in STD_LOGIC;
    SW2                   : in STD_LOGIC;
    SW3                   : in STD_LOGIC;
    SW4                   : in STD_LOGIC;
    SW5                   : in STD_LOGIC;
    SW6                   : in STD_LOGIC;
    SW7                   : in STD_LOGIC;
    SW8                   : in STD_LOGIC;
    SW9                   : in STD_LOGIC;
    SW10                  : in STD_LOGIC;
    SW11                  : in STD_LOGIC;
    SW12                  : in STD_LOGIC;
    SW13                  : in STD_LOGIC;
    SW14                  : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
);
end Digital_Efects;

architecture Behavioral of Digital_Efects is

component EfectoES is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoDELAY is
GENERIC(
    n               :  INTEGER := 4000;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoCHORUS is
GENERIC(
    n               :  INTEGER := 1000;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoVIBRATO is
GENERIC(
    n               :  INTEGER := 500;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoREVERB is
GENERIC(
    n               :  INTEGER := 500;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoECO is
GENERIC(
    n               :  INTEGER := 5000;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectCOMPRESSOR is
GENERIC(
    d_width         : INTEGER := 16
    );
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoOVERDRIVE is
GENERIC(
    d_width         : INTEGER := 16
    );
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoLOOPER is
GENERIC(
    d_width         : INTEGER := 16;
    d_deep          : INTEGER := 19
    );
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    SW13                  : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    SW5                   : IN STD_LOGIC;
    SW6                   : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoBANKFILTER is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    SW14                  : IN STD_LOGIC; --Switch de control para el tipo de filtro
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

component EfectoREVERB_PARAMETRIZADO is
GENERIC(
    n1              : INTEGER := 1500;
    d_width         : INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    BTNC                  : in STD_LOGIC; 
    BTNL                  : in STD_LOGIC; 
    BTND                  : in STD_LOGIC;
    BTNR                  : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end component;

--component EfectoAUTOWAH is
--GENERIC(
--    d_width         :  INTEGER := 16);
--Port ( 
--    clk                   : in STD_LOGIC;
--    reset_n               : in STD_LOGIC;
--    enable_in             : in STD_LOGIC;
--    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
--    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
--    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
--    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
--    enable_out            : out STD_LOGIC  
--); 
--end component;

signal enable_in_DELAY, enable_in_ES, enable_in_CHORUS, enable_in_VIBRATO, enable_in_REVERB, enable_in_ECO, enable_in_COMPRESSOR, enable_in_OVERDRIVE, enable_in_LOOPER, enable_in_BANKFILTER, enable_in_REVERB_PARAMETRIZADO : STD_LOGIC;
--signal enable_in_AUTOWAH : STD_LOGIC;
signal r_data_out_DELAY, l_data_out_DELAY, r_data_in_DELAY, l_data_in_DELAY : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_ES, l_data_out_ES, r_data_in_ES, l_data_in_ES : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_CHORUS, l_data_out_CHORUS, r_data_in_CHORUS, l_data_in_CHORUS : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_VIBRATO, l_data_out_VIBRATO, r_data_in_VIBRATO, l_data_in_VIBRATO : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_REVERB, l_data_out_REVERB, r_data_in_REVERB, l_data_in_REVERB : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_ECO, l_data_out_ECO, r_data_in_ECO, l_data_in_ECO : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_COMPRESSOR, l_data_out_COMPRESSOR, r_data_in_COMPRESSOR, l_data_in_COMPRESSOR : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_OVERDRIVE, l_data_out_OVERDRIVE, r_data_in_OVERDRIVE, l_data_in_OVERDRIVE : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_LOOPER, l_data_out_LOOPER, r_data_in_LOOPER, l_data_in_LOOPER : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_BANKFILTER, l_data_out_BANKFILTER, r_data_in_BANKFILTER, l_data_in_BANKFILTER : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_REVERB_PARAMETRIZADO, l_data_out_REVERB_PARAMETRIZADO, r_data_in_REVERB_PARAMETRIZADO, l_data_in_REVERB_PARAMETRIZADO : STD_LOGIC_VECTOR (d_width-1  downto 0);
--signal r_data_out_AUTOWAH, l_data_out_AUTOWAH, r_data_in_AUTOWAH, l_data_in_AUTOWAH : STD_LOGIC_VECTOR (d_width-1  downto 0);

begin

Unit_EfectES : EfectoES 
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_ES,
     l_data_in => l_data_in_ES , 
     l_data_out => l_data_out_ES, 
     r_data_in => r_data_in_ES, 
     r_data_out => r_data_out_ES,
     enable_out => enable_out
); 

Unit_EfectDELAY : EfectoDELAY 
GENERIC MAP(n => 4000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_DELAY,
     l_data_in => l_data_in_DELAY, 
     l_data_out => l_data_out_DELAY, 
     r_data_in => r_data_in_DELAY, 
     r_data_out => r_data_out_DELAY,
     enable_out => enable_out
); 

Unit_EfectCHORUS : EfectoCHORUS
GENERIC MAP(n => 1000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_CHORUS,
     l_data_in => l_data_in_CHORUS, 
     l_data_out => l_data_out_CHORUS, 
     r_data_in => r_data_in_CHORUS, 
     r_data_out => r_data_out_CHORUS,
     enable_out => enable_out
);

Unit_EfectVIBRATO : EfectoVIBRATO
GENERIC MAP(n => 500, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_VIBRATO,
     l_data_in => l_data_in_VIBRATO, 
     l_data_out => l_data_out_VIBRATO, 
     r_data_in => r_data_in_VIBRATO, 
     r_data_out => r_data_out_VIBRATO,
     enable_out => enable_out
);

Unit_EfectREVERB : EfectoREVERB
GENERIC MAP(n => 500, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_REVERB,
     l_data_in => l_data_in_REVERB, 
     l_data_out => l_data_out_REVERB, 
     r_data_in => r_data_in_REVERB, 
     r_data_out => r_data_out_REVERB,
     enable_out => enable_out
);

Unit_EfectECO : EfectoECO
GENERIC MAP(n => 5000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_ECO,
     l_data_in => l_data_in_ECO, 
     l_data_out => l_data_out_ECO, 
     r_data_in => r_data_in_ECO, 
     r_data_out => r_data_out_ECO,
     enable_out => enable_out
);

Unit_EfectCOMPRESSOR : EfectCOMPRESSOR  
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_COMPRESSOR,
     l_data_in => l_data_in_COMPRESSOR , 
     l_data_out => l_data_out_COMPRESSOR, 
     r_data_in => r_data_in_COMPRESSOR, 
     r_data_out => r_data_out_COMPRESSOR,
     enable_out => enable_out
); 

Unit_EfectOVERDRIVE : EfectoOVERDRIVE  
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_OVERDRIVE ,
     l_data_in => l_data_in_OVERDRIVE  , 
     l_data_out => l_data_out_OVERDRIVE , 
     r_data_in => r_data_in_OVERDRIVE , 
     r_data_out => r_data_out_OVERDRIVE ,
     enable_out => enable_out
); 

Unit_EfectLOOPER : EfectoLOOPER 
GENERIC MAP(d_width => 16, 
            d_deep => 19)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     SW13 => SW13,
     enable_in => enable_in_LOOPER  ,
     SW5 => SW5,
     SW6 => SW6,
     l_data_in => l_data_in_LOOPER   , 
     l_data_out => l_data_out_LOOPER  , 
     r_data_in => r_data_in_LOOPER  , 
     r_data_out => r_data_out_LOOPER  ,
     enable_out => enable_out
); 

Unit_EfectBANKFILTER : EfectoBANKFILTER  
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_BANKFILTER ,
     SW14 => SW14,
     l_data_in => l_data_in_BANKFILTER  , 
     l_data_out => l_data_out_BANKFILTER , 
     r_data_in => r_data_in_BANKFILTER , 
     r_data_out => r_data_out_BANKFILTER ,
     enable_out => enable_out
); 

Unit_EfectREVERB_PARAMETRIZADO : EfectoREVERB_PARAMETRIZADO
GENERIC MAP(n1 => 1500, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_REVERB_PARAMETRIZADO,
     BTNC => BTNC,
     BTNL => BTNL,
     BTND => BTND,
     BTNR => BTNR,
     l_data_in => l_data_in_REVERB_PARAMETRIZADO, 
     l_data_out => l_data_out_REVERB_PARAMETRIZADO, 
     r_data_in => r_data_in_REVERB_PARAMETRIZADO, 
     r_data_out => r_data_out_REVERB_PARAMETRIZADO,
     enable_out => enable_out
);

--Unit_EfectAUTOWAH : EfectoAUTOWAH  
--GENERIC MAP(d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in_AUTOWAH ,
--     l_data_in => l_data_in_AUTOWAH  , 
--     l_data_out => l_data_out_AUTOWAH , 
--     r_data_in => r_data_in_AUTOWAH , 
--     r_data_out => r_data_out_AUTOWAH ,
--     enable_out => enable_out
--); 

--Process que se encarga de decir que tipo de efecto le vamos a pasar a las muestars
process (SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, SW10, SW11, SW12, enable_in,
l_data_out_ES, r_data_out_ES, 
r_data_out_DELAY, l_data_out_DELAY, 
l_data_out_CHORUS, r_data_out_CHORUS,
l_data_out_VIBRATO, r_data_out_VIBRATO, 
r_data_out_REVERB, l_data_out_REVERB, 
r_data_out_ECO, l_data_out_ECO, 
r_data_out_COMPRESSOR, l_data_out_COMPRESSOR,
r_data_out_OVERDRIVE, l_data_out_OVERDRIVE,
r_data_out_LOOPER, l_data_out_LOOPER,
r_data_out_BANKFILTER, l_data_out_BANKFILTER,
r_data_out_REVERB_PARAMETRIZADO, l_data_out_REVERB_PARAMETRIZADO,
--r_data_out_AUTOWAH, l_data_out_AUTOWAH,
l_data_in, r_data_in)

begin --Si se desea añadir el autowah lo que habría que hacer es definir otro estado auxliar combinando dos switches, por ejemplo poner SW0 = 1 AND SW1 = 1 AND SWX = 0 (esta comentado)
    if(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --ES
        enable_in_ES <= '1' and enable_in; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0';
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0'); 
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');  
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0'); 
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                             
        l_data_in_ES <= l_data_in;
        r_data_in_ES <= r_data_in;        
        l_data_out <= l_data_out_ES;
        r_data_out <= r_data_out_ES;
        
    elsif(SW0 = '1' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --DELAY
        enable_in_ES <= '0'; 
        enable_in_DELAY <= '1' and enable_in; 
        enable_in_CHORUS <= '0'; 
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0';
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
         
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                                               
        l_data_in_DELAY <= l_data_in;
        r_data_in_DELAY <= r_data_in;       
        l_data_out <= l_data_out_DELAY;
        r_data_out <= r_data_out_DELAY; 
         
    elsif(SW0 = '0' AND SW1 = '1' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --CHORUS
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '1' and enable_in;  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0';
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0'); 
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0'); 
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0'); 
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                                               
        l_data_in_CHORUS <= l_data_in;
        r_data_in_CHORUS <= r_data_in;       
        l_data_out <= l_data_out_CHORUS;
        r_data_out <= r_data_out_CHORUS;
        
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '1' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --REVERB   
        enable_in_ES <= '0' ;  
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '1' and enable_in; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                       
        l_data_in_REVERB <= l_data_in;
        r_data_in_REVERB <= r_data_in;       
        l_data_out <= l_data_out_REVERB;
        r_data_out <= r_data_out_REVERB;
         
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '1' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --ECO
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0'; 
        enable_in_VIBRATO <= '0'; 
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '1' and enable_in;
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                               
        l_data_in_ECO <= l_data_in;
        r_data_in_ECO <= r_data_in;       
        l_data_out <= l_data_out_ECO;
        r_data_out <= r_data_out_ECO; 
               
     elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '1' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --VIBRATO
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0';
        enable_in_CHORUS <= '0'; 
        enable_in_VIBRATO <= '1' and enable_in;  
        enable_in_REVERB <= '0';
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0'); 
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0'); 
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0'); 
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                                               
        l_data_in_VIBRATO <= l_data_in;
        r_data_in_VIBRATO <= r_data_in;       
        l_data_out <= l_data_out_VIBRATO;
        r_data_out <= r_data_out_VIBRATO;
        
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '1' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --LOOPER_WRITE
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '1' and enable_in;
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE  <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0'); 
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                      
        l_data_in_LOOPER <= l_data_in;
        r_data_in_LOOPER <= r_data_in;       
        l_data_out <= l_data_out_LOOPER;
        r_data_out <= r_data_out_LOOPER;
        
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '1' AND SW6 = '1' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --LOOPER_READ
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '1' and enable_in;
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE  <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0'); 
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                      
        l_data_in_LOOPER <= l_data_in;
        r_data_in_LOOPER <= r_data_in;       
        l_data_out <= l_data_out_LOOPER;
        r_data_out <= r_data_out_LOOPER;
           
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '1' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --BANKFILTER
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '1' and enable_in;
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE  <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0'); 
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                      
        l_data_in_BANKFILTER <= l_data_in;
        r_data_in_BANKFILTER <= r_data_in;       
        l_data_out <= l_data_out_BANKFILTER;
        r_data_out <= r_data_out_BANKFILTER;   
                     
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '1' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --OVERDRIVE
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0'; 
        enable_in_VIBRATO <= '0'; 
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '1' and enable_in;
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0'); 
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                              
        l_data_in_OVERDRIVE <= l_data_in;
        r_data_in_OVERDRIVE <= r_data_in;       
        l_data_out <= l_data_out_OVERDRIVE;
        r_data_out <= r_data_out_OVERDRIVE;       
        
   elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '1' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --COMPRESSOR
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';
        enable_in_VIBRATO <= '0';  
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0'; 
        enable_in_COMPRESSOR <= '1' and enable_in;
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                               
        l_data_in_COMPRESSOR <= l_data_in;
        r_data_in_COMPRESSOR <= r_data_in;       
        l_data_out <= l_data_out_COMPRESSOR;
        r_data_out <= r_data_out_COMPRESSOR;

    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '1' AND SW11 = '0' AND SW12 = '0') then --REVERB_PARAMETRIZADO   
        enable_in_ES <= '0' ;  
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_VIBRATO <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '1' and enable_in; 
        enable_in_ECO <= '0';
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '0';
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB <= '0';
        --enable_in_AUTOWAH <= '0';
         
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_OVERDRIVE <= (others => '0');
        r_data_in_OVERDRIVE <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                       
        l_data_in_REVERB_PARAMETRIZADO <= l_data_in;
        r_data_in_REVERB_PARAMETRIZADO <= r_data_in;       
        l_data_out <= l_data_out_REVERB_PARAMETRIZADO;
        r_data_out <= r_data_out_REVERB_PARAMETRIZADO;
                            
   elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '1' AND SW12 = '0') then --OVERDRIVE+DELAY
        enable_in_ES <= '0' ; 
        enable_in_DELAY <='1' and enable_in; 
        enable_in_CHORUS <= '0';
        enable_in_VIBRATO <= '0';  
        enable_in_REVERB <= '0'; 
        enable_in_ECO <= '0'; 
        enable_in_COMPRESSOR <= '0';
        enable_in_OVERDRIVE <= '1' and enable_in;
        enable_in_LOOPER <= '0';
        enable_in_BANKFILTER <= '0';
        enable_in_REVERB_PARAMETRIZADO <= '0';
        --enable_in_AUTOWAH <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_VIBRATO <= (others => '0');
        r_data_in_VIBRATO <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_ECO <= (others => '0');
        r_data_in_ECO <= (others => '0');
        l_data_in_COMPRESSOR <= (others => '0');
        r_data_in_COMPRESSOR <= (others => '0');
        l_data_in_LOOPER <= (others => '0');
        r_data_in_LOOPER <= (others => '0');
        l_data_in_BANKFILTER <= (others => '0');
        r_data_in_BANKFILTER <= (others => '0');
        l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
        --l_data_in_AUTOWAH <= (others => '0');
        --r_data_in_AUTOWAH <= (others => '0');
                                      
        l_data_in_OVERDRIVE <= l_data_in;
        r_data_in_OVERDRIVE <= r_data_in;       
        l_data_in_DELAY <= l_data_out_OVERDRIVE;
        r_data_in_DELAY <= r_data_out_OVERDRIVE;       
        l_data_out <= l_data_out_DELAY;
        r_data_out <= r_data_out_DELAY; 

    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '1' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '1') then --LOOPER_WRITE + COMPRESSOR
       enable_in_ES <= '0' ; 
       enable_in_DELAY <= '0'; 
       enable_in_CHORUS <= '0';  
       enable_in_VIBRATO <= '0';
       enable_in_REVERB <= '0'; 
       enable_in_ECO <= '0';
       enable_in_COMPRESSOR <= '1' and enable_in;
       enable_in_OVERDRIVE <= '0';
       enable_in_LOOPER <= '1' and enable_in;
       enable_in_BANKFILTER <= '0';
       enable_in_REVERB_PARAMETRIZADO <= '0';
       --enable_in_AUTOWAH <= '0';
       
       l_data_in_ES <= (others => '0');
       r_data_in_ES <= (others => '0');
       l_data_in_DELAY <= (others => '0');
       r_data_in_DELAY <= (others => '0');
       l_data_in_CHORUS <= (others => '0');
       r_data_in_CHORUS <= (others => '0');
       l_data_in_VIBRATO <= (others => '0');
       r_data_in_VIBRATO <= (others => '0');
       l_data_in_REVERB <= (others => '0');
       r_data_in_REVERB <= (others => '0');
       l_data_in_ECO <= (others => '0');
       r_data_in_ECO <= (others => '0');
       l_data_in_OVERDRIVE <= (others => '0');
       r_data_in_OVERDRIVE  <= (others => '0');
       l_data_in_BANKFILTER <= (others => '0');
       r_data_in_BANKFILTER <= (others => '0');
       l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
       r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
       --l_data_in_AUTOWAH <= (others => '0');
       --r_data_in_AUTOWAH <= (others => '0');
                              
       l_data_in_COMPRESSOR <= l_data_in;
       r_data_in_COMPRESSOR <= r_data_in;  
       l_data_in_LOOPER <= l_data_out_COMPRESSOR;
       r_data_in_LOOPER <= r_data_out_COMPRESSOR;       
       l_data_out <= l_data_out_LOOPER;
       r_data_out <= r_data_out_LOOPER;
        
    elsif(SW0 = '0' AND SW1 = '0' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '1' AND SW6 = '1' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '1') then --LOOPER_READ + COMPRESSOR
       enable_in_ES <= '0' ; 
       enable_in_DELAY <= '0'; 
       enable_in_CHORUS <= '0';  
       enable_in_VIBRATO <= '0';
       enable_in_REVERB <= '0'; 
       enable_in_ECO <= '0';
       enable_in_COMPRESSOR <= '1' and enable_in;
       enable_in_OVERDRIVE <= '0';
       enable_in_LOOPER <= '1' and enable_in;
       enable_in_BANKFILTER <= '0';
       enable_in_REVERB_PARAMETRIZADO <= '0';    
       --enable_in_AUTOWAH <= '0';
       
       l_data_in_ES <= (others => '0');
       r_data_in_ES <= (others => '0');
       l_data_in_DELAY <= (others => '0');
       r_data_in_DELAY <= (others => '0');
       l_data_in_CHORUS <= (others => '0');
       r_data_in_CHORUS <= (others => '0');
       l_data_in_VIBRATO <= (others => '0');
       r_data_in_VIBRATO <= (others => '0');
       l_data_in_REVERB <= (others => '0');
       r_data_in_REVERB <= (others => '0');
       l_data_in_ECO <= (others => '0');
       r_data_in_ECO <= (others => '0');
       l_data_in_OVERDRIVE <= (others => '0');
       r_data_in_OVERDRIVE  <= (others => '0');
       l_data_in_BANKFILTER <= (others => '0');
       r_data_in_BANKFILTER <= (others => '0');
       l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
       r_data_in_REVERB_PARAMETRIZADO <= (others => '0');  
       --l_data_in_AUTOWAH <= (others => '0');
       --r_data_in_AUTOWAH <= (others => '0');
                             
       l_data_in_COMPRESSOR <= l_data_in;
       r_data_in_COMPRESSOR <= r_data_in;  
       l_data_in_LOOPER <= l_data_out_COMPRESSOR;
       r_data_in_LOOPER <= r_data_out_COMPRESSOR;       
       l_data_out <= l_data_out_LOOPER;
       r_data_out <= r_data_out_LOOPER;

--    elsif(SW0 = '1' AND SW1 = '1' AND SW2 = '0' AND SW3 = '0' AND SW4 = '0' AND SW5 = '0' AND SW6 = '0' AND SW7 = '0' AND SW8 = '0' AND SW9 = '0' AND SW10 = '0' AND SW11 = '0' AND SW12 = '0') then --AUTOWAH
--       enable_in_ES <= '0' ; 
--       enable_in_DELAY <= '0'; 
--       enable_in_CHORUS <= '0';  
--       enable_in_VIBRATO <= '0';
--       enable_in_REVERB <= '0'; 
--       enable_in_ECO <= '0';
--       enable_in_COMPRESSOR <= '0';
--       enable_in_OVERDRIVE <= '0';
--       enable_in_LOOPER <= '0';
--       enable_in_BANKFILTER <= '0';
--       enable_in_REVERB_PARAMETRIZADO <= '0';    
--       --enable_in_AUTOWAH <= '1' and enable_in;
        
--       l_data_in_ES <= (others => '0');
--       r_data_in_ES <= (others => '0');
--       l_data_in_DELAY <= (others => '0');
--       r_data_in_DELAY <= (others => '0');
--       l_data_in_CHORUS <= (others => '0');
--       r_data_in_CHORUS <= (others => '0');
--       l_data_in_VIBRATO <= (others => '0');
--       r_data_in_VIBRATO <= (others => '0');
--       l_data_in_REVERB <= (others => '0');
--       r_data_in_REVERB <= (others => '0');
--       l_data_in_ECO <= (others => '0');
--       r_data_in_ECO <= (others => '0');
--       l_data_in_OVERDRIVE <= (others => '0');
--       r_data_in_OVERDRIVE  <= (others => '0');
--       l_data_in_BANKFILTER <= (others => '0');
--       r_data_in_BANKFILTER <= (others => '0');
--       l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
--       r_data_in_REVERB_PARAMETRIZADO <= (others => '0');  
--       l_data_in_COMPRESSOR <= (others => '0');
--       r_data_in_COMPRESSOR <= (others => '0');
--       l_data_in_LOOPER <= (others => '0');
--       r_data_in_LOOPER <= (others => '0');
                             
--       l_data_in_AUTOWAH <= l_data_in;
--       r_data_in_AUTOWAH <= r_data_in;     
--       l_data_out <= l_data_out_AUTOWAH;
--       r_data_out <= r_data_out_AUTOWAH;
                                              
   else --STOP
       enable_in_ES <= '0'; 
       enable_in_DELAY <= '0'; 
       enable_in_CHORUS <= '0';  
       enable_in_VIBRATO <= '0';
       enable_in_REVERB <= '0';
       enable_in_ECO <= '0'; 
       enable_in_COMPRESSOR <= '0';
       enable_in_OVERDRIVE <= '0';
       enable_in_LOOPER <= '0';
       enable_in_BANKFILTER <= '0';
       enable_in_REVERB_PARAMETRIZADO <= '0';
       --enable_in_AUTOWAH <= '0';
              
       l_data_in_ES <= (others => '0');
       r_data_in_ES <= (others => '0');
       l_data_in_DELAY <= (others => '0');
       r_data_in_DELAY <= (others => '0');
       l_data_in_CHORUS <= (others => '0');
       r_data_in_CHORUS <= (others => '0');
       l_data_in_VIBRATO <= (others => '0');
       r_data_in_VIBRATO <= (others => '0');
       l_data_in_REVERB <= (others => '0');
       r_data_in_REVERB <= (others => '0');
       l_data_in_ECO <= (others => '0');
       r_data_in_ECO <= (others => '0');
       l_data_in_COMPRESSOR <= (others => '0');
       r_data_in_COMPRESSOR <= (others => '0');
       l_data_in_OVERDRIVE <= (others => '0');
       r_data_in_OVERDRIVE <= (others => '0'); 
       l_data_in_LOOPER <= (others => '0');
       r_data_in_LOOPER <= (others => '0'); 
       l_data_in_BANKFILTER <= (others => '0');
       r_data_in_BANKFILTER <= (others => '0');
       l_data_in_REVERB_PARAMETRIZADO <= (others => '0');
       r_data_in_REVERB_PARAMETRIZADO <= (others => '0');
       --l_data_in_AUTOWAH <= (others => '0');
       --r_data_in_AUTOWAH <= (others => '0');
              
       l_data_out <= (others => '0');
       r_data_out <= (others => '0');  
          
    end if;
end process;
end Behavioral;