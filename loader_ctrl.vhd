library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity loader_ctrl is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           lastF : in STD_LOGIC;        --Input signifying when the last address has been reached
           countPlus : out STD_LOGIC;   --Output to counter to increment count
           readyF : out STD_LOGIC);     --Output signifying all data has been written
end loader_ctrl;

architecture Behavioral of loader_ctrl is
    --definition of states
    type state_type is (Start, Increment, Write, Delay, Ready);
    
    signal current_state, next_state: state_type;
    begin
    
    --Timekeeping register ensures states transition on rising clk edge
    T : process(clk, clr)
    begin
        if clr = '1' then
            current_state <= Start;
        elsif clk'event and clk = '1' then
            current_state <= next_state;
        end if;
    end process;    

    --Control Flow
    C1 : process(current_state, lastF)
    begin
        case current_state is
            when Start =>               --Beginning 
                next_state <= Write;
            when Write =>               --Writes to RAM
                next_state <= Delay;
            when Delay =>               --Delay to account for latenncy of RAM
                next_state <= Increment;
            when Increment =>           --Increment address to be written
                if lastF = '0' then
                    next_state <= Write;
                else
                    next_state <= Ready;
                end if;
            when Ready =>               --The RAM has been successfully rewritten
                next_state <= Ready;
            when others =>
                null;
        end case;
    end process;
    
    --Actions at each state         
    C2 : process(current_state)
    begin
        countPlus <= '0'; readyF <= '0';
        case current_state is
            when Increment =>       --Add signal for counter in DP
                countPlus <= '1';   
            when Ready =>           
                readyF <= '1';      --Signifies that the RAM has been successfully rewritten
            when others =>
                null;
        end case;    
    end process;
end Behavioral;
