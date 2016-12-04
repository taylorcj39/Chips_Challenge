--Assigns Address to be specific value based on input flags
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity looker is
    Port ( chipLoc, nextLoc, nextnextLoc : in STD_LOGIC_VECTOR(7 downto 0); --Corresponds to address help in registers
           lookChip, lookNext, lookNextnext : in STD_LOGIC;                 --Which address will be looked at
           addr : out STD_LOGIC_VECTOR(7 downto 0);                         --Address output to RAM
           clk, clr : in STD_LOGIC);                                             
end looker;

architecture Behavioral of looker is

signal addrSig : STD_LOGIC_VECTOR(7 downto 0);  --Internal signal which output will be latched to
begin
process(clk, clr, lookChip, lookNext, lookNextNext, chipLoc, nextLoc, nextnextLoc)
begin
	if clr = '1' then              --Output and signals will be '0' when clr is high
	   addr <= X"00";
	   addrSig <= X"00";
	elsif clk'event and clk = '1' then
        if lookChip = '1' then      --Output is assigned the address of whatever flag is high
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
    --addr <= addrSig;
end Behavioral;

