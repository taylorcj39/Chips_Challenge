
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity dpRAM is
    Port ( addrA : in STD_LOGIC_VECTOR (3 downto 0);
           addrB : in STD_LOGIC_VECTOR (3 downto 0);
           dA : in STD_LOGIC_VECTOR (1 downto 0);
           dB : in STD_LOGIC_VECTOR (1 downto 0);
           weA : in STD_LOGIC;
           weB : in STD_LOGIC;
           qA : out STD_LOGIC_VECTOR (1 downto 0);
           qB : out STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC);
end dpRAM;

architecture Behavioral of dpram is
    signal data0: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data1: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data2: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data3: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data4: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data5: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data6: STD_LOGIC_VECTOR(1 downto 0) := "10";
    signal data7: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data8: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data9: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data10: STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal data11: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data12: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data13: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data14: STD_LOGIC_VECTOR(1 downto 0) := "01";
    signal data15: STD_LOGIC_VECTOR(1 downto 0) := "01";

type ram_array is array(NATURAL range <>) of STD_LOGIC_VECTOR(7 downto 0);
signal ram : ram_array := (data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15);

begin
    process(addrA, clk, weA)
    variable j : integer;
    begin
        j := conv_integer(addrA);
        if (clk'event and clk ='1') and (weA = '1') then
            qA <= dA;
            ram(j) <= dA;
        else
            qA <= ram(j);
        end if;   
    end process;
    
      process(addrB, clk, weB)
      variable j : integer;
      begin
          j := conv_integer(addrB);
          if (clk'event and clk ='1') and (weB = '1') then
              qB <= dB;
              ram(j) <= dB;
          else
              qB <= ram(j);
          end if;   
      end process;
end Behavioral;
