library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
port(
    PORT_CLK50: in std_logic;
    -- display
    PORT_SEGAN: out std_logic_vector(3 downto 0);
    PORT_SEGCAT: out std_logic_vector(7 downto 0);
    -- leds
    PORT_LEDS: out std_logic_vector(7 downto 0);
    -- epp
    PORT_EPPDB: inout std_logic_vector(7 downto 0);
    PORT_EPPASTB: in std_logic;
    PORT_EPPDSTB: in std_logic;
    PORT_EPPWRITE: in std_logic;
    PORT_EPPWAIT: out std_logic    
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
    
    component ClockEPP is
    port(
        PORT_CLK50: in std_logic;
        PORT_DB: inout std_logic_vector(7 downto 0);
        PORT_ASTB: in std_logic;
        PORT_DSTB: in std_logic;
        PORT_WRITE: in std_logic;
        PORT_WAIT: out std_logic;
        
        PORT_MINUTES1: out std_logic_vector(3 downto 0);
        PORT_MINUTES10: out std_logic_vector(3 downto 0);
        PORT_HOURS1: out std_logic_vector(3 downto 0);
        PORT_HOURS10: out std_logic_vector(3 downto 0);
        PORT_SDMODE: out std_logic_vector(2 downto 0);
        PORT_UPD: out std_logic
    );
    end component;
    
    
    signal seg_cathodes: std_logic_vector(7 downto 0);
    signal seg_anodes: std_logic_vector(3 downto 0);
    signal seg_dots: std_logic_vector(3 downto 0);

    attribute keep: string;
    attribute keep of seg_cathodes :signal is "true";
    -- epp
    
    -- clock
    constant SDMODE_FLASH_ALL8: std_logic_vector(2 downto 0) := "000";
    constant SDMODE_PROGRESS8: std_logic_vector(2 downto 0) := "001"; 
    constant SDMODE_COUNT8: std_logic_vector(2 downto 0) := "010"; 
    constant SDMODE_FLASH_ALL4: std_logic_vector(2 downto 0) := "011"; 
    constant SDMODE_PROGRESS4: std_logic_vector(2 downto 0) := "100";  
    constant SDMODE_PROGRESS8_FLASH4: std_logic_vector(2 downto 0) := "101";
    signal sdmode: std_logic_vector(2 downto 0) := SDMODE_FLASH_ALL8;
    
    signal sd_flash: std_logic := '0';
    constant PROGRESSCNT8_MAX: unsigned(28 downto 0) := to_unsigned(375000000-1, 29);
    signal sd_progesscnt8: unsigned(28 downto 0) := (others => '0');
    constant PROGRESSCNT4_MAX: unsigned(29 downto 0) := to_unsigned(750000000-1, 30);
    signal sd_progesscnt4: unsigned(29 downto 0) := (others => '0');
    -- shift reg @ 7500 sec
    signal sd_progress8: std_logic_vector(7 downto 0) := "00000001";
    -- shift reg @ 15000 sec
    signal sd_progress4: std_logic_vector(3 downto 0) := "0001";
    
    
    constant SECONDS_MAX: unsigned(5 downto 0) := to_unsigned(60-1, 6);
    signal seconds: unsigned(5 downto 0) := (others => '0');
    signal minutes_1: unsigned(3 downto 0) := (others => '0');
    signal minutes_10: unsigned(3 downto 0) := (others => '0');
    signal hours_1: unsigned(3 downto 0) := (others => '0');
    signal hours_10: unsigned(3 downto 0) := (others => '0');
    
    
    -- clock not active on epp action
    signal update: std_logic;
    signal advance: std_logic;
    constant DIVIDER_MAX: unsigned(25 downto 0) := to_unsigned(50000000-1, 26);
    signal divider: unsigned(25 downto 0) := (others => '0');  
    
    -- epp data registers    
    signal minutes_1_reg: std_logic_vector(3 downto 0);
    signal minutes_10_reg: std_logic_vector(3 downto 0);
    signal hours_1_reg: std_logic_vector(3 downto 0);
    signal hours_10_reg: std_logic_vector(3 downto 0);
    signal sdmode_reg: std_logic_vector(2 downto 0);
    
    -- draw
    signal display: std_logic_vector(15 downto 0);   
    signal leds: std_logic_vector(7 downto 0);
begin

    TIMEBASE: process
    begin
        wait until rising_edge(PORT_CLK50);
                              
        advance <= '0';
        
        if update = '1' then
            sd_flash <= '0';
            divider <= (others => '0');
        else
            if divider = DIVIDER_MAX then
                divider <= (others => '0');
                advance <= '1';
                sd_flash <= not sd_flash;
            else
                divider <= divider + 1;
            end if;
        end if;
        
        -- sd progess counters
        if update = '1' then
            sd_progesscnt8 <= (others => '0');
            sd_progress8 <= "00000001";
            
            sd_progesscnt4 <= (others => '0');
            sd_progress4 <= "0001"; 
        else
        
        -- progress8
            if sd_progesscnt8 = PROGRESSCNT8_MAX then
                sd_progesscnt8 <= (others => '0');
                            
                if sd_progress8 = "11111111" then
                    sd_progress8 <= "00000001";
                 else
                    sd_progress8 <= sd_progress8(6 downto 0) & '1';
                 end if;
            else
                sd_progesscnt8 <= sd_progesscnt8 + 1;
            end if;
            
            -- progress4
            if sd_progesscnt4 = PROGRESSCNT4_MAX then
                sd_progesscnt4 <= (others => '0');
                
                if sd_progress4 = "1111" then
                    sd_progress4 <= "0001";
                 else
                    sd_progress4 <= sd_progress4(2 downto 0) & '1';
                 end if;
            else
                sd_progesscnt4 <= sd_progesscnt4 + 1;
            end if;
        end if;
                       
    end process;
    
    CLKLOGIC: process
    begin
        wait until rising_edge(PORT_CLK50);
        
        if update = '1' then
            -- read from epp
            
            -- restart counter
            seconds <= (others => '0');
            minutes_1 <= unsigned(minutes_1_reg);
            minutes_10 <= unsigned(minutes_10_reg);
            hours_1 <= unsigned(hours_1_reg);
            hours_10 <= unsigned(hours_10_reg);
            sdmode <= sdmode_reg;
        elsif advance = '1' then
            -- advance 
            -- seconds            
            if seconds = SECONDS_MAX then
                seconds <= (others => '0');
                
                -- minutes 1: 0-9
                if minutes_1 = "1001" then
                    minutes_1 <= (others => '0');
                    
                    -- minutes 10: 0-5 
                    if minutes_10 = "0101" then
                        minutes_10 <= (others => '0');
                        
                        -- hours 1: 0-9
                        if hours_1 = "1001" or (hours_10 = "0010" and hours_1 = "0011") then
                            hours_1 <= (others => '0');
                            
                            -- hours 10: 0-2
                            if hours_10 = "0010" then
                                hours_10 <= (others => '0');
                            else
                                hours_10 <= hours_10 + 1;
                            end if;                                                   
                        else
                            hours_1 <= hours_1 + 1;
                        end if;                                                   
                    else
                        minutes_10 <= minutes_10 + 1;
                    end if;                                                   
                else
                    minutes_1 <= minutes_1 + 1;
                end if;                               
            else
                seconds <= seconds + 1;
            end if;            
        end if;
    end process;
    
    -- epp clock logic
    iclock: ClockEPP port map(    
        PORT_CLK50 => PORT_CLK50,
        PORT_DB => PORT_EPPDB,
        PORT_ASTB => PORT_EPPASTB,
        PORT_DSTB => PORT_EPPDSTB,
        PORT_WRITE => PORT_EPPWRITE,
        PORT_WAIT => PORT_EPPWAIT,        
        PORT_MINUTES1 => minutes_1_reg, 
        PORT_MINUTES10 => minutes_10_reg,
        PORT_HOURS1 => hours_1_reg,
        PORT_HOURS10 => hours_10_reg,
        PORT_SDMODE => sdmode_reg,
        PORT_UPD => update
    );
    
    
    SDMODE_OUTPUT: process(sdmode, sd_flash, seconds, sd_progress8, sd_progress4)
    begin
        case sdmode is
            when SDMODE_FLASH_ALL8 =>
                leds <= (others => sd_flash);
                seg_dots <= (others => '0');
            when SDMODE_COUNT8 =>
                leds <= "00" & std_logic_vector(seconds);
                seg_dots <= (others => '0');
            when SDMODE_PROGRESS8 => 
                leds <= std_logic_vector(sd_progress8);
                seg_dots <= (others => '0');
            when SDMODE_FLASH_ALL4 =>
                seg_dots <= (others => sd_flash);
                leds <= (others => '0');
            when SDMODE_PROGRESS4 =>
                seg_dots <= std_logic_vector(sd_progress4);
                leds <= (others => '0');
            when SDMODE_PROGRESS8_FLASH4 =>
                leds <= std_logic_vector(sd_progress8);
                seg_dots <= (others => sd_flash);
            when others =>
                seg_dots <= (others => '0');
                leds <= (others => '0');
        end case;
    end process;
    

    -- display logic
    display <= std_logic_vector(hours_10) & std_logic_vector(hours_1) & std_logic_vector(minutes_10) & std_logic_vector(minutes_1);
        
    isegs: MultiSevSegDriver 
    generic map(
        CHANNELS => 4,
        RATE => 100
    )
    port map(
        PORT_CLK50 => PORT_CLK50,
        PORT_NUMBERS => display,
        PORT_SEP => seg_dots,
        PORT_CAT => seg_cathodes,
        PORT_AN => seg_anodes
    );

    PORT_LEDS <= leds;
     
    PORT_SEGAN <= not seg_anodes;
    
    PORT_SEGCAT(7) <= 'Z' when seg_cathodes(7) = '0' else '0';
    PORT_SEGCAT(6) <= 'Z' when seg_cathodes(6) = '0' else '0';
    PORT_SEGCAT(5) <= 'Z' when seg_cathodes(5) = '0' else '0';
    PORT_SEGCAT(4) <= 'Z' when seg_cathodes(4) = '0' else '0';
    PORT_SEGCAT(3) <= 'Z' when seg_cathodes(3) = '0' else '0';
    PORT_SEGCAT(2) <= 'Z' when seg_cathodes(2) = '0' else '0';
    PORT_SEGCAT(1) <= 'Z' when seg_cathodes(1) = '0' else '0';
    PORT_SEGCAT(0) <= 'Z' when seg_cathodes(0) = '0' else '0';

end Behavioral;