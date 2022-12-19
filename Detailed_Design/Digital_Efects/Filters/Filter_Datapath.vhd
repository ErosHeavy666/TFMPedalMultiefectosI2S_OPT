----------------------------------
-- Engineer: Eros Garcia Arroyo --
----------------------------------

---------------
-- Libraries --
---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg_project.all;

------------
-- Entity --
------------
entity Filter_Datapath is
  port(  
    clk           : in std_logic;
    reset_n       : in std_logic;
    filter_select : in std_logic;
    M12           : in std_logic_vector(3 downto 0);
    M3            : in std_logic;
    data_in       : in std_logic_vector(width-1 downto 0);
    data_in_ready : in std_logic;
    data_out      : out std_logic_vector(width-1 downto 0)
  );     
end Filter_Datapath;

architecture Filter_Datapath_arch of Filter_Datapath is
  
  -- Signals 
  signal x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15 : std_logic_vector(width-1 downto 0); 
  signal c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15 : std_logic_vector(width-1 downto 0); 
  signal R1_reg, R2_reg, R1_next, R2_next : signed((width*2 - 2) downto 0); --Registros R1 y R2
  signal mult_aux: signed((width*2 - 1) downto 0); --Multiplicación
  signal R3_reg, R3_next: signed(width-1 downto 0); --Registros R3
  signal M3_aux, M2_aux, M1_aux : signed(width-1 downto 0); 
  signal mult : signed (width*2-2 downto 0);
  
  -- Components declaration   
  component register_d is 
    port (
      clk     : in std_logic; 
      n_reset : in std_logic; 
      i_en    : in std_logic; 
      i_data  : in std_logic_vector(width-1 downto 0); 
      o_data  : out std_logic_vector(width-1 downto 0) 
    );
  end component;
 
begin

  -------------------------------------------------------------------------------------------------------------------------------
  -- Registers Instances for Datapath
  -------------------------------------------------------------------------------------------------------------------------------
  register_d_0: register_d
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en => data_in_ready,
       i_data => data_in, 
       o_data => x0
  );  
  register_d_1: register_d
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en => data_in_ready,
       i_data => x0,
       o_data => x1
  );                               
  register_d_2: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x1,
       o_data => x2
  );                                 
  register_d_3: register_d         
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x2,
       o_data => x3
  );                                
  register_d_4: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x3,
       o_data => x4
  );                                
  register_d_5: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x4,
       o_data => x5
  );      
  register_d_6: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x5,
       o_data => x6
  );      
  register_d_7: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x6,
       o_data => x7
  );      
  register_d_8: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x7,
       o_data => x8
  );      
  register_d_9: register_d           
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x8,
       o_data => x9
  );      
  register_d_10: register_d         
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x9,
       o_data => x10
  );      
  register_d_11: register_d        
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x10,
       o_data => x11
  );      
  register_d_12: register_d        
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x11,
       o_data => x12
  );      
  register_d_13: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x12,
       o_data => x13
  );      
  register_d_14: register_d          
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x13,
       o_data => x14
  );         
  register_d_15: register_d         
  port map(
       clk => clk,  
       n_reset => reset_n,
       i_en =>  data_in_ready,
       i_data => x14,
       o_data => x15
  );      
  -------------------------------------------------------------------------------------------------------------------------------
  -- Register process:
  -------------------------------------------------------------------------------------------------------------------------------                                                    
  process(clk) 
  begin
    if(rising_edge(clk)) then 
      if(reset_n = '1') then 
        R3_reg <= (others => '0');
        R2_reg <= (others => '0');
        R1_reg <= (others => '0');
      else 
        R3_reg <= R3_next; 
        R2_reg <= R2_next;
        R1_reg <= R1_next;
      end if;
    end if;
  end process;  
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Filter selection and Definition of coeficients
  -------------------------------------------------------------------------------------------------------------------------------
  process(filter_select)
  begin                
    if (filter_select = '1') then --LPF   
        c0  <= "1111111111011111";
        c1  <= "0000001011110010";
        c2  <= "0000011000000100";
        c3  <= "0000011011001001";
        c4  <= "0000101000111101";
        c5  <= "0000110000001000";
        c6  <= "0000111000010100";
        c7  <= "0000111011011001";
        c8  <= "0000111011011001";
        c9  <= "0000111000010100";
        c10 <= "0000110000001000";
        c11 <= "0000101000111101";
        c12 <= "0000011011001001";  
        c13 <= "0000011000000100";
        c14 <= "0000001011110010";
        c15 <= "1111111111011111";   
    else  --HPF      
        c0  <= "0000000101001000";
        c1  <= "0000001011110010";
        c2  <= "1111001110010111";
        c3  <= "1111111110011110";
        c4  <= "1110101010100000";   
        c5  <= "0000000111101100"; 
        c6  <= "1101010111000011"; 
        c7  <= "0100000010000011"; 
        c8  <= "0100000010000011"; 
        c9  <= "1101010111000011";  
        c10 <= "0000000111101100";  
        c11 <= "1110101010100000"; 
        c12 <= "1111111110011110"; 
        c13 <= "1111001110010110"; 
        c14 <= "0000001011110010";
        c15 <= "0000000101001000";             
      end if;
  end process;
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: Coeficients Charge
  -------------------------------------------------------------------------------------------------------------------------------
  process (M12,M1_aux,M2_aux,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,
                             x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15) 
  begin
    case M12 is
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
  -------------------------------------------------------------------------------------------------------------------------------
  -- Combinational logic process: DATAPATH
  -------------------------------------------------------------------------------------------------------------------------------
  mult_aux <= M1_aux * M2_aux; 
  mult <= mult_aux(width*2-2 downto 0);
  R1_next <= mult;    
  R2_next <= R1_reg;    
  R3_next <= R2_reg(width*2-2 downto width*2-2-15) + M3_aux;
  M3_aux <= R3_reg when (M3 = '1') else (others => '0');       
  -------------------------------------------------------------------------------------------------------------------------------
  -- Output process: 
  -------------------------------------------------------------------------------------------------------------------------------  
  data_out <= std_logic_vector(R3_reg(width-1 downto 0));
  -------------------------------------------------------------------------------------------------------------------------------  
end Filter_Datapath_arch;