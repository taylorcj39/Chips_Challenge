----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2016 01:24:37 AM
-- Design Name: 
-- Module Name: Chiptest_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Chiptest_top is
    Port ( mclk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           red : out STD_LOGIC_VECTOR (2 downto 0);
           green : out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (1 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 15));
end Chiptest_top;

architecture Behavioral of Chiptest_top is
--component ramreader is
--    Port ( Address : out STD_LOGIC_VECTOR (7 downto 0);
--           qB : in STD_LOGIC_VECTOR (3 downto 0);
--           Value : out STD_LOGIC_VECTOR (3 downto 0);
--           mclk : in STD_LOGIC;
--           clr : in STD_LOGIC
--           );
--end component;
component vga_640x480 is
	port (
		clk, clr : in std_logic;
		hsync, vsync : out std_logic;
		hc, vc : out std_logic_vector(9 downto 0);
		vidon : out std_logic
		);
end component;
component Empty_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component Chip_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END component;
--component level1_ram IS
--  PORT (
--    clka : IN STD_LOGIC;
--    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--    clkb : IN STD_LOGIC;
--    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
--  );
--END component;
component vga_cc is
    port ( vidon: in std_logic;
		   hc : in std_logic_vector(9 downto 0);
           vc : in std_logic_vector(9 downto 0);
		 --  Mempty,Mwall,Mchip,Mblock,Mwater,Mdrown,Mkey,Mgate,Mwin: in std_logic_vector(7 downto 0);
		   red : out std_logic_vector(2 downto 0);
           green : out std_logic_vector(2 downto 0);
           blue : out std_logic_vector(1 downto 0);
           Value : in STD_LOGIC_VECTOR(3 downto 0);
           addrgrid : out STD_LOGIC_VECTOR(7 downto 0);
           rom_addrempty : out STD_LOGIC_VECTOR(9 downto 0);
           Mempty, Mchip, Mwall, Mblock, Mwater, Mdrown, Mgate, Mkey, Mwin : in STD_LOGIC_VECTOR(7 downto 0)
	);
end component;
component clkdiv is
	 port(
		 mclk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 clk250 : out STD_LOGIC
	     );
end component;
component Wall_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component Block_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component Water_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component Drown_32x32 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
component Gate_32x32 IS
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END component;
  component Key_32x32 IS
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END component;
  component Win_32x32 IS
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END component;
  component level1test IS
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END component;

  component game_machine is
  Port (  input : in STD_LOGIC_VECTOR(7 downto 0);
          clk, clr : in STD_LOGIC;
          q : in STD_LOGIC_VECTOR(3 downto 0);
          addr : out STD_LOGIC_VECTOR(7 downto 0);
          d : out STD_LOGIC_VECTOR(3 downto 0);
          we : out STD_LOGIC
       );
  end component;
signal addrsig: STD_LOGIC_VECTOR(7 downto 0);
signal doutsig: STD_LOGIC_VECTOR(3 downto 0);
signal valuesig: STD_LOGIC_VECTOR(3 downto 0);
signal hcsig,vcsig: STD_LOGIC_VECTOR(9 downto 0);
signal vidonsig: STD_LOGIC;
signal clksig: STD_LOGIC;
signal emptysig: STD_LOGIC_VECTOR(9 downto 0);
signal Mempty, Mchip, Mwall, Mblock, Mwater, Mdrown, Mgate, Mkey, Mwin: STD_LOGIC_VECTOR(7 downto 0);
signal zerosig1: STD_LOGIC_VECTOR(7 downto 0);
signal zerosig3: STD_LOGIC_VECTOR(0 downto 0);
begin
C1: clkdiv port map (
mclk => mclk,
clr => sw(15),
clk250 => clksig

);
--L1: level1_ram port map(
--    clka => mclk,
--    wea => zerosig3,
--    addra => zerosig1,
--    dina => zerosig1(3 downto 0),
--    douta => open,
--    clkb => clksig,
--    web => zerosig3,
--    addrb => addrsig,
--    dinb => zerosig1(3 downto 0),
--    doutb => doutsig
--    );
l2: level1test port map(
clka => clksig,
addra => addrsig,
douta => valuesig
);
W3: Win_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mwin
    );
K1: Key_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mkey
    );
G1: Gate_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mgate
    );
D1: Drown_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mdrown
    );
W2: Water_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mwater
    );
B2: Block_32x32 port map(
    clka => clksig,
    addra => emptysig,
    douta => Mblock
    );
E1: Empty_32x32 port map (
    clka => clksig, 
    addra => emptysig,
    douta => Mempty
    );
C2: Chip_32x32 port map (
    clka => clksig,
    addra => emptysig,
    douta => Mchip
    );
W1: Wall_32x32 port map(
clka => clksig,
addra => emptysig,
douta => Mwall
);
--R1: ramreader port map (
--Address => addrsig,
--qB => doutsig,
--Value => valuesig,
--mclk => clksig,
--clr => btn(0)
--);
S1: vga_640x480 port map(
clk => clksig,
clr => sw(15),
hsync => hsync,
vsync => vsync,
hc => hcsig,
vc => vcsig,
vidon => vidonsig
);
--b1: blk_mem_gen_0 port map(
--clka => clksig,
--addra => addrsig,
--douta => valuesig
--);
V1: vga_cc port map(
vidon => vidonsig,
hc => hcsig,
vc => vcsig,
red => red,
green => green,
blue => blue,
Value => valuesig,
addrgrid => addrsig,
rom_addrempty => emptysig,
Mempty => Mempty,
Mchip => Mchip,
Mwall => Mwall,
Mblock => Mblock,
Mwater => Mwater,
Mdrown => Mdrown,
Mgate => Mgate,
Mkey => Mkey,
Mwin => Mwin
);
end Behavioral;
