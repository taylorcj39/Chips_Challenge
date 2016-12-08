
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity validator_tb is
end validator_tb;

architecture Behavioral of validator_tb is
    component validator is
    Port ( data : in STD_LOGIC_VECTOR(3 downto 0);
           go : in STD_LOGIC;
           winF,gateF,blockF,emptyF,wallF,waterF,keyF : out STD_LOGIC);
    end component;

signal go : STD_LOGIC := '0';
signal data : STD_LOGIC_VECTOR(3 downto 0) := "1000"; --set to win initially

signal winF,gateF,blockF,emptyF,wallF,waterF,keyF : STD_LOGIC;

begin

uut : validator port map (
        data => data,
        go => go,
        winF => winF,
        gateF => gateF,
        blockF => blockF,
        emptyF => emptyF,
        wallF => wallF,
        waterF => waterF,
        keyF => keyF
);

    stim_proc: process
    variable i : integer; 
    begin
        wait for 10ns;
        go <= '1';
        wait for 10ns;
        
        for i in 0 to 8 loop
            data <= conv_std_logic_vector(i,4);
            wait for 20ns;  
        end loop;
    wait;
    end process;
end Behavioral;
