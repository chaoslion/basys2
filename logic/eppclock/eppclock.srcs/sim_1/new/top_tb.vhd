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

    component top is
    port(
        PORT_CLK50: in std_logic;
        PORT_SEGAN: out std_logic_vector(3 downto 0);
        PORT_SEGCAT: out std_logic_vector(7 downto 0);
        PORT_LEDS: out std_logic_vector(7 downto 0);
        -- epp
        PORT_EPPDB: inout std_logic_vector(7 downto 0);
        PORT_EPPASTB: in std_logic;
        PORT_EPPDSTB: in std_logic;
        PORT_EPPWRITE: in std_logic;
        PORT_EPPWAIT: out std_logic 
    );
    end component;

    signal clk50: std_logic := '0';
begin

    clk50 <= not clk50 after 10 ns;
    
    itop: top port map(
        PORT_CLK50 => clk50,
        PORT_SEGAN => open,
        PORT_SEGCAT => open,
        PORT_LEDS => open,
        PORT_EPPDB => open,
        PORT_EPPASTB => '0',
        PORT_EPPDSTB => '0',
        PORT_EPPWRITE => '0',
        PORT_EPPWAIT => open
        
     );


end Behavioral;
