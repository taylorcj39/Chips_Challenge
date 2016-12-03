--Loads the level from a ROM to the RAM when clr goes high
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lv_loader is
    Port ( clr : in STD_LOGIC;
           q : in STD_LOGIC_VECTOR (7 downto 0);        --Object at current addr position of ROM
           ready : out STD_LOGIC;                       --Flag singifying the level has been loaded to RAM
           we : out STD_LOGIC;                          --Enables writing to RAM only when high
           d : out STD_LOGIC_VECTOR (3 downto 0);       --Object to be written to current location in RAM
           addr : out STD_LOGIC_VECTOR (7 downto 0));   --Current address which will be loaded with object
end lv_loader;

architecture Behavioral of lv_loader is

begin


end Behavioral;
