library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demo_top_4x4 is
  Port ( mclk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR(4 downto 0)   
  );
end demo_top_4x4;

architecture Behavioral of demo_top_4x4 is

    component chip_state_ctrl
        port( clk : in STD_LOGIC;
              clr : in STD_LOGIC;
              btnFlag : in STD_LOGIC;
              validFlag : in STD_LOGIC;
              currentL : out STD_LOGIC;
              nextL : out STD_LOGIC;
              initChip : out STD_LOGIC      
        );
    end component;
        
    component chip_dp
        port(   dir : in STD_LOGIC_VECTOR(4 downto 0);
                clk : in STD_LOGIC;
                clr : in STD_LOGIC;
                currentL : in STD_LOGIC;
                nextL : in STD_LOGIC;
                validFlag : out STD_LOGIC;
                initChip : in STD_LOGIC
             );    
    end component;
    
signal btnFlag, validFlag, currentL, nextL, initChip : STD_LOGIC;

begin
btnFlag <= btn(4) or btn(3) or btn(2) or btn(0);

S : chip_state_ctrl
    port map( clk => mclk,
              clr => btn(1),
              btnFlag => btnFlag,
              validFlag => validFlag,
              currentL => currentL,
              nextL => nextL
              );

DP : chip_dp
    port map( clk => mclk,
              clr => btn(1),
              dir => btn(4 downto 0),
              validFlag => validFlag,
              currentL => currentL,
              nextL => nextL,
              initChip => initChip
              );

end Behavioral;
