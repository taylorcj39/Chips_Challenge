
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity writer is
    Port ( wChipLoc,wNextLoc,wNextnextLoc : in STD_LOGIC;
           chipLoc, nextLoc, nextnextLoc: in STD_LOGIC_VECTOR(7 downto 0);
           wEmpty, wChip, wBrick, wDrown : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR(7 downto 0);
           data : out STD_LOGIC_VECTOR(3 downto 0);
           we : out STD_LOGIC);
end ;

architecture Behavioral of writer is
    
begin
    process(wChipLoc, wNextLoc, wNextnextLoc, chipLoc, nextLoc, nextnextLoc, wEmpty, wChip, wBrick, wDrown)
    begin
        --All signals => '0' when appropriate data is not present
        addr <= X"00"; data <= X"0"; we <= '0';
        --we will be high when any select input is high
        we <= wEmpty or wChip or wBrick or wDrown; 
        
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
        elsif wBrick = '1' then
            data <= X"3";
        elsif wDrown = '1' then
            data <= X"5";    
        end if;    
    end process;    

end Behavioral;
