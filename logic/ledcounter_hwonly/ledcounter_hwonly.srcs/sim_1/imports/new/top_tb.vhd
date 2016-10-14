----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2016 15:33:51
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is    
end top_tb;

architecture Behavioral of top_tb is

    component top is
    port(
        PORT_CLK50: IN std_logic;
        PORT_LEDS: OUT std_logic_vector(7 downto 0)
    );
    end component;

    signal clk50: std_logic := '0';
    signal leds: std_logic_vector(7 downto 0);
begin
    clk50   <= not clk50  after 10 ns;
    itop: top
    port map(
        PORT_CLK50 => clk50,
        PORT_LEDS => leds
    );

end Behavioral;
