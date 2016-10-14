library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
port(
    PORT_CLK50: in std_logic;
    PORT_SEGAN: out std_logic_vector(3 downto 0);
    PORT_SEGCAT: out std_logic_vector(7 downto 0)    
);
end top;

architecture Behavioral of top is

    component MultiSevSegDriver is
    generic(
        CHANNELS: integer;
        RATE: integer
    );	
    port(
        PORT_CLK50: in std_logic;
        PORT_NUMBERS: in std_logic_vector(CHANNELS*4-1 downto 0);
        PORT_SEP: in std_logic_vector(CHANNELS-1 downto 0);
        PORT_CAT: out std_logic_vector(7 downto 0);
        PORT_AN: out std_logic_vector(CHANNELS-1 downto 0)
    );
    end component;


    signal cathodes: std_logic_vector(7 downto 0);
    signal anodes: std_logic_vector(3 downto 0);
begin
    
    isegs: MultiSevSegDriver 
    generic map(
        CHANNELS => 4,
        RATE => 100
    )
    port map(
        PORT_CLK50 => PORT_CLK50,
        PORT_NUMBERS => x"1337",
        PORT_SEP => "0010",
        PORT_CAT => cathodes,
        PORT_AN => anodes
    );

    PORT_SEGAN <= not anodes;
    PORT_SEGCAT(7) <= 'Z' when cathodes(7) = '0' else '0';
    PORT_SEGCAT(6) <= 'Z' when cathodes(6) = '0' else '0';
    PORT_SEGCAT(5) <= 'Z' when cathodes(5) = '0' else '0';
    PORT_SEGCAT(4) <= 'Z' when cathodes(4) = '0' else '0';
    PORT_SEGCAT(3) <= 'Z' when cathodes(3) = '0' else '0';
    PORT_SEGCAT(2) <= 'Z' when cathodes(2) = '0' else '0';
    PORT_SEGCAT(1) <= 'Z' when cathodes(1) = '0' else '0';
    PORT_SEGCAT(0) <= 'Z' when cathodes(0) = '0' else '0';

end Behavioral;
