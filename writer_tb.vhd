
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity writer_tb is
end writer_tb;

architecture Behavioral of writer_tb is
    component writer is
    Port ( wChipLoc, wNextLoc, wNextnextLoc : in STD_LOGIC;
               chipLoc, nextLoc, nextnextLoc: in STD_LOGIC_VECTOr(7 downto 0);
               wEmpty, wChip, wBrick, wDrown : in STD_LOGIC;
               addr : out STD_LOGIC_VECTOR(7 downto 0);
               data : out STD_LOGIC_VECTOR(3 downto 0);
               we : out STD_LOGIC);
    end component;

signal chipLoc: STD_LOGIC_VECTOR(7 downto 0) := X"01";
signal nextLoc: STD_LOGIC_VECTOR(7 downto 0) := X"02";
signal nextnextLoc: STD_LOGIC_VECTOR(7 downto 0) := X"03";

signal wChipLoc, wNextLoc, wNextnextLoc : STD_LOGIC := '0';
signal wEmpty, wChip, wBrick, wDrown : STD_LOGIC := '0';

signal addr : STD_LOGIC_VECTOR(7 downto 0);
signal data : STD_LOGIC_VECTOR(3 downto 0);
signal we : STD_LOGIC;

begin

uut : writer port map (
        data => data,
        we => we,
        addr => addr,
        wChipLoc => wChipLoc,
        wNextLoc => wNextLoc,
        wNextnextLoc => wNextnextLoc,
        wEmpty => wEmpty,
        wChip => wChip,
        wBrick => wBrick,
        wDrown => wDrown,
        chipLoc => chipLoc,
        nextLoc => nextLoc,
        nextnextLoc => nextnextLoc
);

    stim_proc: process
    begin
        wait for 10ns;
        wChipLoc <= '1';
        wEmpty <= '1';
        wait for 10ns;
        wChipLoc <= '0';
        wEmpty <= '0';
        wait for 10ns;
        
        wNextLoc <= '1';
        wBrick <= '1';
        wait for 10ns;
        wNextloc <= '0';
        wBrick <= '0';
        wait for 10ns;
        
        wNextLoc <= '1';
        wChip <= '1';
        wait for 10ns;
        wNextLoc <= '0';
        wChip <= '0';
        wait for 10ns;
        
        wNextnextLoc <= '1';
        wDrown <= '1';
        wait for 10ns;
        wNextnextLoc <= '0';
        wDrown <= '0';
        wait for 10ns;
    wait;            
    end process;
end Behavioral;
