
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity key_counter is
    Port ( keyPlus : in STD_LOGIC;
           keyStart : in STD_LOGIC_VECTOR(2 downto 0);
           clr : in STD_LOGIC;
           remKeys : out STD_LOGIC_VECTOR(2 downto 0));
end key_counter;

architecture Behavioral of key_counter is
signal keysLeft : STD_LOGIC_VECTOR(2 downto 0);
begin
	process(keyStart,keyPlus,clr)
	begin
		if clr = '1' then
		    keysLeft <= keyStart;
			remKeys <= keysLeft;
		else 
			if keyPlus = '1' then 
			     keysLeft <= keysLeft - 1;
			end if;
		end if;	 
		remKeys <= keysLeft;    							 
	end process;			
end Behavioral;

