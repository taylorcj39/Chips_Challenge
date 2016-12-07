
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
entity clkdiv is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           clk250 : out STD_LOGIC;
           clks : out STD_LOGIC
           );
end clkdiv;

architecture Behavioral of clkdiv is
signal q: STD_LOGIC_VECTOR(23 downto 0);

begin
process(mclk, clr)
begin
    if clr = '1' then
        q <= X"000000";
        elsif mclk'event and mclk = '1' then
        q <= q + 1;
        end if;
end process;
clk250 <= q(1);    --25 MHZ VGA clock speed
clks <= q(12);      -- Debounce clock speed, 195312.5 HZ
end Behavioral;
