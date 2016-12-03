--Outputs the remaining number of keys for Chip to collect
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity key_counter is 
	port( clr : in STD_LOGIC;
		  clk : in STD_LOGIC;
		  keyStart : in STD_LOGIC_VECTOR(2 downto 0); --Starting number of keys in level
          keyPlus : in STD_LOGIC;                     --Input flag that goes high when Chip collects a key                           
		  remKeys : out STD_LOGIC_VECTOR(2 downto 0)  --Output of remaining number of keys
		);
end key_counter;

architecture key_counter of key_counter is 
signal count : STD_LOGIC_VECTOR(2 downto 0); -- signal to hold subtracted value
signal lock : STD_LOGIC := '0'; -- signal used to make sure the subtraction only happens once everytime KeyPlus goes high

begin 

	process(clr, clk)
	begin
		if clr = '1' then 
			count <= keyStart; -- set default key number back to count
			lock <= '0'; --unlock subtractor
		elsif clk'event and clk = '1' then
		      if keyPlus = '1' and lock = '0' then
			     count <= count - 1;
			     lock <= '1'; -- lock subtractor
			  elsif keyPlus = '0' and lock = '1' then
			     lock <= '0'; -- unlock subtractor
		      end if;
		end if;
	end process;
	
	remKeys <= count; -- assign count to the output
end key_counter;
