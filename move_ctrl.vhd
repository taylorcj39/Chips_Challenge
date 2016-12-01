library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity move_ctrl is
    Port    (chipLoc : in STD_LOGIC_VECTOR(7 downto 0);
             input : in STD_LOGIC_VECTOR(7 downto 0);
             nextLoc : out STD_LOGIC_VECTOR(7 downto 0);
             nextnextLoc : out STD_LOGIC_VECTOR(7 downto 0)
             );
end move_ctrl;

--Button Encoding
--Left = "0"
--Right = "1"
--Up = "2"
--Down = "3"
--A/B/Start/Sel = 7:4
architecture Behavioral of move_ctrl is

begin
process(chipLoc, input)
begin
    if input(0) = '1' then --Move left
        nextLoc <= chipLoc - 1;
        nextnextLoc <= chipLoc - 2;
    elsif input(1) = '1' then -- Move right
        nextLoc <= chipLoc + 1;
        nextnextLoc <= chipLoc + 2;
    elsif input(2) = '1' then --Move up
        nextLoc <= chipLoc - 15;
        nextnextLoc <= chipLoc - 30;
    elsif input(3) = '1' then -- Move down
        nextLoc <= chipLoc + 15;
        nextnextLoc <= chipLoc + 30;
    else
        nextLoc <= X"00";
        nextnextLoc <= X"00";
    end if;
end process;

end Behavioral;