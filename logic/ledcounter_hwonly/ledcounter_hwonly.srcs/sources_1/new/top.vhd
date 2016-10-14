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

end Behavioral;
