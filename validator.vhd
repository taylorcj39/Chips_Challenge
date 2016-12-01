
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity validator is
    Port ( data : in STD_LOGIC_VECTOR(3 downto 0);
           go : in STD_LOGIC;
           winF,gateF,blockF,emptyF,wallF,waterF,keyF : out STD_LOGIC);
end validator;

architecture Behavioral of validator is
    
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
