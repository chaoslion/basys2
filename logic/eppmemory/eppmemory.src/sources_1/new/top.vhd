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
    PORT_LEDS: OUT std_logic_vector(7 downto 0);        
    PORT_EPPDB: INOUT std_logic_vector(7 downto 0);
    PORT_EPPASTB: IN std_logic;
    PORT_EPPDSTB: IN std_logic;
    PORT_EPPWRITE: IN std_logic;
    PORT_EPPWAIT: OUT std_logic	       
);
end top;

architecture Behavioral of top is

    component eppctrl is
    port(
        PORT_CLK: in std_logic;
        PORT_DB: INOUT std_logic_vector(7 downto 0);
        PORT_ASTB: IN std_logic;
        PORT_DSTB: IN std_logic;
        PORT_WRITE: IN std_logic;
        PORT_WAIT: OUT std_logic;
        PORT_RAM_WEA : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        PORT_RAM_ADDRA: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        PORT_RAM_DINA: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        PORT_RAM_DOUTA: IN STD_LOGIC_VECTOR(7 DOWNTO 0)      
    );
    end component;
    
    component ram256byte
      PORT (
          clka : IN STD_LOGIC;
          wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
          addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    end component;
    
    signal epp_ram_wea: std_logic_vector(0 downto 0);
    signal epp_ram_addra: std_logic_vector(7 downto 0);
    signal epp_ram_dina: std_logic_vector(7 downto 0);
    signal epp_ram_douta: std_logic_vector(7 downto 0);
    
    signal leds: std_logic_vector(7 downto 0);
begin
    
    

    iram: ram256byte
    port map(
        clka => PORT_CLK50,
        wea => epp_ram_wea,
        addra => epp_ram_addra,
        dina => epp_ram_dina,
        douta => epp_ram_douta
    );

                
    ieppctrl: eppctrl
    port map(
       PORT_CLK => PORT_CLK50,
       PORT_DB => PORT_EPPDB,
       PORT_ASTB => PORT_EPPASTB,
       PORT_DSTB => PORT_EPPDSTB,
       PORT_WRITE => PORT_EPPWRITE,
       PORT_WAIT => PORT_EPPWAIT,
                     
       PORT_RAM_WEA => epp_ram_wea,
       PORT_RAM_ADDRA => epp_ram_addra,
       PORT_RAM_DINA => epp_ram_dina,
       PORT_RAM_DOUTA => epp_ram_douta
    );   
 
    process
    begin
        wait until rising_edge(PORT_CLK50);
        if epp_ram_wea = "1" and epp_ram_addra = x"00" then            
            leds <= epp_ram_dina;             
        end if;
    end process;
    
    PORT_LEDS <= leds;

end Behavioral;
