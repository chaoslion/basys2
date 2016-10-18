library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- max channels is 8
entity MultiSevSegDriver is
generic(
    CHANNELS: positive;
    RATE_DIVIDER: positive  
);	
port(
    PORT_CLK: in std_logic;
    PORT_NUMBERS: in std_logic_vector(CHANNELS*4-1 downto 0);
    PORT_SEP: in std_logic_vector(CHANNELS-1 downto 0);
    PORT_CAT: out std_logic_vector(7 downto 0);
    PORT_AN: out std_logic_vector(CHANNELS-1 downto 0)
);
end MultiSevSegDriver;

architecture Behavioral of MultiSevSegDriver is

    component SevSegDriver is
    generic(
        RATE_DIVIDER: positive
    );
    port(
        PORT_CLK: in std_logic;            
        PORT_NUMBER: in std_logic_vector(3 downto 0);
        PORT_SEP: in std_logic;
        PORT_CAT: out std_logic_vector(7 downto 0);
        PORT_DONE: out std_logic    
    );
    end component;

    signal done_lines: std_logic_vector(CHANNELS-1 downto 0);
    signal cathodes: std_logic_vector(CHANNELS*8-1 downto 0);
    signal active_select: unsigned(2 downto 0) := (others => '0');
begin
    
    SEG_GEN: for ch in 0 to CHANNELS-1 generate
        iseg: SevSegDriver 
        generic map(
            RATE_DIVIDER => RATE_DIVIDER / CHANNELS
        )
        port map(
            PORT_CLK => PORT_CLK,            
            PORT_NUMBER => PORT_NUMBERS(ch*4+3 downto ch*4),
            PORT_SEP => PORT_SEP(ch),
            PORT_CAT => cathodes(ch*8+7 downto ch*8),
            PORT_DONE => done_lines(ch)
        );
   end generate SEG_GEN;
   
    process
    begin
        wait until rising_edge(PORT_CLK);
        
        if done_lines(0) = '1' then        
            if to_integer(active_select) = CHANNELS-1 then
                active_select <= (others => '0');
            else     
                active_select <= active_select + 1;
            end if;
        end if;
    end process;
    
    PORT_AN <=  std_logic_vector(to_unsigned(2**to_integer(active_select),CHANNELS));
    PORT_CAT <= cathodes(to_integer(active_select)*8+7 downto to_integer(active_select)*8);

end Behavioral;
