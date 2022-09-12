library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all; 
use work.project_trunk.all;

-- Used to control displays.
entity display_interface is 
  Port ( 
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    state : in STD_LOGIC_VECTOR (1 downto 0);
    seg : out STD_LOGIC_VECTOR (6 downto 0);
    an : out STD_LOGIC_VECTOR (7 downto 0)
  );
end display_interface;

architecture Behavioral of display_interface is

    component display_counter port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        ref_rate : out STD_LOGIC
    ); end component;
    
    signal ref_rate : STD_LOGIC;
    signal display1, display2, display3, display4, display5, display6, display7, display8 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    signal curr_display : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    
begin

    counter_assig : display_counter port map(
        clk => clk,
        reset => reset,
        ref_rate => ref_rate
    );
    
    -- Changes current display when ref_rate is asserted
    an_selection : process(clk)
        begin
            if rising_edge(clk) then
                if ref_rate = '1' then
                    curr_display <= curr_display + "001";
                end if;
            end if;
    end process;
    
    -- Uses "state" control signal to assign letters to displays
    sel_selection : process(clk, reset, state)
        begin
            if (reset = '1') then                
                display1 <= off;
                display2 <= off;
                display3 <= off;
                display4 <= off;
                display5 <= off;
                display6 <= off;
                display7 <= off;
                display8 <= off;
            else                
                display1 <= off;
                display2 <= off;
                display3 <= off;
                display4 <= off;
                display5 <= off;
                display6 <= off;
                display7 <= off;
                display8 <= off;
                
            case state is
                when "01" => -- "pause"
                    display1 <= off;
                    display2 <= e;
                    display3 <= s;
                    display4 <= u;
                    display5 <= a;
                    display6 <= p;
                    display7 <= off;
                    display8 <= off;
                
                when "11" => -- "play"
                    display1 <= off;
                    display2 <= off;
                    display3 <= y;
                    display4 <= a;
                    display5 <= l;
                    display6 <= p;
                    display7 <= off;
                    display8 <= off;
                    
                when others => -- "error"                    
                    display1 <= off;
                    display2 <= r;
                    display3 <= o;
                    display4 <= r;
                    display5 <= r;
                    display6 <= e;
                    display7 <= off;
                    display8 <= off;
                    
                end case;
            end if;
        end process;
    
    -- Switches between different displays    
    with curr_display select 
        an <= "01111111" when "000",
                  "10111111" when "001",
                  "11011111" when "010",
                  "11101111" when "011",
                  "11110111" when "100",
                  "11111011" when "101",
                  "11111101" when "110",
                  "11111110" when "111",
                  "11111111" when others;
     
     -- Shows the right letter depending on the current display           
     with curr_display select 
         seg <= display1 when "000",
                display2 when "001",
                display3 when "010",
                display4 when "011",
                display5 when "100",
                display6 when "101",
                display7 when "110",
                display8 when others;
                    
end Behavioral;