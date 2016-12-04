
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game_machine is
Port (  input : in STD_LOGIC_VECTOR(7 downto 0);    --Inputs from buttons
        ready : in STD_LOGIC;
        clk, clr : in STD_LOGIC;      
        q : in STD_LOGIC_VECTOR(3 downto 0);        --Data from the RAM
        addr : out STD_LOGIC_VECTOR(7 downto 0);    --Address in RAM to be looked at
        d : out STD_LOGIC_VECTOR(3 downto 0);       --Data begin written to RAM
        we : out STD_LOGIC;                         --Enables writing to RAM
        remKeys : out STD_LOGIC_VECTOR(2 downto 0)  --Output of remaining keys
     );
end game_machine;

architecture Behavioral of game_machine is

--Component Definitions----------------------------------------------------------------

--Datapath component for game logic--------------------------------------------------------
component board_dp
    Port(   clk, clr : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(7 downto 0);                    --Inputs from buttons
            lookChip, lookNext, lookNextnext : in STD_LOGIC;            --Which location will be looked at by looker component
            wChipLoc, wNextLoc, wNextnextLoc : in STD_LOGIC;            --Which location will be written by writer
            wEmpty, wChip, wBlock, wDrown : in STD_LOGIC;               --Which object will be written to RAM                        
            validatorOn, keyPlus, sInitial : in STD_LOGIC;              --Enable for validator component, key counter flag, load for setting chip's initial location
            chipL, nextL, nextnextL : in STD_LOGIC;                     --Load signals for registers holding board locations
            q : in STD_LOGIC_VECTOR(3 downto 0);                        --Data being read from RAM
            winF, gateF, blockF, emptyF, keyF, waterF, wallF, btnF, gotKeys : out STD_LOGIC;    --Flags depending on what object is present at current location
            we : out STD_LOGIC;                                         --Address in RAM to be looked at 
            d : out STD_LOGIC_VECTOR(3 downto 0);                       --Data begin written to RAM      
            addr : out STD_LOGIC_VECTOR(7 downto 0);                    --Enables writing to RAM         
            remKeys : out STD_LOGIC_VECTOR(2 downto 0)                  --Outputs remaining number of keys       
        );
end component;

--Statemachine which handles control flow of game logic----------------------------------------
component board_ctrl
     Port ( winF, gateF, blockF, emptyF, keyF, waterF, wallF, btnF, gotKeys : in STD_LOGIC; --Flags depending on what object is present at current location
            clk, clr : in STD_LOGIC;
            ready : in STD_LOGIC;                                       --Wait flag for when RAM is being rewritten
            lookChip, lookNext, lookNextnext : out STD_LOGIC;           --Which location will be looked at by looker component
            wChipLoc, wNextLoc, wNextnextLoc : out STD_LOGIC;           --Which location will be written by writer
            wEmpty, wChip, wBlock, wDrown : out STD_LOGIC;              --Which object will be written to RAM    
            validatorOn, keyPlus, sInitial : out STD_LOGIC;             --Enable for validator component, key counter flag, load for setting chip's initial location
            chipL, nextL, nextnextL : out STD_LOGIC                     --Load signals for registers holding board locations
   );
end component;

--signal assignments
signal winF, gateF, blockF, emptyF, keyF, waterF, wallF, btnF, gotKeys : STD_LOGIC; --Flags depending on what object is present at current location
signal lookChip, lookNext, lookNextnext : STD_LOGIC;                                --Which location will be looked at by looker component
signal wChipLoc, wNextLoc, wNextnextLoc : STD_LOGIC;                                --Which location will be written by writer
signal wEmpty, wChip, wBlock, wDrown : STD_LOGIC;                                   --Which object will be written to RAM
signal validatorOn, keyPlus, sInitial : STD_LOGIC;                                  --Enable for validator component, key counter flag, load for setting chip's initial location
signal chipL, nextL, nextnextL : STD_LOGIC;                                         --Load signals for registers holding board locations

begin

--Port map-------------------------------------------------------------------------------------------
--Datapath component
DP : board_dp port map(
    clk => clk, clr => clr,
    input => input,
    lookchip => lookChip, lookNext => lookNext, lookNextnext => lookNextnext,
    wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
    wEmpty => wEmpty, wChip => wChip, wBlock => wBlock, wDrown => wDrown,
    validatorOn => validatorOn, keyPlus => keyPlus, sInitial => sInitial,
    chipL => chipL, nextL => nextL, nextnextL => nextnextL,
    q => q,
    winF => winF, gateF => gateF, blockF => blockF, emptyF => emptyF,
    keyF => keyF, waterF => waterF, wallF => wallF, btnF => btnF, gotKeys => gotKeys,
    we => we, d => d, addr => addr, remKeys => remKeys     
);

--State machine component
SM : board_ctrl port map(
    clk => clk, clr => clr, ready => ready,
    lookchip => lookChip, lookNext => lookNext, lookNextnext => lookNextnext,
    wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
    wEmpty => wEmpty, wChip => wChip, wBlock => wBlock, wDrown => wDrown,
    validatorOn => validatorOn, keyPlus => keyPlus, sInitial => sInitial,
    chipL => chipL, nextL => nextL, nextnextL => nextnextL,
    winF => winF, gateF => gateF, blockF => blockF, emptyF => emptyF,
    keyF => keyF, waterF => waterF, wallF => wallF, btnF => btnF, gotKeys => gotKeys   
);
end Behavioral;
