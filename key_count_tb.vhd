
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity key_count_tb is
end key_count_tb;

architecture Behavioral of key_count_tb is
    component key_counter is
    Port ( keyPlus : in STD_LOGIC;
           keyStart : in STD_LOGIC_VECTOR(2 downto 0);
           clk, clr : in STD_LOGIC;
           remKeys : out STD_LOGIC_VECTOR(2 downto 0));
    end component;

signal keyPlus : STD_LOGIC := '0';
signal clk, clr : STD_LOGIC := '1';
signal keyStart : STD_LOGIC_VECTOR(2 downto 0) := "111";

signal remKeys : STD_LOGIC_VECTOR(2 downto 0);


begin

clk <= not clk after 5 ns;

uut : key_counter port map (
        keyPlus => keyPlus,
        keyStart => keyStart,
        clr => clr,
        clk => clk,
        remKeys => remKeys
);

    stim_proc: process
    begin
        wait for 5ns;
        clr <= '0';
        wait for 10ns;
        
        keyPlus <= '1';
        wait for 5ns;
        keyPlus <= '0';
        wait for 20ns;
        
        keyPlus <= '1';
        wait for 10ns;
        keyPlus <= '0';
        wait for 10ns;
        
        keyPlus <= '1';
        wait for 5ns;
        keyPlus <= '0';
        wait for 5ns;
        
        clr <= '1';
        wait for 5ns;
        clr <= '0';
        wait for 10ns;
        
        keyPlus <= '1';
        wait for 5ns;
        keyPlus <= '0';
        wait for 5ns;

wait;
end process;
end Behavioral;
