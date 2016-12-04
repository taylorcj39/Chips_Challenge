library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.All;

entity loader_dp is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           countPlus : in STD_LOGIC;                    --Input to counter to increment count
           lastF : out STD_LOGIC;                       --Signifies when the last address has been reached
           count : out STD_LOGIC_VECTOR(7 downto 0));    --Which address will be written
end loader_dp;

architecture Behavioral of loader_dp is

    signal countSig : STD_LOGIC_VECTOR(7 downto 0);
begin

    --Counter Process
    process(clk, clr, countPlus)
	begin
		if clr = '1' then
			countSig <= (0 => '1', others => '0');
		elsif clk'event and clk = '1' then
			if countPlus = '1' then 
			     countSig <= countSig + 1;
			end if;
		end if;						 
	end process;			
	
	count <= countSig;
	lastF <= '1' when countSig = X"E1" else '0';  --LastF is '1' when count = 225 signifying the last address in the RAM has been reached 

end Behavioral;
