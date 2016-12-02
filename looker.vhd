--Is there a latch in here?
--what about condition when 2 drivers are high?
--not clearing properly
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity looker is
    Port ( chipLoc, nextLoc, nextnextLoc : in STD_LOGIC_VECTOR(7 downto 0); --Corresponds to address help in registers
           lookChip, lookNext, lookNextnext : in STD_LOGIC; --Which address will be looked at
           addr : out STD_LOGIC_VECTOR(7 downto 0);
           clr : in STD_LOGIC); --Address output to RAM
end looker;

architecture Behavioral of looker is
signal addrSig : STD_LOGIC_VECTOR(7 downto 0);
begin
process(clr, lookChip, lookNext, lookNextNext, chipLoc, nextLoc, nextnextLoc)
begin
	if clr = '1' then
	   addr <= X"00";
	   addrSig <= X"00";
	else
        if lookChip = '1' then
            addr <= chipLoc;
            addrSig <= chipLoc;
        elsif lookNext = '1' then
            addr <= nextLoc;
            addrSig <= nextLoc;
        elsif lookNextnext = '1' then
            addr <= nextnextLoc;
            addrSig <= nextnextLoc;
        else
            addr <= addrSig;
        end if;
        
    end if;
end process;
end Behavioral;

