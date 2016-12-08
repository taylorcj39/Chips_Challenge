
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity move_ctrl_tb is
end move_ctrl_tb;

architecture Behavioral of move_ctrl_tb is
    component move_ctrl is
    Port (  clr, clk : in STD_LOGIC;
            chipLoc : in STD_LOGIC_VECTOR(7 downto 0);
            input : in STD_LOGIC_VECTOR(7 downto 0);
            nextLoc : out STD_LOGIC_VECTOR(7 downto 0);
            nextnextLoc : out STD_LOGIC_VECTOR(7 downto 0)
            );
    end component;

signal chipLoc : STD_LOGIC_VECTOR(7 downto 0) := X"A5";
signal input : STD_LOGIC_VECTOR(7 downto 0) := X"00";
signal clr,clk : STD_LOGIC := '1';

signal nextLoc : STD_LOGIC_VECTOR(7 downto 0);
signal nextnextLoc : STD_LOGIC_VECTOR(7 downto 0);

begin

    clk <= not clk after 5ns;
    
uut : move_ctrl port map (
        clk => clk,
        chipLoc => chipLoc,
        input => input,
        nextLoc => nextLoc,
        clr => clr,
        nextnextLoc => nextnextLoc
);

    stim_proc: process
    variable i : integer; 
    begin
        wait for 10ns;
        clr <= '0';
        wait for 10ns;

        for i in 0 to 3 loop
            input(i) <= '1';
            wait for 20ns;
            input <= X"00";
            wait for 20ns;  
        end loop;
    wait;
    end process;
end Behavioral;
