
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity board_dp is
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
            remKeys : out STD_LOGIC_VECTOR(2 downto 0)                  --Number of remainging keys to be displayed        
        );
end board_dp;

architecture Behavioral of board_dp is
--Component Declerations-----------------------------------------------------------    
    
    --Register Component
    component reg is
        generic(N:integer := 8);
        port(
            load : in STD_LOGIC;
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR(N-1 downto 0);
            q : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    --Movement controller component    
    component move_ctrl is
        Port (  clr,clk : in STD_LOGIC;
                chipLoc : in STD_LOGIC_VECTOR(7 downto 0);
                input : in STD_LOGIC_VECTOR(7 downto 0);
                nextLoc : out STD_LOGIC_VECTOR(7 downto 0);
                nextnextLoc : out STD_LOGIC_VECTOR(7 downto 0)
              );
    end component;

    --Key counter component    
    component key_counter
        port( clr : in STD_LOGIC;
              clk : in STD_LOGIC;
              keyStart : in STD_LOGIC_VECTOR(2 downto 0);
              keyPlus : in STD_LOGIC;
              remKeys : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    --Looker Component    
    component looker is
    Port ( chipLoc, nextLoc, nextnextLoc : in STD_LOGIC_VECTOR(7 downto 0); --Corresponds to address help in registers
           lookChip, lookNext, lookNextnext : in STD_LOGIC;                 --Which address will be looked at
           addr : out STD_LOGIC_VECTOR(7 downto 0);                         --Address output to RAM
           clr,clk : in STD_LOGIC); 
    end component;

    --Component which tells what object is at current location
    component validator is
    Port ( data : in STD_LOGIC_VECTOR(3 downto 0);
           go : in STD_LOGIC;
           winF,gateF,blockF,emptyF,wallF,waterF,keyF : out STD_LOGIC);
    end component;

    --Data writer component    
    component writer is
    Port ( wChipLoc,wNextLoc,wNextnextLoc : in STD_LOGIC;
           chipLoc, nextLoc, nextnextLoc: in STD_LOGIC_VECTOR(7 downto 0);
           wEmpty, wChip, wBlock, wDrown : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR(7 downto 0);
           data : out STD_LOGIC_VECTOR(3 downto 0);
           we : out STD_LOGIC);
    end component;
    
    --Intermediate signal assignments
    signal chipLocD, nextLocD, nextnextLocD : STD_LOGIC_VECTOR(7 downto 0); --inputs of address holding regs
    signal chipLocQ, nextLocQ, nextnextLocQ : STD_LOGIC_VECTOR(7 downto 0); --outputs of address holding regs
    signal writerAddr, lookerAddr : STD_LOGIC_VECTOR(7 downto 0);           --Adresses to be MUXed which will be sent to RAM
    signal sAddr, weSig : STD_LOGIC;                                        --select signals for internal Mux processes
    signal remKeySig : STD_LOGIC_VECTOR(2 downto 0);                --Starting number of keys, remaining number of keys
    signal addrSig : STD_LOGIC_VECTOR(7 downto 0);
    begin
    
    --signal assignments
    gotKeys <= '1' when remKeySig = "000" else '0';       --flag for when all keys have been collected
    sAddr <= weSig;                                     --Ties the select line of the MUX for writing addresses to we
    addrSig <= lookerAddr when sAddr = '0' else writerAddr;--MUX for address to be written to  
    chipLocD <= X"70" when sInitial = '1' else nextLocQ;--Assigning initial location to be loaded to chip register
    btnF <= '0' when input = X"0" else '1';             --Flag showing when a button has been pressed
    we <= weSig;
    remkeys <= remKeySig;
    addr <= addrSig;
--Port Map---------------------------------------------------------------------------------------------
    
    --Register holding chips location
    CHIPR : reg generic map(N=>8) port map (
        clk => clk,
        clr => clr,
        load => chipL,
        d => chipLocD,
        q => chipLocQ
    ); 
    
    --Register holding next location
    NEXTR : reg generic map(N=>8) port map (
        clk => clk,
        clr => clr,
        load => nextL,
        d => nextLocD,
        q => nextLocQ
    );
    
    --Register holding nextnext location
    NNR : reg generic map(N=>8) port map (
        clk => clk,
        clr => clr,
        load => nextnextL,
        d => nextnextLocD,
        q => nextnextLocQ
     );
     
     MOVER : move_ctrl port map (
        clk => clk,
        clr => clr,
        input => input,
        chipLoc=> chipLocQ,
        nextLoc => nextLocD,
        nextnextLoc => nextnextLocD 
     );
     
     W : writer port map (
        wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
        chipLoc => chipLocQ, nextLoc => nextLocQ, nextnextLoc => nextnextLocQ,
        wEmpty => wEmpty, wChip => wChip, wBlock => wBlock, wDrown => wDrown,
        addr => writerAddr,
        data => d,
        we => weSig 
     );
    
    V : validator port map (
        data => q,
        go => validatorOn,
        winF => winF, gateF => gateF, blockF => blockF,
        emptyF => emptyF, wallF => wallF, waterF => waterF, keyF => keyF  
     );
    
    L : looker port map (
        clk => clk,
        clr => clr,
        chipLoc => chipLocQ,
        nextLoc => nextLocQ,
        nextnextLoc => nextnextLocQ,
        lookChip => lookChip,
        lookNext => lookNext,
        lookNextnext => lookNextnext,
        addr => lookerAddr
    );

    KC : key_counter port map (
        clr => clr,
        clk => clk,
        keyStart => "111",
        keyPLus => keyPlus,
        remKeys => remKeySig    
    );
    
end Behavioral;
