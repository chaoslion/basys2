----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.09.2016 11:26:02
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
port(
    PORT_CLK50: IN std_logic;
    PORT_LEDS: OUT std_logic_vector(7 downto 0)
);
end top;

architecture Behavioral of top is

--COMPONENT microblaze_mcs_v1_4_0
--  PORT (
--    Clk : IN STD_LOGIC;
--    Reset : IN STD_LOGIC;
--    FIT1_Interrupt : OUT STD_LOGIC;
--    FIT1_Toggle : OUT STD_LOGIC;
--    PIT1_Interrupt : OUT STD_LOGIC;
--    PIT1_Toggle : OUT STD_LOGIC;
--    GPO1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
--    INTC_IRQ : OUT STD_LOGIC
--  );
--END COMPONENT;

signal divider: unsigned(31 downto 0) := (others => '0');
signal counter: unsigned(7 downto 0) := (others => '0');
begin

    DIV_PROC: process(PORT_CLK50)
    begin
        if rising_edge(PORT_CLK50) then
            divider <= divider - 1;            
            if divider = x"00000000" then
                divider <= x"0005F5E0";
            end if;            
        end if;
    end process;
    
    LED_COUNTER: process(PORT_CLK50)
    begin
        if rising_edge(PORT_CLK50) then
            if divider = x"00000000" then
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    PORT_LEDS <= std_logic_vector(counter);

--    LED_COUNTER: process(PORT_CLK50)
--    begin
--        if rising_edge(PORT_CLK50) then
--            counter <= counter + 1;
--        end if;
--    end process;
    
--    cpu0: microblaze_mcs_v1_4_0
--    PORT MAP (
--        Clk => PORT_CLK50,
--        Reset => '0',
--        GPO1 => PORT_LEDS,
--        PIT1_Interrupt => open,
--        PIT1_Toggle => open,
--        FIT1_Interrupt => open,
--        FIT1_Toggle => open,           
--        INTC_IRQ => open
--    );

end Behavioral;
