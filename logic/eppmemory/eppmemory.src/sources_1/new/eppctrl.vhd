----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2016 09:23:53
-- Design Name: 
-- Module Name: eppctrl - Behavioral
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
use ieee.math_real.log2;
use ieee.math_real.ceil;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eppctrl is
port(
    PORT_CLK: in std_logic;
    PORT_DB: inout std_logic_vector(7 downto 0);
    PORT_ASTB: in std_logic;
    PORT_DSTB: in std_logic;
    PORT_WRITE: in std_logic;
    PORT_WAIT: out std_logic;
                
    PORT_RAM_WEA : out std_logic_vector(0 DOWNTO 0);
    PORT_RAM_ADDRA: out std_logic_vector(7 DOWNTO 0);
    PORT_RAM_DinA: out std_logic_vector(7 DOWNTO 0);
    PORT_RAM_DOUTA: in std_logic_vector(7 DOWNTO 0)
);
end eppctrl;

architecture Behavioral of eppctrl is

    constant	stEppReady	: std_logic_vector(7 downto 0) := "0000" & "0000";
    constant	stEppAwrA	: std_logic_vector(7 downto 0) := "0001" & "0100";
    constant	stEppAwrB	: std_logic_vector(7 downto 0) := "0010" & "0001";
    constant	stEppArdA	: std_logic_vector(7 downto 0) := "0011" & "0010";
    constant	stEppArdB	: std_logic_vector(7 downto 0) := "0100" & "0011";
    constant	stEppDwrA	: std_logic_vector(7 downto 0) := "0101" & "1000";
    constant	stEppDwrB	: std_logic_vector(7 downto 0) := "0110" & "0001";
    constant	stEppDrdA	: std_logic_vector(7 downto 0) := "0111" & "0010";
    constant	stEppDrdB	: std_logic_vector(7 downto 0) := "1000" & "0011";
    
    signal	stEppCur	: std_logic_vector(7 downto 0) := stEppReady;
    signal	stEppNext	: std_logic_vector(7 downto 0);
    
    signal	ctlEppWait	: std_logic;
    signal	ctlEppAstb	: std_logic;
    signal	ctlEppDstb	: std_logic;
    signal	ctlEppDir	: std_logic;    
    signal	ctlEppAwr	: std_logic;
    signal	ctlEppDwr	: std_logic;
    signal	busEppOut	: std_logic_vector(7 downto 0);
    signal	busEppIn	: std_logic_vector(7 downto 0);
    signal	busEppData	: std_logic_vector(7 downto 0);
    
    -- Registers
    signal regEppAdr: std_logic_vector(7 downto 0);
    signal ram_wea: std_logic_vector(0 DOWNTO 0);
    signal ram_dina: std_logic_vector(7 DOWNTO 0);     
begin
		
	busEppIn <= PORT_DB;
	PORT_DB <= busEppOut when PORT_WRITE = '1' and ctlEppDir = '1' else "ZZZZZZZZ";
	PORT_WAIT    <= ctlEppWait;
	busEppOut <= regEppAdr when PORT_ASTB = '0' else busEppData;
	PORT_RAM_ADDRA <= regEppAdr;
	busEppData <= PORT_RAM_DOUTA;
	
    PORT_RAM_WEA <= ram_wea;
    PORT_RAM_DINA <= ram_dina;

	ctlEppWait <= stEppCur(0);
	ctlEppDir  <= stEppCur(1);
	ctlEppAwr  <= stEppCur(2);
	ctlEppDwr  <= stEppCur(3);
		
    process
    begin
        wait until rising_edge(PORT_CLK);        
        stEppCur <= stEppNext;
    end process;
    
        process
    begin
        wait until rising_edge(PORT_CLK);
        if ctlEppAwr = '1' then
            regEppAdr <= busEppIn;
        end if;        
    end process;

    process
    begin
        wait until rising_edge(PORT_CLK);
        ram_wea <= "0";            
        if ctlEppDwr = '1' then                       
            ram_wea <= "1";
            ram_dina <= busEppIn;            
        end if;        
    end process;
    	
	process (stEppCur, stEppNext, PORT_ASTB, PORT_DSTB, PORT_WRITE)
    begin
        case stEppCur is
            -- Idle state waiting for the beginning of an EPP cycle
            when stEppReady =>
                if PORT_ASTB = '0' then
                    -- Address read or write cycle
                    if PORT_WRITE = '0' then
                        stEppNext <= stEppAwrA;
                    else
                        stEppNext <= stEppArdA;
                    end if;

                elsif PORT_DSTB = '0' then
                    -- Data read or write cycle
                    if PORT_WRITE = '0' then
                        stEppNext <= stEppDwrA;
                    else
                        stEppNext <= stEppDrdA;
                    end if;

                else
                    -- Remain in ready state
                    stEppNext <= stEppReady;
                end if;											

            -- Write address register
            when stEppAwrA =>
                stEppNext <= stEppAwrB;

            when stEppAwrB =>
                if PORT_ASTB = '0' then
                    stEppNext <= stEppAwrB;
                else
                    stEppNext <= stEppReady;
                end if;		

            -- Read address register
            when stEppArdA =>
                stEppNext <= stEppArdB;

            when stEppArdB =>
                if PORT_ASTB = '0' then
                    stEppNext <= stEppArdB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Write data register
            when stEppDwrA =>
                stEppNext <= stEppDwrB;

            when stEppDwrB =>
                if PORT_DSTB = '0' then
                    stEppNext <= stEppDwrB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Read data register
            when stEppDrdA =>
                stEppNext <= stEppDrdB;
                                    
            when stEppDrdB =>
                if PORT_DSTB = '0' then
                    stEppNext <= stEppDrdB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Some unknown state				
            when others =>
                stEppNext <= stEppReady;

        end case;
    end process;
    
end Behavioral;
