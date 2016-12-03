--Assigns the correct address to next and nextnext registers based on input from NES controller/buttons
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity move_ctrl is
    Port (  clr : in STD_LOGIC;    
            chipLoc : in STD_LOGIC_VECTOR(7 downto 0);      --Location of Chip
            input : in STD_LOGIC_VECTOR(7 downto 0);        --Input of NES controller/buttons    
            nextLoc : out STD_LOGIC_VECTOR(7 downto 0);     --Next location
            nextnextLoc : out STD_LOGIC_VECTOR(7 downto 0)  --Nextnext location
             );
end move_ctrl;

--Button Encoding
--Left = "0"
--Right = "1"
--Up = "2"
--Down = "3"
--A/B/Start/Sel = 7:4
architecture Behavioral of move_ctrl is
signal nextSig, nextnextSig : STD_LOGIC_VECTOR(7 downto 0); --Internal signals which output will be latched to
begin

process(chipLoc, input)
begin
    if clr = '1' then         --Assign all signals and outputs to '0'
        nextLoc <= X"00";
        nextnextLoc <= X"00";
        nextSig <= X"00";
        nextnextSig <= X"00";
    else
        if input = X"1" then        --Move left
            nextLoc <= chipLoc - 1;
            nextnextLoc <= chipLoc - 2;
            nextSig <= chipLoc - 1;
            nextnextSig <= chipLoc - 2;
        elsif input = X"2" then     -- Move right
            nextLoc <= chipLoc + 1;
            nextnextLoc <= chipLoc + 2;
            nextSig <= chipLoc + 1;
            nextnextSig <= chipLoc + 2;
        elsif input = X"4" then     --Move up
            nextLoc <= chipLoc - 15;
            nextnextLoc <= chipLoc - 30;
            nextSig <= chipLoc - 15;
            nextnextSig <= chipLoc - 30;
        elsif input = X"8" then     --Move down
            nextLoc <= chipLoc + 15;
            nextnextLoc <= chipLoc + 30;
            nextSig <= chipLoc + 15;
            nextnextSig <= chipLoc + 30;
        else
            nextLoc <= nextSig;
            nextnextLoc <= nextnextSig;
        end if;
    end if;
end process;

end Behavioral;