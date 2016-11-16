library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity move_validator is
    generic (N: integer := 8);
    Port    (a : in STD_LOGIC_VECTOR(N-1 downto 0);
             b : in STD_LOGIC_VECTOR(N-1 downto 0);
             valid : out STD_LOGIC);
end move_validator;

architecture Behavioral of move_validator is

begin
process(b)
begin
    if b = "01" then
         valid <= '0';
    else 
         valid <= '1';
    end if;
end process;

end Behavioral;