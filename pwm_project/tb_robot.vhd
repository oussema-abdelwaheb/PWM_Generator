library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_robot is
end tb_robot;

architecture sim of tb_robot is

    signal clk, clear : std_logic := '0';
    signal pwm1,pwm2,pwm3,pwm4 : std_logic;

    -- angle inputs
    signal angle1, angle2, angle3, angle4 : integer := 0;

    constant clk_period : time := 1 us;
    constant pwm_period : time := 20 ms; -- PWM period = 20ms

begin

    --------------------------------------------------------------------
    -- Instantiate Top-Level 4-Servo PWM
    --------------------------------------------------------------------
    DUT : entity work.pwm_robot
        port map(
            clk => clk,
            clear => clear,
            angle1 => angle1,
            angle2 => angle2,
            angle3 => angle3,
            angle4 => angle4,
            pwm1 => pwm1,
            pwm2 => pwm2,
            pwm3 => pwm3,
            pwm4 => pwm4
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    --------------------------------------------------------------------
    -- Stimulus process
    --------------------------------------------------------------------
    stim : process
    begin
        -- Initial reset
        clear <= '1'; wait for 100 us;
        clear <= '0';

        -- Wait first PWM period to stabilize
        wait for pwm_period;

        ----------------------------------------------------------------
        -- STEP 1: Set initial angles (first PWM period)
        ----------------------------------------------------------------
        angle1 <= 0;   angle2 <= 45;  angle3 <= 90;  angle4 <= 135;
        wait for pwm_period; -- wait full PWM period

        ----------------------------------------------------------------
        -- STEP 2: Change angles for next PWM period
        ----------------------------------------------------------------
        angle1 <= 90;  angle2 <= 0;   angle3 <= 180; angle4 <= 45;
        wait for pwm_period;

        ----------------------------------------------------------------
        -- STEP 3: Sweep example (update every PWM period)
        ----------------------------------------------------------------
        for i in 0 to 180 loop
            angle1 <= i;
            angle2 <= 180 - i;
            angle3 <= i;
            angle4 <= 180 - i;
            wait for pwm_period;  -- refresh once per period
        end loop;

        wait;
    end process;

end sim;
