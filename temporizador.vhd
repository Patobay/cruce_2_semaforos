library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporizador is
    generic (
        N : integer := 4  -- Ancho del contador
    );
    port (
        clk    : in  std_logic;
        clear  : in  std_logic;
        reload : in  std_logic_vector(N-1 downto 0);
        enable : in  std_logic;
        Z      : out std_logic;
        T      : out std_logic
    );
end temporizador;

architecture Behavioral of temporizador is
    signal count, count_sig : unsigned(N-1 downto 0) := (others => '0');
    signal reload_value : std_logic_vector(N-1 downto 0) := (others => '0');  -- valor de recarga

begin

    registro_temporizador: process(clk)
    begin
        if rising_edge(clk) then
            count <= count_sig;    
        end if;
    end process;

    les: process(all)
    begin
        if clear then
            count_sig <= (others => '0');
        elsif not enable then
            count_sig <= count;
        elsif z then
            count_sig <= unsigned(reload);
        else 
            count_sig <= count-1;                
        end if;

    end process;

    Z <= '1' when count = 0 else '0';
    T <= '1' when count = 1 else '0';

end Behavioral;
