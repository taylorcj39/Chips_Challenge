library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chip_dp is
    Port(   dir : in STD_LOGIC_VECTOR(4 downto 0);
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            initChip : in STD_LOGIC;
            currentL : in STD_LOGIC;
            nextL : in STD_LOGIC;
            startValid : in STD_LOGIC;
            validFlag : out STD_LOGIC
         );
end chip_dp;
    
architecture Behavioral of chip_dp is
    component test_map_ram IS
  PORT (clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
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
                 startValid : in STD_LOGIC;
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
    RAM1 : test_map_ram port map(
        clka => clk,
         clkb => clk, 
         wea(0) => weA, 
         web(0) => weB, 
         addra => addra, 
         addrb => addrb, 
         dina => dA,
         dinb => dB,
         douta => qA,
         doutb => qB
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
        startValid => startValid,
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
