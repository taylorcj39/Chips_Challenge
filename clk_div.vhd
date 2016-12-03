--Clock divider component-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity clk_div is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           clk13M : out STD_LOGIC
    );
end clk_div;

architecture Behavioral of clk_div is
    signal q: STD_LOGIC_VECTOR(23 downto 0);
begin
    process(mclk,clr)
    begin
        if clr = '1' then
            q <= X"000000";
        elsif mclk'event and mclk = '1' then
            q <= q+1;
        end if;
    end process;
    
    --Samples the 14th  bit to get Fmclk(50MHz)/(2^3)=12.5MHz
    clk13M <= q(2);
end Behavioral;
