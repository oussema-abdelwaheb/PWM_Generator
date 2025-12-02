library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter16 is
    Port (
        clk   : in  std_logic;
        clear : in  std_logic;
        q     : out std_logic_vector(15 downto 0)
    );
end counter16;

architecture rtl of counter16 is
    signal cnt : unsigned(15 downto 0) := (others => '0');
    
    -- Constant max value (20000 - 1)
    constant MAX_COUNT : unsigned(15 downto 0) := to_unsigned(19999, 16);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                cnt <= (others => '0');
            else
                if cnt = MAX_COUNT then
                    cnt <= (others => '0');       -- rollover at 19999
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;

    q <= std_logic_vector(cnt);
end rtl;


