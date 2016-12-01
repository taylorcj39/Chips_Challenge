
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity board_dp is
    Port(   clk, clr : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(7 downto 0);
            lookChip, lookNext, lookNextnext : in STD_LOGIC;
            wChipLoc, wNextLoc, wNextnextLoc : in STD_LOGIC;
            wEmpty, wChip, wBrick, wDrown : in STD_LOGIC;
            validatorOn, keyPlus, loadInitial : in STD_LOGIC;
            chipL, nextL, nextnextL : in STD_LOGIC;
            qA : in STD_LOGIC_VECTOR(3 downto 0);
            winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF, gotKeys : out STD_LOGIC;
            weA : out STD_LOGIC;
            dA : out STD_LOGIC_VECTOR(3 downto 0);
            addrA : out STD_LOGIC_VECTOR(7 downto 0)
        );
end board_dp;

architecture Behavioral of board_dp is
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
    
    component move_ctrl is
        Port    (chipLoc : in STD_LOGIC_VECTOR(7 downto 0);
                 input : in STD_LOGIC_VECTOR(7 downto 0);
                 nextLoc : out STD_LOGIC_VECTOR(7 downto 0);
                 nextnextLoc : out STD_LOGIC_VECTOR(7 downto 0)
                 );
    end component;
    
    component looker is
    Port ( chipLoc, nextLoc, nextnextLoc : in STD_LOGIC_VECTOR(7 downto 0); --Corresponds to address help in registers
               lookChip, lookNext, lookNextnext : in STD_LOGIC; --Which address will be looked at
               addr : out STD_LOGIC_VECTOR(7 downto 0);
               clr : in STD_LOGIC); --Address output to RAM
    end component;

    component validator is
    Port ( data : in STD_LOGIC_VECTOR(3 downto 0);
           go : in STD_LOGIC;
           winF,gateF,brickF,emptyF,wallF,waterF,keyF : out STD_LOGIC);
    end component;
    
    component writer is
    Port ( wChipLoc,wNextLoc,wNextnextLoc : in STD_LOGIC;
           chipLoc, nextLoc, nextnextLoc: in STD_LOGIC_VECTOR(7 downto 0);
           wEmpty, wChip, wBrick, wDrown : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR(7 downto 0);
           data : out STD_LOGIC_VECTOR(3 downto 0);
           we : out STD_LOGIC);
    end component;
    
    --Key counter component
    --component key_counter is
    
    --end component;
    
    --Intermediate signal assignments
    signal chipLocD, nextLocD, nextnextLocD : STD_LOGIC_VECTOR(7 downto 0); --inputs of address holding regs
    signal chipLocQ, nextLocQ, nextnextLocQ : STD_LOGIC_VECTOR(7 downto 0); --outputs of address holding regs
    signal writerAddr, lookerAddr : STD_LOGIC_VECTOR(7 downto 0);
    signal sAddr, sInitial, we : STD_LOGIC; --select signals for internal Mux processes
    signal keyStart, remKeys : STD_LOGIC_VECTOR(2 downto 0);
    
    begin
    --signal assignments
    gotKeys <= '1' when remKeys = "000" else '0';
    --sAddr <= weA;
    addrA <= lookerAddr when sAddr = '1' else writerAddr; 
    chipLocD <= X"CC" when sInitial = '1' else nextLocQ;
    weA <= we;
    
    --Port Map
    CHIPR : reg generic map(N=>32) port map (
        clk => clk,
        clr => clr,
        load => chipL,
        d => chipLocD,
        q => chipLocQ
    ); 
    
    NEXTR : reg generic map(N=>32) port map (
        clk => clk,
        clr => clr,
        load => nextL,
        d => nextLocD,
        q => nextLocQ
    );
    
    NNR : reg generic map(N=>32) port map (
        clk => clk,
        clr => clr,
        load => nextnextL,
        d => nextnextLocD,
        q => nextnextLocQ
     );
     
     MOVER : move_ctrl port map (
        input => input,
        chipLoc=> chipLocQ,
        nextLoc => nextLocD,
        nextnextLoc => nextLocD 
     );
     
     W : writer port map (
        wChipLoc => wChipLoc, wNextLoc => wNextLoc, wNextnextLoc => wNextnextLoc,
        chipLoc => chipLocQ, nextLoc => nextLocQ, nextnextLoc => nextnextLocQ,
        wEmpty => wEmpty, wChip => wChip, wBrick => wBrick, wDrown => wDrown,
        addr => writerAddr,
        data => dA,
        we => we 
     );
     
    V : validator port map (
        data => qA,
        go => validatorOn,
        winF => winF, gateF => gateF, brickF => brickF,
        emptyF => emptyF, wallF => wallF, waterF => waterF, keyF => keyF  
     );
    
    L : looker port map (
        clr => clr,
        chipLoc => chipLocQ,
        nextLoc => nextLocQ,
        nextnextLoc => nextnextLocQ,
        lookChip => lookChip,
        lookNext => lookNext,
        lookNextnext => lookNextnext,
        addr => lookerAddr
    );

end Behavioral;
