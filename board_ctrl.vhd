library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--State Machine component which controls logic flow of game machine
entity board_ctrl is
    Port (  winF, gateF, blockF, emptyF, keyF, waterF, wallF, btnF, gotKeys : in STD_LOGIC; --Flags depending on what object is present at current location
            clk, clr : in STD_LOGIC;
            lookChip, lookNext, lookNextnext : out STD_LOGIC;           --Which location will be looked at by looker component
            wChipLoc, wNextLoc, wNextnextLoc : out STD_LOGIC;           --Which location will be written by writer
            wEmpty, wChip, wBlock, wDrown : out STD_LOGIC;              --Which object will be written to RAM    
            validatorOn, keyPlus, sInitial : out STD_LOGIC;             --Enable for validator component, key counter flag, load for setting chip's initial location
            chipL, nextL, nextnextL : out STD_LOGIC                     --Load signals for registers holding board locations
   );
end board_ctrl;


architecture Behavioral of board_ctrl is
    --Possible states of game logic flow
    type state_type is (Initialize, wait_btn, wait_no_btn, load_addrs, look_next,
                        validate_next, E0, E1, E2, E3, Water0, Water1, Water2, 
                        chip_got_key, check_keys, Win0, Win1, Win2, win_level, game_over,
                        look_nextnext, validate_nextnext, B0, B1, Bw0); 
    
    signal current_state, next_state : state_type;
    --signal holdon : STD_LOGIC_VECTOR(1 downto 0);
    begin

    --Ensures states progress once per clock cycle
    T : process(clk, clr)
    begin
        if clr = '1' then
            current_state <= Initialize;
            --holdon <= "00";
        elsif clk'event and clk = '1' then
            --holdon <= holdon + 1;
            --if holdon = "11" then 
                current_state <= next_state;
                --holdon <= "00";
            --end if;
        end if;
    end process;
    
    --Process controlling conditional flow
    C1 : process(current_state, winF, gateF, blockF, emptyF, keyF, waterF, wallF, btnF) 
    begin
        case current_state is
            when Initialize =>
                next_state <= wait_btn;
            when wait_btn =>                    --Waits for button to be pressed
                if btnF = '1' then
                    next_state <= wait_no_btn;
                else
                    next_state <= wait_btn;
                end if;
            when wait_no_btn =>                 --Waits for button to be released
                if btnF = '1' then
                    next_state <= wait_no_btn;
                else
                    next_state <= load_addrs;
                end if;
            when load_addrs =>                  
                next_state <= look_next;
            when look_next =>
                next_state <= validate_next;
            when validate_next =>               --Goes to appropriate state based on what object is at next location               
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
                elsif blockF = '1' then
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
            --Block is next sequence
            when look_nextnext =>
                next_state <= validate_nextnext;
            when validate_nextnext =>
                if wallF = '1' or keyF = '1' or gateF = '1' or blockF = '1' then
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

    C2 : process(current_state) 
    begin
        --set outputs to 0 initially
        lookChip <= '0'; lookNext <= '0'; lookNextnext <= '0';
        wChipLoc <= '0'; wNextLoc <= '0'; wNextnextLoc <= '0';
        wEmpty <= '0'; wChip <= '0'; wBlock <= '0'; wDrown <= '0';
        validatorOn <= '0'; sInitial <= '0'; keyPlus <= '0';
        chipL <= '0'; nextL <= '0'; nextnextL <= '0';
        
        case current_state is   
            when Initialize =>      --Loads initial location of Chip
                sInitial <= '1';
                chipL <= '1';
            when load_addrs =>      --Loads next and nextnext locations
                nextL <= '1';
                nextnextL <= '1';
            when look_next =>       --Look at next location
                lookNext <= '1';
            when validate_next =>   --Look what is inside next location
               validatorOn <= '1';
            --Empty space is next sequence    
            when E0 =>              --Write chip object to next location
                wNextLoc <= '1';
                wChip <= '1';
            when E1 =>              --Look at chip location
                lookChip <= '1';
            when E2 =>              --Write empty object to Chip's location
                wChipLoc <= '1';
                wEmpty <= '1';
            when E3 =>              --Load Chip's location
                chipL <= '1';
            --Water space is next sequence
            when Water0 =>          --Write drowning object to next location
                wNextLoc <= '1';
                wDrown <= '1';
            when Water1 =>          --Look at Chip's location
                lookChip <= '1';
            when Water2 =>          --Write empty to Chip's location
                wChipLoc <= '1';
                wEmpty <= '1';
            when game_over=>        --Game over, display losing screen
                --whatever happens when he dies, display "chip cant swim without flippers?"
                null;
            --Key space is next sequence
            when chip_got_key =>    --Write Chip to next location and decrease the remaining keys signal
                wNextLoc <= '1';
                wChip <= '1';
                keyPlus<= '1';
            --Gate space is next sequence
            --when check_keys =>
                --null;
            --Win space is next sequence
            when Win0 =>            --Write chip to next location
                wNextLoc <= '1';
                wChip <= '1';
            when Win1 =>            --Look at Chip's location
                lookChip <= '1';
            when Win2 =>            --Write empty to Chip's location
                wChipLoc <= '1';
                wEmpty <= '1';
            when win_level =>       --Level is complete
                --whatever happens when you win;
                null;
            --Block is next sequence
            when look_nextnext =>   --Look at nextnext location
                lookNextnext <= '1';
            when validate_nextnext =>   --Look what is inside nextnext location
                validatorOn <= '1';
            --empty is nextnext sequence
            when B0 =>                  --Write block to nextnext
                wNextnextLoc <= '1';
                wBlock <= '1';
            when B1 =>                  --Look at next location
               lookNext <= '1';
            when Bw0 =>                 --Write empty to nextnext location (For pushing blocks into water)
               wNextnextLoc <= '1';     
               wEmpty <= '1';
            when others =>
                null;
    end case;
    end process;

end Behavioral;
