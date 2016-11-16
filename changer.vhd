library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity changer is
    generic (N: integer := 8);
    Port    (a_in : in STD_LOGIC_VECTOR(N-1 downto 0);
             b_in : in STD_LOGIC_VECTOR(N-1 downto 0);
             sel : in STD_LOGIC;
             a_out : out STD_LOGIC_VECTOR(N-1 downto 0);
             b_out : out STD_LOGIC_VECTOR(N-1 downto 0));
end changer;

architecture Behavioral of changer is

    begin
    process(sel,b_in,a_in)
    begin
        if sel = '1' then --swap the two positions
            a_out <= b_in;
            b_out <= a_in;
        end if;
    end process;

end Behavioral;