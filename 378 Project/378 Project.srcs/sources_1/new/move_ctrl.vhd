library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity move_ctrl is
    generic (N: integer := 8);
    Port    (currentp : in STD_LOGIC_VECTOR(N-1 downto 0);
             btn : in STD_LOGIC_VECTOR(4 downto 0);
             nextm : out STD_LOGIC_VECTOR(N-1 downto 0)
             );
            

end move_ctrl;

architecture Behavioral of move_ctrl is

begin
process(currentp,btn)
begin
    if btn(4) = '1' then --Move up
        nextm <= currentp - 4;
    elsif btn(3) = '1' then -- Move down
        nextm <= currentp + 4; 
    elsif btn(2) = '1' then --Move left
        nextm <= currentp - 1;
    elsif btn(0) = '1' then -- Move right
        nextm <= currentp + 1;
    else
        null;
    end if;
end process;

end Behavioral;
