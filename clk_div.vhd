----------------------------------------------------------------------------------
-- Company: OU
-- Engineer: Chris Taylor
-- 
-- Create Date: 10/27/16
-- Project Name: Lab5

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity clk_div is
    Port ( mclk : in STD_LOGIC;
           clr : in STD_LOGIC;
           clk50M : out STD_LOGIC
--           clk190 : out STD_LOGIC;
--           clk48 : out STD_LOGIC;
--		   clk3 : out STD_LOGIC;
--		   clk3k : out STD_LOGIC
    );
end clk_div;

architecture Behavioral of clk_div is
    signal q: STD_LOGIC_VECTOR(23 downto 0);
begin
    process(mclk,clr)
    begin
        if clr = '1' then
            q <= X"000000";
        elsif mclk'event and mclk = '1' then
            q <= q+1;
        end if;
    end process;
    
	--Samples the 18th bit to get Fmclk(50Mhz)/(2^18)=190.7Hz
    --clk190 <= q(17);
	
	--Samples the 20th bit to get Fmclk(50MHz)/(2^20)=47.7Hz
    --clk48 <= q(19);
	
	--Samples the 4th  bit to get Fmclk(50MHz)/(2^4)=3.13MHz
    --clk3 <= q(3);
    
    --Samples the 14th  bit to get Fmclk(50MHz)/(2^14)=3.05kHz
    --clk3k <= q(13);
    
    clk50M <= q(2);
end Behavioral;
