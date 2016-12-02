
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game_machine is
Port (  input : in STD_LOGIC_VECTOR(7 downto 0);
        clk, clr : in STD_LOGIC;
        q : in STD_LOGIC_VECTOR(3 downto 0);
        addr : out STD_LOGIC_VECTOR(7 downto 0);
        d : out STD_LOGIC_VECTOR(3 downto 0);
        we : out STD_LOGIC
     );
end game_machine;

architecture Behavioral of game_machine is

component board_dp
    Port(   clk, clr : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(7 downto 0);
            lookChip, lookNext, lookNextnext : in STD_LOGIC;
            wChipLoc, wNextLoc, wNextnextLoc : in STD_LOGIC;
            wEmpty, wChip, wBrick, wDrown : in STD_LOGIC;
            validatorOn, keyPlus, sInitial : in STD_LOGIC;
            chipL, nextL, nextnextL : in STD_LOGIC;
            qA : in STD_LOGIC_VECTOR(3 downto 0);
            winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF, gotKeys : out STD_LOGIC;
            weA : out STD_LOGIC;
            dA : out STD_LOGIC_VECTOR(3 downto 0);
            addrA : out STD_LOGIC_VECTOR(7 downto 0)
        );
end component;

component board_ctrl
     Port ( winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF, gotKeys : in STD_LOGIC;
            clk, clr : in STD_LOGIC;
            lookChip, lookNext, lookNextnext : out STD_LOGIC;
            wChipLoc, wNextLoc, wNextnextLoc : out STD_LOGIC;
            wEmpty, wChip, wBrick, wDrown : out STD_LOGIC;
            validatorOn, keyPlus, sInitial : out STD_LOGIC;
            chipL, nextL, nextnextL : out STD_LOGIC
   );
end component;

--signal assignments
signal winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF, gotKeys : STD_LOGIC;
signal lookChip, lookNext, lookNextnext : STD_LOGIC;
signal wChipLoc, wNextLoc, wNextnextLoc : STD_LOGIC;
signal wEmpty, wChip, wBrick, wDrown : STD_LOGIC;
signal validatorOn, keyPlus, sInitial : STD_LOGIC;
signal chipL, nextL, nextnextL : STD_LOGIC;

begin

--Port map
DP : board_dp port map(
    clk => clk, clr => clr,
    input => input,
    lookchip => lookChip, lookNext => lookNext, lookNextnext => lookNextnext,
    wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
    wEmpty => wEmpty, wChip => wChip, wBrick => wBrick, wDrown => wDrown,
    validatorOn => validatorOn, keyPlus => keyPlus, sInitial => sInitial,
    chipL => chipL, nextL => nextL, nextnextL => nextnextL,
    qA => q,
    winF => winF, gateF => gateF, brickF => brickF, emptyF => emptyF,
    keyF => keyF, waterF => waterF, wallF => wallF, btnF => btnF, gotKeys => gotKeys,
    weA => we, dA => d, addrA => addr     
);

SM : board_ctrl port map(
    clk => clk, clr => clr,
    lookchip => lookChip, lookNext => lookNext, lookNextnext => lookNextnext,
    wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
    wEmpty => wEmpty, wChip => wChip, wBrick => wBrick, wDrown => wDrown,
    validatorOn => validatorOn, keyPlus => keyPlus, sInitial => sInitial,
    chipL => chipL, nextL => nextL, nextnextL => nextnextL,
    winF => winF, gateF => gateF, brickF => brickF, emptyF => emptyF,
    keyF => keyF, waterF => waterF, wallF => wallF, btnF => btnF, gotKeys => gotKeys   
);
end Behavioral;
