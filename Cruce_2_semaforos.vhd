library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cruce_2_Semaforos is
    port(
        clk : in std_logic;
        reset : in std_logic;

        -- Semáforo calle A
        A_verde    : out std_logic;
        A_amarillo : out std_logic;
        A_rojo     : out std_logic;

        -- Semáforo calle B
        B_verde    : out std_logic;
        B_amarillo : out std_logic;
        B_rojo     : out std_logic
    );
end Cruce_2_Semaforos;

architecture Behavioral of Cruce_2_Semaforos is

    type state_type is (
        S_A_VERDE_B_ROJO,
        S_A_AMARILLO_B_ROJO,
        S_A_ROJO_B_VERDE,
        S_A_ROJO_B_AMARILLO
    );

    signal state, next_state : state_type;

    -- Temporizador
    signal timer_reload : std_logic_vector(3 downto 0);
    signal timer_enable : std_logic;
    signal timer_clear  : std_logic;
    signal timer_T      : std_logic;
    signal timer_Z      : std_logic;

begin

    ----------------------------------------------------------------
    -- Temporizador 
    ----------------------------------------------------------------
    TIMER0 : entity work.temporizador
        generic map ( N => 4 )
        port map (
            clk    => clk,
            clear  => timer_clear,
            reload => timer_reload,
            enable => timer_enable,
            Z      => timer_Z,
            T      => timer_T
        );

    ----------------------------------------------------------------
    -- FSM secuencial
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_A_VERDE_B_ROJO;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    ----------------------------------------------------------------
    -- FSM combinacional
    ----------------------------------------------------------------
    process(state, timer_T)
    begin
        -- valores por defecto
        A_verde    <= '0';
        A_amarillo <= '0';
        A_rojo     <= '0';
        B_verde    <= '0';
        B_amarillo <= '0';
        B_rojo     <= '0';

        timer_enable <= '1';
        timer_clear  <= '0';
        timer_reload <= "0000";
        next_state   <= state;

        case state is

            ---------------------------------------------------------
            when S_A_VERDE_B_ROJO =>
                A_verde <= '1';
                B_rojo  <= '1';
                timer_reload <= "0101"; -- 5
                if timer_T = '1' then
                    timer_clear <= '1';
                    next_state <= S_A_AMARILLO_B_ROJO;
                end if;

            ---------------------------------------------------------
            when S_A_AMARILLO_B_ROJO =>
                A_amarillo <= '1';
                B_rojo     <= '1';
                timer_reload <= "0010"; -- 2
                if timer_T = '1' then
                    timer_clear <= '1';
                    next_state <= S_A_ROJO_B_VERDE;
                end if;

            ---------------------------------------------------------
            when S_A_ROJO_B_VERDE =>
                A_rojo  <= '1';
                B_verde <= '1';
                timer_reload <= "0101"; -- 5
                if timer_T = '1' then
                    timer_clear <= '1';
                    next_state <= S_A_ROJO_B_AMARILLO;
                end if;

            ---------------------------------------------------------
            when S_A_ROJO_B_AMARILLO =>
                A_rojo     <= '1';
                B_amarillo <= '1';
                timer_reload <= "0010"; -- 2
                if timer_T = '1' then
                    timer_clear <= '1';
                    next_state <= S_A_VERDE_B_ROJO;
                end if;

        end case;
    end process;

end Behavioral;
