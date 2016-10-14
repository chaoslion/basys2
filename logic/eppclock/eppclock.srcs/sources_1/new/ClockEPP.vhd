library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockEPP is
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
end ClockEPP;

architecture Behavioral of ClockEPP is    
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
    
    -- Internal control signales
    signal	ctlEppWait	: std_logic;
    signal	ctlEppAstb	: std_logic;
    signal	ctlEppDstb	: std_logic;
    signal	ctlEppDir	: std_logic;
    signal	ctlEppWr	: std_logic;
    signal	ctlEppAwr	: std_logic;
    signal	ctlEppDwr	: std_logic;
    signal	busEppOut	: std_logic_vector(7 downto 0);
    signal	busEppIn	: std_logic_vector(7 downto 0);
    signal	busEppData	: std_logic_vector(7 downto 0);
    
    -- Registers
    signal regEppAdr: std_logic_vector(3 downto 0);
    
    signal reg_minutes1: std_logic_vector(3 downto 0);
    signal reg_minutes10: std_logic_vector(3 downto 0);
    signal reg_hours1: std_logic_vector(3 downto 0);
    signal reg_hours10: std_logic_vector(3 downto 0);
    signal reg_sdmode: std_logic_vector(2 downto 0);
    
    signal reg_upd: std_logic;
begin

    
    PORT_MINUTES1 <= reg_minutes1;
    PORT_MINUTES10 <= reg_minutes10;
    PORT_HOURS1 <= reg_hours1;
    PORT_HOURS10 <= reg_hours10;
    PORT_SDMODE <= reg_sdmode;

    PORT_UPD <= reg_upd;
    
    ctlEppAstb <= PORT_ASTB;
    ctlEppDstb <= PORT_DSTB;
    ctlEppWr   <= PORT_WRITE;
    PORT_WAIT    <= ctlEppWait;	-- drive WAIT from state machine output
    
    -- Data bus direction control. The internal input data bus always
    -- gets the port data bus. The port data bus drives the internal
    -- output data bus onto the pins when the interface says we are doing
    -- a read cycle and we are in one of the read cycles states in the
    -- state machine.
    busEppIn <= PORT_DB;
    PORT_DB <= busEppOut when ctlEppWr = '1' and ctlEppDir = '1' else "ZZZZZZZZ";

    -- Select either address or data onto the internal output data bus.
    busEppOut <= "0000" & regEppAdr when ctlEppAstb = '0' else busEppData;
    
	-- Decode the address register and select the appropriate data register	
    busEppData <=        
        "0000" & reg_minutes1 when regEppAdr = "0000" else
        "0000" & reg_minutes10 when regEppAdr = "0001" else
        "0000" & reg_hours1 when regEppAdr = "0010" else
        "0000" & reg_hours10 when regEppAdr = "0011" else
        "00000" & reg_sdmode when regEppAdr = "0100" else					   
        "00000000";

    ------------------------------------------------------------------------
	-- EPP Interface Control State Machine
    ------------------------------------------------------------------------

    -- Map control signals from the current state
    ctlEppWait <= stEppCur(0);
    ctlEppDir  <= stEppCur(1);
    ctlEppAwr  <= stEppCur(2);
    ctlEppDwr  <= stEppCur(3);
    
    	-- This process moves the state machine to the next state
    	-- on each clock cycle
    process
    begin
        wait until rising_edge(PORT_CLK50);    
        stEppCur <= stEppNext;
    end process;
    
    -- This process determines the next state machine state based
    -- on the current state and the state machine inputs.
    process (stEppCur, stEppNext, ctlEppAstb, ctlEppDstb, ctlEppWr)
    begin
        case stEppCur is
            -- Idle state waiting for the beginning of an EPP cycle
            when stEppReady =>
                if ctlEppAstb = '0' then
                    -- Address read or write cycle
                    if ctlEppWr = '0' then
                        stEppNext <= stEppAwrA;
                    else
                        stEppNext <= stEppArdA;
                    end if;

                elsif ctlEppDstb = '0' then
                    -- Data read or write cycle
                    if ctlEppWr = '0' then
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
                if ctlEppAstb = '0' then
                    stEppNext <= stEppAwrB;
                else
                    stEppNext <= stEppReady;
                end if;		

            -- Read address register
            when stEppArdA =>
                stEppNext <= stEppArdB;

            when stEppArdB =>
                if ctlEppAstb = '0' then
                    stEppNext <= stEppArdB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Write data register
            when stEppDwrA =>
                stEppNext <= stEppDwrB;

            when stEppDwrB =>
                if ctlEppDstb = '0' then
                    stEppNext <= stEppDwrB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Read data register
            when stEppDrdA =>
                stEppNext <= stEppDrdB;
                                    
            when stEppDrdB =>
                if ctlEppDstb = '0' then
                    stEppNext <= stEppDrdB;
                else
                    stEppNext <= stEppReady;
                end if;

            -- Some unknown state				
            when others =>
                stEppNext <= stEppReady;

        end case;
    end process;
    		
        ------------------------------------------------------------------------
    	-- EPP Address register
        ------------------------------------------------------------------------
    
    process
    begin
        wait until rising_edge(PORT_CLK50);
        
        if ctlEppAwr = '1' then
            regEppAdr <= busEppIn(3 downto 0);
        end if;        
    end process;
    
    process
    begin
        wait until rising_edge(PORT_CLK50);
                
        reg_upd <= '0';
        if ctlEppDwr = '1' then
            case regEppAdr is                
                when "0000" => reg_minutes1 <= busEppIn(3 downto 0);
                when "0001" => reg_minutes10 <= busEppIn(3 downto 0);
                when "0010" => reg_hours1 <= busEppIn(3 downto 0);
                when "0011" => reg_hours10 <= busEppIn(3 downto 0);
                when "0100" => reg_sdmode <= busEppIn(2 downto 0);
                when others => null;
            end case;
            reg_upd <= '1';
        end if;
    end process;

end Behavioral;
