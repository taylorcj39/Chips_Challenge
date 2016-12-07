library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity debounce4 is
    Port ( inp : in STD_LOGIC_VECTOR (7 downto 0);
           cclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           outp : out STD_LOGIC_VECTOR (7 downto 0));
end debounce4;

architecture Behavioral of debounce4 is
signal delay1, delay2, delay3, delay4: STD_LOGIC_VECTOR(7 downto 0);
begin
process(cclk, clr)
begin
    if clr = '1' then
        delay1 <= "00000000";
        delay2 <= "00000000";
        delay3 <= "00000000";
        delay4 <= "00000000";
    elsif cclk'event and cclk = '1' then
        delay1 <= inp;
        delay2 <= delay1;
        delay3 <= delay2;
        delay4 <= delay3;
    end if;
end process;
outp <= delay1 and delay2 and delay3 and delay4;

end Behavioral;
