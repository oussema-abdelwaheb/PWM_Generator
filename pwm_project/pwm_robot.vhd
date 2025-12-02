library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_robot is
    Port (
        clk   : in  std_logic;
        clear : in  std_logic;

        angle1 : in integer; -- 0..180
        angle2 : in integer;
        angle3 : in integer;
        angle4 : in integer;

        pwm1  : out std_logic;
        pwm2  : out std_logic;
        pwm3  : out std_logic;
        pwm4  : out std_logic
    );
end pwm_robot;

architecture structural of pwm_robot is

    -- Shared counter for all 4 PWMs
    signal counterq : std_logic_vector(15 downto 0);

    -- Shadow registers: hold duty for current period
    signal d1_reg, d2_reg, d3_reg, d4_reg : std_logic_vector(15 downto 0);

    -- Constants
    constant MIN_TICKS : integer := 1000; -- 1 ms
    constant MAX_TICKS : integer := 2000; -- 2 ms

    -- Helper function: angle -> duty ticks
    function angle_to_ticks(a: integer) return integer is
    begin
        if a <= 0 then
            return MIN_TICKS;
        elsif a >= 180 then
            return MAX_TICKS;
        else
            return MIN_TICKS + (a * (MAX_TICKS-MIN_TICKS))/180;
        end if;
    end function;

begin

    --------------------------------------------------------------------
    -- 1. Shared Counter
    --------------------------------------------------------------------
    CNT : entity work.counter16
        port map (
            clk   => clk,
            clear => clear,
            q     => counterq
        );

    --------------------------------------------------------------------
    -- 2. Update shadow registers only at start of PWM period
    --------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                d1_reg <= (others=>'0');
                d2_reg <= (others=>'0');
                d3_reg <= (others=>'0');
                d4_reg <= (others=>'0');
            elsif counterq = x"0000" then  -- start of PWM period
                d1_reg <= std_logic_vector(to_unsigned(angle_to_ticks(angle1),16));
                d2_reg <= std_logic_vector(to_unsigned(angle_to_ticks(angle2),16));
                d3_reg <= std_logic_vector(to_unsigned(angle_to_ticks(angle3),16));
                d4_reg <= std_logic_vector(to_unsigned(angle_to_ticks(angle4),16));
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- 3. 4 PWM Generators
    --------------------------------------------------------------------
    rPWM1 : entity work.pwm_generator
        port map(clk => clk, clear => clear, d => d1_reg, pulse => pwm1);

    rPWM2 : entity work.pwm_generator
        port map(clk => clk, clear => clear, d => d2_reg, pulse => pwm2);

    rPWM3 : entity work.pwm_generator
        port map(clk => clk, clear => clear, d => d3_reg, pulse => pwm3);

    rPWM4 : entity work.pwm_generator
        port map(clk => clk, clear => clear, d => d4_reg, pulse => pwm4);

end structural;
