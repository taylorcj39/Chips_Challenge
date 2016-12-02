-- Example 37a: vga_bsprite
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_cc is
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
end vga_cc;

architecture vga_cc of vga_cc is 
constant hbp: std_logic_vector(9 downto 0) := "0010010000";	 
	--Horizontal back porch = 144 (128+16)
constant vbp: std_logic_vector(9 downto 0) := "0000011111";	 
	--Vertical back porch = 31 (2+29)
constant w: integer := 480;
constant h: integer := 480;
signal boardxpix, boardypix: std_logic_vector(9 downto 0);					
signal rom_addr : std_logic_vector(16 downto 0);					
signal spriteonboard,spriteonscore, R, G, B: std_logic;
signal M : STD_LOGIC_VECTOR(7 downto 0);
--signal Mempty : STD_LOGIC_VECTOR(7 downto 0) := "11111111";
--signal Mwall : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
--signal Mchip : STD_LOGIC_VECTOR(7 downto 0) := "00011100";
--signal Mblock : STD_LOGIC_VECTOR(7 downto 0) := "11100000";
--signal Mwater : STD_LOGIC_VECTOR(7 downto 0) := "00000011";
--signal Mdrown : STD_LOGIC_VECTOR(7 downto 0) := "00011111";
--signal Mkey : STD_LOGIC_VECTOR(7 downto 0) := "11111100";
--signal Mgate : STD_LOGIC_VECTOR(7 downto 0) := "11100011";
--signal Mwin : STD_LOGIC_VECTOR(7 downto 0) := "11101100";
begin
	boardypix <= vc - vbp;
	boardxpix <= hc - hbp;
--	scorexpix <= hc - hbp - w;
--	scoreypix <= hc - vbp - h;
	--Enable sprite video out when within the sprite region
 	spriteonboard <= '1' when (((hc >= hbp) and (hc < hbp + w))
                and ((vc >= vbp) and (vc < vbp + h))) else '0';	
--    spriteonscore <= '1' when ((hc >= hbp + w) and (hc < hbp + w + 160))
--                and ((vc >= vbp + h) and (vc < vbp + h)) else '0';
--	process(scorexpix, scoreypix)
--	variable  rom_addr1, rom_addr2: STD_LOGIC_VECTOR (16 downto 0);
--	begin 
--		rom_addr1 := (ypix & "0000000") + ('0' & ypix & "000000") + ("00" & ypix & "00000") + ("000" & ypix & "0000");	-- y*(128+64+32+16) = y*240
--		rom_addr2 := rom_addr1 + ("00000000" & xpix);	-- y*240+x
--		rom_addr16 <= rom_addr2(15 downto 0);
--	end process;
    process(boardypix,boardxpix)
        variable rom_addr1, rom_addr2: STD_LOGIC_VECTOR(9 downto 0);
        begin 
                    rom_addr1 := (boardypix(4 downto 0) & "00000");
                    rom_addr2 := rom_addr1 + ("00000" & boardxpix(4 downto 0)); -- y*100+x
                    rom_addrempty <= rom_addr2(9 downto 0);
    end process;
    process(boardypix,boardxpix)
       
        variable ygridi,xgrid: STD_LOGIC_VECTOR(4 downto 0);
        variable ygrid: STD_LOGIC_VECTOR(7 downto 0);
        begin
        ygridi := boardypix(9 downto 5);
        ygrid := (ygridi & "000") + ("0" & ygridi & "00") + ("00" & ygridi & "0") + ygridi; 
        xgrid := boardxpix(9 downto 5);
        addrgrid <= ygrid + xgrid;
        end process;
    process(Value, Mempty,Mwall,Mchip,Mblock,Mwater,Mdrown,Mkey,Mgate,Mwin)
            begin
                if Value = "0000" then
                    M <= Mempty;
                elsif Value = "0001" then
                    M <= Mwall;
                elsif Value = "0010" then
                    M <= Mchip;
                elsif Value = "0011" then
                    M <= Mblock;
                elsif Value = "0100" then
                    M <= Mwater;
                elsif Value = "0101" then
                    M <= Mdrown;
                elsif Value = "0110" then
                    M <= Mkey;
                elsif Value = "0111" then
                    M <= Mgate;    
                elsif Value = "1000" then
                    M <= Mwin;  
                end if;    
            end process;
	process(spriteonboard, vidon, M)
  		variable j: integer;
 	begin
		red <= "000";
		green <= "000";
		blue <= "00";
		if spriteonboard = '1' and vidon = '1' then
    			red <= M(7 downto 5);
    			green <= M(4 downto 2);
    			blue <= M(1 downto 0);
		end if;
  	end process; 
					
end vga_cc;
