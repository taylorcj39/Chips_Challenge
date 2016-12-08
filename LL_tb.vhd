
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LL_tb is
end LL_tb;

architecture Behavioral of LL_tb is
    component LL_top
        Port ( clk : in STD_LOGIC;
               clr : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR (3 downto 0);
               ready : out STD_LOGIC);
    end component;

    signal clk : STD_LOGIC := '0';
    signal clr : STD_LOGIC := '1';
    signal q : STD_LOGIC_VECTOR(3 downto 0);
    signal ready : STD_LOGIC;


begin

uut : LL_top port map(
    clk => clk,
    clr => clr,
    ready => ready,
    q => q
);

clk <= not clk after 5ns;

    stim_proc : process
    begin
    
    wait for 10ns;
    clr <= '0';
    wait for 1300ns;
    
    wait;
    end process;
end Behavioral;
