library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity move_ctrl is
    generic (N: integer := 8);
    Port    (currentP : in STD_LOGIC_VECTOR(N-1 downto 0);
             dir : in STD_LOGIC_VECTOR(4 downto 0);
             nextM : out STD_LOGIC_VECTOR(N-1 downto 0)
             );
end move_ctrl;

architecture Behavioral of move_ctrl is

begin
process(currentP,dir)
begin
    if dir(4) = '1' then --Move up
        nextM <= currentP - 4;
    elsif dir(3) = '1' then -- Move down
        nextM <= currentP + 4; 
    elsif dir(2) = '1' then --Move left
        nextM <= currentP - 1;
    elsif dir(0) = '1' then -- Move right
        nextM <= currentP + 1;
    else
        null;
    end if;
end process;

end Behavioral;