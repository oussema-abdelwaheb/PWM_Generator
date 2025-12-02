library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is
    Port (
        clk     : in  std_logic;
        clear   : in  std_logic;
        d       : in  std_logic_vector(15 downto 0);
        pulse   : out std_logic
    );
end pwm_generator;

architecture structural of pwm_generator is

    -- Internal signals
    signal counterq     : std_logic_vector(15 downto 0);
    signal d_clamped    : std_logic_vector(15 downto 0);
    signal cmp_s        : std_logic;
    signal cmp_r        : std_logic;

    constant MAX_D : unsigned(15 downto 0) := to_unsigned(19999, 16);

begin

    --------------------------------------------------------------------
    -- 0. Clamp D
    --------------------------------------------------------------------
    process(d)
    begin
        if unsigned(d) = 0 then
            d_clamped <= (others => '0');
        elsif unsigned(d) > MAX_D then
            d_clamped <= std_logic_vector(MAX_D);
        else
            d_clamped <= d;
        end if;
    end process;

    --------------------------------------------------------------------
    -- 1. Counter
    --------------------------------------------------------------------
    CNT : entity work.counter16
        port map (
            clk   => clk,
            clear => clear,
            q     => counterq
        );

    --------------------------------------------------------------------
    -- 2. Comparators
    --------------------------------------------------------------------
    -- Compare counter = 0 ? set pulse
    CMP0 : entity work.comparator16
        port map (
            A => counterq,
            B => (others => '0'),
            Y => cmp_s
        );

    -- Compare counter = D ? reset pulse
    CMPD : entity work.comparator16
        port map (
            A => counterq,
            B => d_clamped,
            Y => cmp_r
        );

    --------------------------------------------------------------------
    -- 3. RS latch with async clear
    --------------------------------------------------------------------
    RS : entity work.rs_latch
        port map (
            clk => clk,
            clr => clear,
            S   => cmp_s,
            R   => cmp_r,
            Q   => pulse
        );

end structural;
