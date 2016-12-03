
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity machine_top is
    Port (  clk, clr : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(7 downto 0)
    );
end machine_top;

architecture Behavioral of machine_top is

--Component Declerations-----------------------------------------
--Game Machine component
component game_machine is
    Port (  input : in STD_LOGIC_VECTOR(7 downto 0);
            clk, clr : in STD_LOGIC;
            q : in STD_LOGIC_VECTOR(3 downto 0);
            addr : out STD_LOGIC_VECTOR(7 downto 0);
            d : out STD_LOGIC_VECTOR(3 downto 0);
            we : out STD_LOGIC
     );
end component;


component level1_ram is
    PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
end component;

component clk_div is
Port ( mclk : in STD_LOGIC;
       clr : in STD_LOGIC;
       clk13M : out STD_LOGIC
     );
end component;

--signals
signal addr : STD_LOGIC_VECTOR(7 downto 0);
signal d, q : STD_LOGIC_VECTOR(3 downto 0);
signal we : STD_LOGIC_VECTOR(0 downto 0);
signal clk13M : STD_LOGIC;

begin

--Port Map
RAM : level1_ram port map (
    clka => clk,
    wea => we,
    addra => addr,
    dina => d,
    douta => q
);
    
MCHN : game_machine port map (
    input => input,
    clk => clk13M,
    clr => clr,
    q => q,
    addr => addr,
    d => d,
    we => we(0)    
);

CD : clk_div port map (
    mclk => clk,
    clr => clr,
    clk13M => clk13M
);

end Behavioral;
