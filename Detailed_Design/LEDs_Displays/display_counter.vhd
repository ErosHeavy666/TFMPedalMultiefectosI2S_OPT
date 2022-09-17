library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all; 


-- Asserts ref_rate every 250,000 clk cycles. At 100MHz, every 20ms
entity display_counter is
    Port (  
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        ref_rate : out STD_LOGIC
        );
end display_counter;

architecture Behavioral of display_counter is

    signal counter, counter_next : STD_LOGIC_VECTOR (17 downto 0) := (others => '0');
    
begin
    -- Register logic
    process (clk, reset)
        begin
            if reset = '1' then
                counter <= (others => '0');
            elsif rising_edge(clk) then
                counter <= counter_next;
            end if;
    end process;
    
    -- Combinational logic
    process (counter)
        begin
            if counter = "111101000010010000" then -- Limit reached so reset
                counter_next <= (others => '0');
                ref_rate <= '1';
            else -- Counts
                counter_next <= counter + 1;
                ref_rate <= '0';
            end if;
    end process;

end Behavioral;