--Loads the level from a ROM to the RAM when clr goes high
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lv_loader is
    Port ( clr, clk : in STD_LOGIC;
           q : in STD_LOGIC_VECTOR (3 downto 0);        --Object at current addr position of ROM
           ready : out STD_LOGIC;                       --Flag singifying the level has been loaded to RAM
           we : out STD_LOGIC;                          --Enables writing to RAM only when high
           d : out STD_LOGIC_VECTOR (3 downto 0);       --Object to be written to current location in RAM
           addr : out STD_LOGIC_VECTOR (7 downto 0));   --Current address which will be loaded with object
end lv_loader;

architecture Behavioral of lv_loader is
    --Component Declerations
    component loader_dp
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           countPlus : in STD_LOGIC;                    --Input to counter to increment count
           lastF : out STD_LOGIC;                       --Signifies when the last address has been reached
           count : out STD_LOGIC_VECTOR(7 downto 0));    --Which address will be written
    end component;
    
    component loader_ctrl
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           lastF : in STD_LOGIC;        --Input signifying when the last address has been reached
           countPlus : out STD_LOGIC;   --Output to counter to increment count
           readyF : out STD_LOGIC);     --Output signifying all data has been written
    end component;
    
    --Signal Declerations
    signal lastF, readyF, countPlus : STD_LOGIC;
    signal count : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    --Signal assignments
    we <= '1' when readyF = '0' else '0';       --Loader will always write as long as ready flag = '0'
    d <= q;                                     --Data read in from ROM will always be passed to input of RAM
    addr <= count when count < 225 else X"00";  --Assign address to count excluding count = 225
    ready <= readyF;
    
    --Port map of subcomponents
    DP : loader_dp port map (
        clk => clk,
        clr => clr,
        countPlus => countPlus,
        lastF => lastF,
        count => count
    );
    
    CTRL : loader_ctrl port map (
        clk => clk,
        clr => clr,
        countPlus => countPlus,
        lastF => lastF,
        readyF => readyF
    );


end Behavioral;
