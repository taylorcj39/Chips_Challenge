library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity chip_state_ctrl_v1 is 
	port( clk : in STD_LOGIC;
		  clr : in STD_LOGIC;
		  btnFlag : in STD_LOGIC;
		  validFlag : in STD_LOGIC;
		  currentL : out STD_LOGIC;
		  nextL : out STD_LOGIC
		  initChip : out STD_LOGIC;
	);
end chip_state_ctrl_v1;

architecture chip_state_ctrl_v1 of chip_state_ctrl_v1 is 
type state_type is (initial, start, btnPushed, valid, currentLoad);
signal present_state, next_state: state_type;
begin

sreg : process(clk, clr)
begin
	if clr = '1' then
        present_state <= initial;
    elsif clk'event and clk = '1' then
        present_state <= next_state;
    end if;
end process;

C1 : process(present_state, btnFlag, validFlag)
begin
	case present_state is 
		when initial =>
			next_state <= start;
		when start =>
			if btnFlag = '1' then
				next_state <= btnPushed;
			else
				next_state <= start;
			end if;
		when btnPushed =>
			next_state <= valid;
		when valid =>
			if validFlag = '1' then
				next_state <= currentLoad;
			else 
				next_state <= start;
			end if;
		when currentLoad => 
			next_state <= start;
		when others => 
			null;
	end case;
end process;

C2 : process(present_state)
begin
	currentL <= '0'; nextL <= '0'; initChip <= '0';
	case present_state is 
		when initChip =>
			initChip <= '1';
			currentL <= '1';
		when btnPushed =>
			nextL <= '1';
		when currentLoad =>
			currentL <= '1';
		when others =>
			null;
	end case;
end process;

end chip_state_ctrl_v1;