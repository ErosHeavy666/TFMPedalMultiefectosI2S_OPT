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
entity Fir_Filter_Bankfilter is
  port (  
    clk              : in std_logic; 
    reset_n          : in std_logic;             
    filter_select    : in std_logic;   
    data_in          : in std_logic_vector(width-1 downto 0); 
    data_in_ready    : in std_logic;    
    data_out         : out std_logic_vector(width-1 downto 0); 
    data_out_ready   : out std_logic
  );           
end Fir_Filter_Bankfilter;

------------------
-- Architecture --
------------------
architecture Fir_Filter_Bankfilter_arch of Fir_Filter_Bankfilter is

  -- Signals 
  signal M12_aux : std_logic_vector(3 downto 0);
  signal M3_aux  : std_logic;
  
  -- Components declaration 
  component Filter_Datapath is 
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
  end component;

  component Filter_Controller is 
    port(                                    
      clk               : in std_logic;                
      reset_n           : in std_logic;               
      M12               : out std_logic_vector(3 downto 0); 
      M3                : out std_logic;   
      data_in_ready     : in std_logic;       
      data_out_ready    : out std_logic                     
    );
  end component;

begin

  Unit_Filter_Datapath : Filter_Datapath
    port map(
      clk           => clk,
      reset_n       => reset_n,
      filter_select => filter_select,
      M12           => M12_aux,
      M3            => M3_aux,
      data_in       => data_in,
      data_in_ready => data_in_ready,
      data_out      => data_out
  );  
   
  Unit_Filter_Controller : Filter_Controller 
    port map(
      clk            => clk,
      reset_n        => reset_n,
      M12            => M12_aux,
      M3             => M3_aux,
      data_in_ready  => data_in_ready,  
      data_out_ready => data_out_ready  
  );
       
end Fir_Filter_Bankfilter_arch;