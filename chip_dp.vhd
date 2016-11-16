library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chip_dp is
    Port(   dir : in STD_LOGIC_VECTOR(4 downto 0);
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            initChip : in STD_LOGIC;
            currentL : in STD_LOGIC;
            nextL : in STD_LOGIC;
            validFlag : out STD_LOGIC
         );
end chip_dp;
    
architecture Behavioral of chip_dp is
    component dpram
        Port ( addrA : in STD_LOGIC_VECTOR (3 downto 0);
               addrB : in STD_LOGIC_VECTOR (3 downto 0);
               dA : in STD_LOGIC_VECTOR (1 downto 0);
               dB : in STD_LOGIC_VECTOR (1 downto 0);
               weA : in STD_LOGIC;
               weB : in STD_LOGIC;
               qA : out STD_LOGIC_VECTOR (1 downto 0);
               qB : out STD_LOGIC_VECTOR (1 downto 0);
               clk : in STD_LOGIC);    
    end component;
    
    component changer
        generic (N: integer := 8);
        Port    (a_in : in STD_LOGIC_VECTOR(N-1 downto 0);
                 b_in : in STD_LOGIC_VECTOR(N-1 downto 0);
                 sel : in STD_LOGIC;
                 a_out : out STD_LOGIC_VECTOR(N-1 downto 0);
                 b_out : out STD_LOGIC_VECTOR(N-1 downto 0));
    end component;
    
    component move_ctrl
    generic (N: integer := 8);
        Port    (currentP : in STD_LOGIC_VECTOR(N-1 downto 0);
                 dir : in STD_LOGIC_VECTOR(4 downto 0);
                 nextM : out STD_LOGIC_VECTOR(N-1 downto 0));
    end component;
    
    component move_validator is
        generic (N: integer := 8);
        Port    (a : in STD_LOGIC_VECTOR(N-1 downto 0);
                 b : in STD_LOGIC_VECTOR(N-1 downto 0);
                 valid : out STD_LOGIC);
    end component;
    
    component reg
        generic(N:integer := 8);
        port(
            load : in STD_LOGIC;
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR(N-1 downto 0);
            q : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    signal addrA,addrB, nextMove, current : STD_LOGIC_VECTOR(3 downto 0);
    signal qA,qB,dA,dB : STD_LOGIC_VECTOR(1 downto 0);
    signal weA, weB, valid : STD_LOGIC;
    
begin
    validFlag <= valid;
    weA <= valid;
    weB <= valid;
    MUXC : process(initChip,addrB)
    begin
        if initChip = '1' then
            current <= "0110"; --Initializes where chip starts
        else
            current <= addrB;
        end if;
    end process;
    
    --Port Map
    RAM1 : dpram port map(
        addrA => addrA,
        addrB => addrB,
        dA => qA,
        dB => qA,
        weA => weA,
        weB => weB,
        qA => qA,
        qB => qB,
        clk => clk   
    );
    
    CUR : reg generic map(N => 4)port map(
        d => current,
        load => currentL,
        q => addrA,
        clk => clk,
        clr => clr 
    );
    
    NXT : reg generic map(N => 4) port map(
        d => nextMove,
        load => nextL,
        q => addrB,
        clk => clk,
        clr => clr 
    );
    
    MV : move_validator generic map(N => 2) port map(
        a => qA,
        b => qB,
        valid => valid    
    );
    
    MC : move_ctrl generic map(N => 4) port map(
        currentP => addrA,
        nextM => nextMove,
        dir => dir  
    );
    
    CH : changer generic map(N => 2) port map(
        a_in => qA,
        b_in => qB,
        a_out => dA,
        b_out => dB,
        sel => valid
    );
    
end Behavioral;
