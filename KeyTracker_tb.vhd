library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyTracker_tb is
end KeyTracker_tb;

architecture rtl of KeyTracker_tb is 
    component KeyTracker
        port( clr : in STD_LOGIC;
              clk : in STD_LOGIC;
              KeyStart : in STD_LOGIC_VECTOR(2 downto 0);
              KeyPlus : in STD_LOGIC;
              RemKeys : out STD_LOGIC_VECTOR(2 downto 0)
            );
    end component;
    
    --inputs
    signal clr : std_logic;
    signal clk : std_logic := '1';
    signal KeyStart : std_logic_vector(2 downto 0);
    signal KeyPlus : std_logic;
    --outputs
    signal RemKeys : std_logic_vector(2 downto 0);
    
begin
    
    uut : KeyTracker port map(
            clr => clr,
            clk => clk,
            KeyStart => KeyStart,
            KeyPlus => KeyPlus,
            RemKeys => RemKeys
            );
           
        clk <= not clk after 5 ns;
        KeyStart <= "111";

    stim_proc : process
    begin
        KeyPlus <= '0';
        clr <= '1';
        wait for 5 ns;
        clr <= '0';
        wait for 15 ns;
        
        KeyPlus <= '1';
        wait for 40 ns;
        KeyPlus <= '0';
        wait for 40 ns;
        
        KeyPlus <= '1';
        wait for 10 ns;
        KeyPlus <= '0';
        wait for 10 ns;
         
        
    wait;
    end process;
end;