library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================
-- Testbench para el cruce de dos semáforos coordinados
-- Calle A y Calle B (perpendiculares)
-- Usa una FSM + temporizador
-- ============================================================

entity tb_cruce_2_semaforos is
end entity;

architecture test of tb_cruce_2_semaforos is

    -- Señales del clock y reset
    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '0';

    -- Señales de salida del semáforo A
    signal A_verde_tb    : std_logic;
    signal A_amarillo_tb : std_logic;
    signal A_rojo_tb     : std_logic;

    -- Señales de salida del semáforo B
    signal B_verde_tb    : std_logic;
    signal B_amarillo_tb : std_logic;
    signal B_rojo_tb     : std_logic;

    -- Período del clock
    constant CLK_PERIOD : time := 10 ns;

begin

    ------------------------------------------------------------
    -- Generador de clock
    -- Produce una señal periódica de 10 ns
    ------------------------------------------------------------
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    ------------------------------------------------------------
    -- Instanciación del dispositivo bajo prueba (DUT)
    -- Es el cruce de dos semáforos coordinados
    ------------------------------------------------------------
    DUT : entity work.Cruce_2_Semaforos
        port map (
            clk => clk_tb,
            reset => reset_tb,

            A_verde    => A_verde_tb,
            A_amarillo => A_amarillo_tb,
            A_rojo     => A_rojo_tb,

            B_verde    => B_verde_tb,
            B_amarillo => B_amarillo_tb,
            B_rojo     => B_rojo_tb
        );

    ------------------------------------------------------------
    -- Proceso de estímulos
    ------------------------------------------------------------
    stim_proc : process
    begin

        --------------------------------------------------------
        -- Reset inicial
        -- Coloca el sistema en el estado inicial:
        -- Calle A verde / Calle B rojo
        --------------------------------------------------------
        reset_tb <= '1';
        wait for 30 ns;
        reset_tb <= '0';

        --------------------------------------------------------
        -- Simulación normal
        -- Se dejan correr varios ciclos para observar:
        -- A verde → A amarillo → B verde → B amarillo → A verde
        --------------------------------------------------------
        wait for 400 ns;

        --------------------------------------------------------
        -- Fin de la simulación
        --------------------------------------------------------
        wait;
    end process;

end architecture;
