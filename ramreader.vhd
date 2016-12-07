
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
entity ramreader is
    Port ( Address : out STD_LOGIC_VECTOR (7 downto 0);
           qB : in STD_LOGIC_VECTOR (3 downto 0);
           Value : out STD_LOGIC_VECTOR (3 downto 0);
           mclk : in STD_LOGIC;
           clr : in STD_LOGIC
           );
           
end ramreader;

architecture Behavioral of ramreader is
signal countto16: STD_LOGIC_VECTOR(4 downto 0);
signal countto30a: STD_LOGIC_VECTOR(5 downto 0);
signal countto30b: STD_LOGIC_VECTOR(5 downto 0);
signal addressfinal: STD_LOGIC_VECTOR(8 downto 0);
signal addressy: STD_LOGIC_VECTOR(8 downto 0);
signal addressx: STD_LOGIC_VECTOR(8 downto 0);
signal countto160: STD_LOGIC_VECTOR(9 downto 0);
signal xcount: STD_LOGIC_VECTOR(9 downto 0);
signal ycount: STD_LOGIC_VECTOR(9 downto 0);
signal testwhite: STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal counter: STD_LOGIC_VECTOR(15 downto 0);
signal xaddress: STD_LOGIC_VECTOR(9 downto 0);
signal yaddress: STD_LOGIC_VECTOR(9 downto 0);
signal counterplus: STD_LOGIC_VECTOR(9 downto 0);
signal Addresstemp: STD_LOGIC_VECTOR(12 downto 0);
begin


process(mclk,clr,counter)
begin
if clr = '1' then
--Clear to default counting
counter <= (others => '0');
xaddress <= (others => '0');
yaddress <= (others => '0');
countto160 <=(others => '0');
counterplus <= (others => '0');
elsif mclk'event and mclk='1' then
counter <= counter + 1;
if counter(9 downto 5) <= 14 then

xaddress(4 downto 0) <= counter(9 downto 5);
end if;
--Counters that attempt to match the pace of VC and HC in the VGA component (OLD)
if counter(9 downto 5) > 14 then
countto160 <= countto160 + 1;
if countto160(9 downto 5) > 4 then
counter <= (others => '0');
countto160 <= (others => '0');
counterplus <= counterplus + 1;
end if;
end if;
if counterplus(9 downto 5) <= 14 then
yaddress(4 downto 0) <= counterplus(9 downto 5);
end if;
if counterplus(9 downto 5) > 14 then
counterplus <= (others => '0');
counter <= (others => '0');
countto160 <= (others => '0');
end if;
end if;

end process;
Addresstemp <= xaddress + (yaddress & "000") + ("0" & yaddress & "00") + ("00" & yaddress & "0") + yaddress;
Address <= Addresstemp(7 downto 0);
Value <= qB;
--Meant to extract data from the RAM to the vga component in order to display certain sprites (OLD)










--Old Version with errors in the output

--process(mclk, clr,countto16,countto30a,countto30b,addressfinal,addressy,addressx)
--  begin
--    if clr = '1' then
--	   countto16 <= (others => '0');
--	   countto30a <= (others => '0');
--	   countto30b <= (others => '0');
--	   addressfinal <= (others => '0');
--	   addressy <= (others => '0');
--	   addressx <= (others => '0');
--	   countto160 <= (others => '0');
--    elsif mclk'event and mclk='1' then
--	   countto30a <= countto30a + 1;
--	       if countto30a > 28 then
--	           countto30a <= (others => '0');	           
--	           countto16 <= countto16 + 1;
--               addressx <= addressx + 1;
--	       end if;
--	       if countto16 > 14 then
--	           countto30a <= (others => '0');
--               addressx <= (others => '0');
--               if countto160 < 159 then
--               countto160 <= countto160 + 1;
--               end if;
--               if countto160 > 158 then
--               countto30b <= countto30b + 1;
--               countto16 <= (others => '0');
--               countto160 <= (others => '0');
--               end if;
               
--	       end if;
--	       if countto30b > 28 then
--	           countto30b <= (others => '0');
--	           countto16 <= (others => '0');
--               countto30a <= (others => '0');
--	           addressy <= addressy + 16;	           
--	       end if;
--	       if addressy < 256 then
--	           addressfinal <= addressy + addressx; 
--	       end if;       
--	       if (addressy > 255) then
--	           addressfinal <= (others => '0');
--	           countto30b <= (others => '0');
--               countto30a <= (others => '0');
--               addressx <= (others => '0');
--               addressy <= (others => '0');
--               countto16 <= (others => '0');
--	       end if;   
--    end if;
--  end process;
--  Address <= addressfinal(7 downto 0);
--  Value <= qB;
end Behavioral;
