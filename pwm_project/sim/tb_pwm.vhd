library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pwm is
end tb_pwm;

architecture behavior of tb_pwm is

    signal clk     : std_logic := '0';
    signal clear   : std_logic := '0';
    signal d       : std_logic_vector(15 downto 0) := ("0000001001011000");
    signal pulse   : std_logic;

    constant clk_period : time := 1 us ;

begin

    -- DUT instantiation (no x0000 port!)
    DUT : entity work.pwm_generator
        port map (
            clk   => clk,
            clear => clear,
            d     => d,
            pulse => pulse
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus
    stim : process
    begin
        -- Reset counter
        clear <= '1';
        wait for 20 ns;
        clear <= '0';

        -- Set the D threshold
        d <= x"2710";

        wait for 5 ms;
        wait;
    end process;

end behavior;

