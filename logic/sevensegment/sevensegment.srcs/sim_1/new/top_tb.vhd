----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2016 13:39:33
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is    
end top_tb;

architecture Behavioral of top_tb is

    component SevSegDriver is
    port(
        PORT_CLK50: in std_logic;            
        PORT_NUMBER: in std_logic_vector(3 downto 0);
        PORT_SEP: in std_logic;
        PORT_CAT: out std_logic_vector(7 downto 0)  
    );
    end component;
    signal clk: std_logic := '0';
    signal cathodes: std_logic_vector(7 downto 0);
begin
    clk <= not clk  after 10 ns;
        
    iseg0: SevSegDriver port map(
         PORT_CLK50 => clk,        
         PORT_NUMBER => x"2",  
         PORT_SEP => '0',
         PORT_CAT => cathodes          
     );

end Behavioral;
