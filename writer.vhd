
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity writer is
    Port ( wChipLoc,wNextLoc,wNextnextLoc : in STD_LOGIC;                   --Which location will be written to RAM
           chipLoc, nextLoc, nextnextLoc: in STD_LOGIC_VECTOR(7 downto 0);  --Location of Chip, next, and nextnext
           wEmpty, wChip, wBlock, wDrown : in STD_LOGIC;                    --Which object will be output
           addr : out STD_LOGIC_VECTOR(7 downto 0);                         --Address to be output to RAM
           data : out STD_LOGIC_VECTOR(3 downto 0);                         --Data to be output to RAM
           we : out STD_LOGIC);                                             --Enables data to be written to RAM
end ;

architecture Behavioral of writer is
    
begin
    process(wChipLoc, wNextLoc, wNextnextLoc, chipLoc, nextLoc, nextnextLoc, wEmpty, wChip, wBlock, wDrown)
    begin
       
        addr <= X"00"; data <= X"0"; we <= '0';     --All signals => '0' when appropriate data is not present
        we <= wEmpty or wChip or wBlock or wDrown;  --we will be high when any select input is high
        
        --assign address to appropriate value
        if wChipLoc = '1' then
            addr <= chipLoc;
        elsif wNextLoc = '1' then
            addr <= nextLoc;
        elsif wNextnextLoc = '1' then
            addr <= nextnextLoc;
        end if;
        
        --assign data to be written
        if wEmpty = '1' then
            data <= X"0";
        elsif wChip = '1' then
            data <= X"2";
        elsif wBlock = '1' then
            data <= X"3";
        elsif wDrown = '1' then
            data <= X"5";    
        end if;    
    end process;    

end Behavioral;
