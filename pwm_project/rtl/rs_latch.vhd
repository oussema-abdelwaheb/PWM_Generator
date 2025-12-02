library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rs_latch is
    Port (
        clk   : in  std_logic;
        clr   : in  std_logic;       -- asynchronous clear
        S     : in  std_logic;       -- synchronous set
        R     : in  std_logic;       -- synchronous reset
        Q     : out std_logic
    );
end rs_latch;

architecture rtl of rs_latch is
    signal q_int : std_logic := '0';
begin

    process(clk, clr)
    begin
        if clr = '1' then                 -- async clear
            q_int <= '0';

        elsif rising_edge(clk) then
            if R = '1' then               -- synchronous reset
                q_int <= '0';
            elsif S = '1' then            -- synchronous set
                q_int <= '1';
            end if;
        end if;
    end process;

    Q <= q_int;
end rtl;
