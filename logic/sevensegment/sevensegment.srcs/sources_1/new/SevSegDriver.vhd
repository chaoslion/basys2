library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity SevSegDriver is
generic(
    RATE: integer := 100
);
port(
    PORT_CLK50: in std_logic;            
    PORT_NUMBER: in std_logic_vector(3 downto 0);
    PORT_SEP: in std_logic;
    PORT_CAT: out std_logic_vector(7 downto 0);
    PORT_DONE: out std_logic    
);
end SevSegDriver;

architecture Behavioral of SevSegDriver is
    constant RATE_DIVIDER: integer := integer(ceil(real(50000000/(RATE*8))));
    constant SEG_MAX: unsigned(16 downto 0) := to_unsigned(RATE_DIVIDER-1, 17);
    signal seg_cnt: unsigned(16 downto 0) := (others => '0');    
    signal ca_mask_active: std_logic_vector(7 downto 0) := "00000001";
    signal ca_mask: std_logic_vector(7 downto 0);    
    
    signal seg_done: std_logic;
    signal all_done: std_logic;
begin

    process 
    begin
        wait until rising_edge(PORT_CLK50);
        
        seg_done <= '0';
        if seg_cnt = SEG_MAX then
            seg_done <= '1';
            seg_cnt <= (others => '0');
        else
            seg_cnt <= seg_cnt + 1;
        end if;
    end process;
    
    process 
    begin
        wait until rising_edge(PORT_CLK50);
                
        all_done <= '0';
        if seg_done = '1' then
            if ca_mask_active = "10000000" then                            
                ca_mask_active <= "00000001";    
                all_done <= '1';                            
            else
                ca_mask_active <= ca_mask_active(6 downto 0) & '0';
            end if;
        end if;
    end process;
      
    process 
    begin
        wait until rising_edge(PORT_CLK50);
                                      
        if seg_cnt = SEG_MAX then            
            seg_cnt <= (others => '0');            
        else
            seg_cnt <= seg_cnt + 1;
        end if;                     
    end process;
    
    ca_mask(7) <= PORT_SEP;
    ca_mask(6 downto 0) <= 
        "1111110" when PORT_NUMBER = x"0" else 
        "0110000" when PORT_NUMBER = x"1" else
        "1101101" when PORT_NUMBER = x"2" else
        "1111001" when PORT_NUMBER = x"3" else
        "0110011" when PORT_NUMBER = x"4" else    		
        "1011011" when PORT_NUMBER = x"5" else
        "1011111" when PORT_NUMBER = x"6" else
        "1110000" when PORT_NUMBER = x"7" else
        "1111111" when PORT_NUMBER = x"8" else
        "1110011" when PORT_NUMBER = x"9" else
        "0000000";                                                                              		     

    PORT_CAT <= ca_mask and ca_mask_active;    
    PORT_DONE <= all_done;      

end Behavioral;
