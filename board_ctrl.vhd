--eliminated E4 with smarter MUX to chipL sicne chipL never gets nextnext
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity board_ctrl is
    Port(   winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF, gotKeys : in STD_LOGIC;
            clk, clr : in STD_LOGIC;
            lookChip, lookNext, lookNextnext : out STD_LOGIC;
            wChipLoc, wNextLoc, wNextnextLoc : out STD_LOGIC;
            wEmpty, wChip, wBrick, wDrown : out STD_LOGIC;
            validatorOn, keyPlus, loadInitial : out STD_LOGIC;
            chipL, nextL, nextnextL : out STD_LOGIC
    );
end board_ctrl;

architecture Behavioral of board_ctrl is
    type state_type is (Initialize, wait_btn, load_addrs, look_next,
                        validate_next, E0, E1, E2, E3, Water0, Water1, Water2, 
                        chip_got_key, check_keys, Win0, Win1, Win2, win_level, game_over,
                        look_nextnext, validate_nextnext, B0, B1, Bw0); 
    
    signal current_state, next_state : state_type;
    begin

    T : process(clk, clr)
    begin
        if clr = '1' then
            current_state <= Initialize;
        elsif clk'event and clk = '1' then
            current_state <= next_state;
        end if;
    end process;
    
    C1 : process(current_state, winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF) 
    begin
        case current_state is
            when Initialize =>
                next_state <= wait_btn;
            when wait_btn =>
                if btnF = '1' then
                    next_state <= load_addrs;
                else
                    next_state <= wait_btn;
                end if;
            when load_addrs =>
                next_state <= look_next;
            when look_next =>
                next_state <= validate_next;
            when validate_next =>
                if wallF = '1' then
                    next_state <= wait_btn;
                elsif emptyF = '1' then
                    next_state <= E0;
                elsif waterF = '1' then
                    next_state <= Water0;
                elsif keyF = '1' then
                    next_state <= chip_got_key;
                elsif  gateF = '1' then
                    next_state <= check_keys;
                elsif winF = '1' then
                    next_state <= Win0; -- could be reduced to work with empty stuff   
                elsif brickF = '1' then
                    next_state <= look_nextnext;
                else
                    null;    
                end if;
            --Empty space is next sequence    
            when E0 =>
                next_state <= E1;
            when E1 =>
                next_state <= E2;
            when E2 =>
                next_state <= E3;
            when E3 =>
                next_state <= wait_btn;
            --Water space is next sequence
            when Water0 =>
                next_state <= Water1;
            when Water1 =>
                 next_state <= Water2;
            when Water2 =>
                 next_state <= game_over;
            --Key space is next sequence
            when chip_got_key =>
                next_state <= E1;
            --Gate space is next sequence
            when check_keys =>
                if gotKeys = '1' then
                    next_state <= E0;
                else
                    next_state <= wait_btn;
                end if;
            --Win space is next sequence
            when Win0 =>
                next_state <= Win1;
            when Win1 =>
                next_state <= Win2;
            when Win2 =>
                next_state <= win_level;
            --Brick is next sequence
            when look_nextnext =>
                next_state <= validate_nextnext;
            when validate_nextnext =>
                if wallF = '1' or keyF = '1' or gateF = '1' or brickF = '1' then
                    next_state <= wait_btn;
                elsif emptyF = '1' then
                    next_state <= B0;
                elsif waterF= '1' then
                    next_state <= Bw0;
                else
                    null;
                end if;
            --empty is nextnext sequence
            when B0 =>
                next_state <= B1;
            when B1 =>
                next_state <= E0;
            when Bw0 =>
                next_state <= B1;
            when others =>
                null;
    end case;
    end process;

    C2 : process(current_state, winF, gateF, brickF, emptyF, keyF, waterF, wallF, btnF) 
    begin
        --set outputs to 0
        lookChip <= '0'; lookNext <= '0'; lookNextnext <= '0';
        wEmpty <= '0'; wChip <= '0'; wBrick <= '0'; wDrown <= '0';
        validatorOn <= '0'; loadInitial <= '0'; keyPlus <= '0';
        chipL <= '0'; nextL <= '0'; nextnextL <= '0';
        case current_state is
            when Initialize =>
                --look for problems with initial, might have to make 2 states here
                loadInitial <= '1';
                chipL <= '1';
            --when wait_btn =>   
            when load_addrs =>
                nextL <= '1';
                nextnextL <= '1';
            when look_next =>
                lookNext <= '1';
            when validate_next =>
               validatorOn <= '1';
            --Empty space is next sequence    
            when E0 =>
                wNextLoc <= '1';
                wChip <= '1';
            when E1 =>
                lookChip <= '1';
            when E2 =>
                wChipLoc <= '1';
                wEmpty <= '1';
            when E3 =>
                chipL <= '1';
            --Water space is next sequence
            when Water0 =>
                wNextLoc <= '1';
                wDrown <= '1';
            when Water1 =>
                lookChip <= '1';
            when Water2 =>
                wChipLoc <= '1';
                wEmpty <= '1';
            when game_over=>
                --whatever happens when he dies, display "chip cant swim without flippers?"
                null;
            --Key space is next sequence
            when chip_got_key =>
                wNextLoc <= '1';
                wChip <= '1';
                keyPlus<= '1';
            --Gate space is next sequence
            when check_keys =>
                null;
            --Win space is next sequence
            when Win0 =>
                wNextLoc <= '1';
                wChip <= '1';
            when Win1 =>
                lookChip <= '1';
            when Win2 =>
                wChipLoc <= '1';
                wEmpty <= '1';
            when win_level =>
                --whatever happens when you win;
                null;
            --Brick is next sequence
            when look_nextnext =>
                lookNextnext <= '1';
            when validate_nextnext =>
                validatorOn <= '1';
            --empty is nextnext sequence
            when B0 =>
                wNextnextLoc <= '1';
                wBrick <= '1';
            when B1 =>
               lookNext <= '1';
            when Bw0 =>
               wNextnextLoc <= '1';
               wEmpty <= '1';
            when others =>
                null;
    end case;
    end process;

end Behavioral;
