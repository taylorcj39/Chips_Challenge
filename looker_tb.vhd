
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity looker_tb is
end looker_tb;

architecture Behavioral of looker_tb is
    component looker is
    Port ( chipLoc, nextLoc, nextnextLoc : in STD_LOGIC_VECTOR(7 downto 0); --Corresponds to address help in registers
               lookChip, lookNext, lookNextnext : in STD_LOGIC; --Which address will be looked at
               addr : out STD_LOGIC_VECTOR(7 downto 0);
               clr, clk : in STD_LOGIC); --Address output to RAM
    end component;

signal chipLoc : STD_LOGIC_VECTOR(7 downto 0) := X"01";
signal nextLoc : STD_LOGIC_VECTOR(7 downto 0) := X"02";
signal nextnextLoc : STD_LOGIC_VECTOR(7 downto 0) := X"03";

signal clk, clr : STD_LOGIC := '1';
signal lookChip,lookNext,lookNextnext : STD_LOGIC := '0';
signal addr : STD_LOGIC_VECTOR(7 downto 0);

begin

    clk <= not clk after 5 ns;
    
uut : looker port map (
        chipLoc => chipLoc,
        nextLoc => nextLoc,
        nextnextLoc => nextnextLoc,
        lookChip => lookChip,
        lookNext => lookNext,
        lookNextnext => lookNextnext,
        clr => clr,
        clk => clk,
        addr => addr
);

    stim_proc: process
    begin
        wait for 5ns;
        clr <= '0';
        wait for 10ns;
        
        lookChip <= '1';
        wait for 5ns;
        lookChip <= '0';
        wait for 20ns;
        
        lookNext <= '1';
        wait for 10ns;
        lookNext <= '0';
        wait for 10ns;
        
        lookNextnext <= '1';
        wait for 5ns;
        lookNextNext <= '0';
        wait for 5ns;
        
         clr <= '1';
         wait for 5ns;
         clr <= '0';
         wait for 20ns;
         
         lookNextnext <= '1';
         wait for 5ns;
         lookNextNext <= '0';
         wait for 5ns;
wait;
end process;
end Behavioral;
