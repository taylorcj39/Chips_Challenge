library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity KeyTracker is 
	port( clr : in STD_LOGIC;
		  clk : in STD_LOGIC;
		  KeyStart : in STD_LOGIC_VECTOR(2 downto 0);
          KeyPlus : in STD_LOGIC;
		  RemKeys : out STD_LOGIC_VECTOR(2 downto 0)
		);
		
end KeyTracker;

architecture KeyTracker of KeyTracker is 
signal count : STD_LOGIC_VECTOR(2 downto 0); -- signal to hold subtracted value
signal lock : STD_LOGIC := '0'; -- signal used to make sure the subtraction only happens once everytime KeyPlus goes high

begin 

	process(clr, clk)
	begin
		if clr = '1' then 
			count <= KeyStart; -- set default key number back to count
			lock <= '0'; --unlock subtractor
		elsif clk'event and clk = '1' then
		      if KeyPlus = '1' and lock = '0' then
			     count <= count - 1;
			     lock <= '1'; -- lock subtractor
			  elsif KeyPlus = '0' and lock = '1' then
			     lock <= '0'; -- unlock subtractor
		      end if;
		end if;
	end process;
	
	RemKeys <= count; -- assign count to the output
end KeyTracker;
