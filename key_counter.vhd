--Is there a latch in here? output is lagging behind signal
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity key_counter is
    Port ( keyPlus : in STD_LOGIC;
           keyStart : in STD_LOGIC_VECTOR(2 downto 0);
           clr : in STD_LOGIC;
           clk : in STD_LOGIC;
           remKeys : out STD_LOGIC_VECTOR(2 downto 0));
end key_counter;

architecture Behavioral of key_counter is
signal keysLeft1, keysLeft2 : STD_LOGIC_VECTOR(2 downto 0);
begin
	process(keyStart,keyPlus,clr, clk)
	begin
        if clr = '1' then
		    remKeys <= keyStart;
			keysLeft1 <= keyStart;
			keysLeft2 <= keyStart;
		elsif clk'event and clk = '1' then
		    if keyPlus = '1' then
                keysLeft1 <= keysLeft1 - 1;
                keysLeft2 <= keysLeft1;
		    end if;
		end if;
		    							 
	end process;
	
process()
if keysLeft2 = keysLeft1 then
    remKeys <= keysLeft2;
else
    remKeys <= keysLeft1;
end if;
end process();			
end Behavioral;

