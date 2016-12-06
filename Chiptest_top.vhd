
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
entity Chiptest_top is
    Port ( mclk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           red : out STD_LOGIC_VECTOR (2 downto 0);
           green : out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (1 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 15);
           ld : out STD_LOGIC_VECTOR(15 downto 0)
           );
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
--Debouncer for input
component debounce4 is
    Port ( inp : in STD_LOGIC_VECTOR (7 downto 0);
           cclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           outp : out STD_LOGIC_VECTOR (7 downto 0));
end component;
    --File to help display VGA
component vga_640x480 is
	port (
		clk, clr : in std_logic;
		hsync, vsync : out std_logic;
		hc, vc : out std_logic_vector(9 downto 0);
		vidon : out std_logic
		);
end component;
component lv_loader is
    Port ( clr, clk : in STD_LOGIC;
           q : in STD_LOGIC_VECTOR (3 downto 0);        --Object at current addr position of ROM
           ready : out STD_LOGIC;                       --Flag singifying the level has been loaded to RAM
           we : out STD_LOGIC;                          --Enables writing to RAM only when high
           d : out STD_LOGIC_VECTOR (3 downto 0);       --Object to be written to current location in RAM
           addr : out STD_LOGIC_VECTOR (7 downto 0));   --Current address which will be loaded with object
end component;

--ROM Files
component score_board160x480 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
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
--component blk_mem_gen_0 IS
--  PORT (
--    clka : IN STD_LOGIC;
--    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
--  );
--END component;
    --Level Loaded in
component level1_ram IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END component;
    --VGA File to read the game board from the RAM
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
           Mempty, Mchip, Mwall, Mblock, Mwater, Mdrown, Mgate, Mkey, Mwin, Mscore : in STD_LOGIC_VECTOR(7 downto 0);
           rom_addrscore : out STD_LOGIC_VECTOR(16 downto 0)
	);
end component;
    -- Clk Divider for different speeds
component clkdiv is
	 port(
		 mclk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 clk250 : out STD_LOGIC;
		 clks : out STD_LOGIC
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
--  component level1test IS
--    PORT (
--      clka : IN STD_LOGIC;
--      addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--      douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
--    );
--  END component;
    --Contains the game code to be communicated with the RAM
  component game_machine is
  Port (  input : in STD_LOGIC_VECTOR(7 downto 0);
          clk, clr : in STD_LOGIC;
          q : in STD_LOGIC_VECTOR(3 downto 0);
          addr : out STD_LOGIC_VECTOR(7 downto 0);
          d : out STD_LOGIC_VECTOR(3 downto 0);
          ready : in STD_LOGIC;
          we : out STD_LOGIC
       );
  end component;
  
  component level1_rom
  PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  end component;
  
--Signals for components to communicate
signal addrsig: STD_LOGIC_VECTOR(7 downto 0);
signal doutsig: STD_LOGIC_VECTOR(3 downto 0);
signal valuesig: STD_LOGIC_VECTOR(3 downto 0);
signal hcsig,vcsig: STD_LOGIC_VECTOR(9 downto 0);
signal vidonsig: STD_LOGIC;
signal clksig: STD_LOGIC;
signal emptysig: STD_LOGIC_VECTOR(9 downto 0);
signal Mempty, Mchip, Mwall, Mblock, Mwater, Mdrown, Mgate, Mkey, Mwin, Mscore: STD_LOGIC_VECTOR(7 downto 0);
signal zerosig1: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal debouncesig: STD_LOGIC_VECTOR(7 downto 0);
signal doutasig: STD_LOGIC_VECTOR(3 downto 0);
signal addrasig: STD_LOGIC_VECTOR(7 downto 0);
signal dinasig: STD_LOGIC_VECTOR(3 downto 0);
signal weasig : STD_LOGIC_VECTOR(0 downto 0);
signal inputsignal: STD_LOGIC_VECTOR(7 downto 0);
signal clks: STD_LOGIC;
signal clearsignal: STD_LOGIC;
signal countsignal: STD_LOGIC_VECTOR(7 downto 0);
signal lock: STD_LOGIC;
signal addrscore: STD_LOGIC_VECTOR(16 downto 0);

signal romQ : STD_LOGIC_VECTOR(3 downto 0);
signal loaderD, machineD : STD_LOGIC_VECTOR(3 downto 0);
signal loaderAddr, machineAddr : STD_LOGIC_VECTOR(7 downto 0);
signal ready, weLoad, weGM : STD_LOGIC;
 
--Begin Port Mapping of Components
begin

weasig(0) <= weLoad when ready = '0' else weGM;
dinasig <= loaderD when ready = '0' else machineD;
addrasig <= loaderAddr when ready = '0' else machineAddr;

--Display button presses on LED's
ld(15 downto 8) <= debouncesig;

clearsignal <= sw(15);
C1: clkdiv port map (
mclk => mclk,
clr => clearsignal,
clk250 => clksig,
clks => clks
);
SB: score_board160x480 port map(
    douta => Mscore,
    addra => addrscore,
    clka => clksig
    );
GM: game_machine port map(
    input => debouncesig,
    clk => mclk,
    clr => clearsignal,
    q => doutasig,
    addr => machineAddr,
    d => machineD,
    ready => ready,
    we => weGM
    );

L1 : level1_rom port map (
    clka => mclk,
    addra => loaderAddr,
    douta => romQ
    );
    
LL : lv_loader port map (
    clr => clearsignal,
    clk => mclk,
    q => romQ,
    ready => ready,
    we => weLoad, 
    d => loaderD,
    addr => loaderAddr
    );
        
RAM : level1_ram port map(
    clka => mclk,
    clkb => mclk,
    wea => weasig,
    addra => addrasig,
    dina => dinasig,
    douta => doutasig,
    web => zerosig1(0 downto 0),
    addrb => addrsig,
    dinb => zerosig1(3 downto 0),
    doutb => valuesig
    );
DB: debounce4 port map(
inp => inputsignal,
outp => debouncesig,
cclk => clks,
clr => clearsignal

);
process(clearsignal, mclk)
	begin
		if clearsignal = '1' then 
			countsignal <= X"00";
			lock <= '0';
		elsif mclk'event and mclk = '1' then
		      if debouncesig = "00000000" and lock = '1' then
		          lock <= '0';
		      elsif debouncesig > "00000000" and lock = '0' then
			      countsignal <= countsignal + 1;
			      lock <= '1';
		      end if;
		end if;
	end process;
    ld(7 downto 0) <= countsignal;
    
--    process(clr, clk)
--        begin
--            if clr = '1' then 
--                count <= keyStart; -- set default key number back to count
--                lock <= '0'; --unlock subtractor
--            elsif clk'event and clk = '1' then
--                  if keyPlus = '1' and lock = '0' then
--                     count <= count - 1;
--                     lock <= '1'; -- lock subtractor
--                  elsif keyPlus = '0' and lock = '1' then
--                     lock <= '0'; -- unlock subtractor
--                  end if;
--            end if;
--        end process;
        
--        remKeys <= count;
--Helps drive the buttons (Substitute for Controller)
inputsignal <= "0000" & btn(3) & btn(4) & btn(0) & btn(2);
--l2: level1test port map(
--clka => clksig,
--addra => addrsig,
--douta => valuesig
--);
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
clr => clearsignal,
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
Mwin => Mwin,
Mscore => Mscore,
rom_addrscore => addrscore

);
end Behavioral;
