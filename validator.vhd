--Outputs appropriate flag based on what is inside current RAM address
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity validator is
    Port ( data : in STD_LOGIC_VECTOR(3 downto 0);                      --Data inside RAM
           go : in STD_LOGIC;                                           --Enables component
           winF,gateF,blockF,emptyF,wallF,waterF,keyF : out STD_LOGIC); --Flag based on cotents of RAM address
end validator;

architecture Behavioral of validator is

--ROM Encoding:
-- Block Type     Encoded Data Value
-- Empty                  0
-- Wall                   1
-- Chip                   2
-- block                  3
-- water                  4
-- drowning chip          5
-- key(collectible chip)  6
-- gate                   7
-- win                    8    
 
begin
    process(go, data)
    begin
    --All signals => '0' when appropriate data is not present
    winF <= '0'; gateF <= '0'; blockF <= '0'; emptyF <= '0'; wallF <= '0'; waterF <= '0'; keyF<= '0';
    if go = '1' then
        case data is
            when "0000"=>
                emptyF <= '1';
            when "0001" =>
                wallF <= '1';
            --when "0010" =>
            when "0011" =>
                blockF <= '1';
            when "0100" =>
                waterF <= '1';
            --when "0101" =>
            when "0110" =>
                keyF <= '1';
            when "0111" =>
                gateF <= '1';
            when "1000" =>
                winF <= '1';
            when others =>
                null;
        end case;
    end if;    
    end process;    

end Behavioral;
