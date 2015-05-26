LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TbMaq IS
END TbMaq;
ARCHITECTURE TbMaq OF TbMaq IS
    SIGNAL agua : STD_LOGIC;
    SIGNAL suco : STD_LOGIC;
    SIGNAL M100 : STD_LOGIC;
    SIGNAL M050 : STD_LOGIC;
    SIGNAL M025 : STD_LOGIC;
    SIGNAL clk : std_logic;
    SIGNAL reset : std_logic;
    SIGNAL D025 : STD_LOGIC;
    SIGNAL D050 : STD_LOGIC;
    SIGNAL D100 : STD_LOGIC;
    SIGNAL L_AGUA : STD_LOGIC;
    SIGNAL L_SUCO : STD_LOGIC;
    SIGNAL mr025 : unsigned(7 DOWNTO 0);
    SIGNAL mr050 : unsigned(7 DOWNTO 0);
    SIGNAL mr100 : unsigned(7 DOWNTO 0);
    SIGNAL ir025 : unsigned(7 DOWNTO 0) := "00000101";
    SIGNAL ir050 : unsigned(7 DOWNTO 0) := "00000101";
    SIGNAL ir100 : unsigned(7 DOWNTO 0) := "00000101";
    SIGNAL stts : std_logic_vector(2 DOWNTO 0);
    SIGNAL st025 : unsigned(7 DOWNTO 0);
    SIGNAL st050 : unsigned(7 DOWNTO 0);
    SIGNAL st100 : unsigned(7 DOWNTO 0);

    CONSTANT Clk_period : TIME := 10 ns;

    SIGNAL run : std_logic := '1';
BEGIN
    Maq : ENTITY work.Maquina
        PORT MAP(
            agua    => agua, 
            suco    => suco, 
            M100    => M100, 
            M050    => M050, 
            M025    => M025, 
            clk     => clk, 
            reset   => reset, 
            D025    => D025, 
            D050    => D050, 
            D100    => D100, 
            L_AGUA  => L_AGUA, 
            L_SUCO  => L_SUCO, 
            mr025   => mr025, 
            mr050   => mr050, 
            mr100   => mr100, 
            ir025   => ir025, 
            ir050   => ir050, 
            ir100   => ir100, 
            stts    => stts, 
            st025   => st025, 
            st050   => st050, 
            st100   => st100
        );

    Clk_process : PROCESS
    BEGIN
        -- roda somente 10 vezes
        FOR I IN 0 TO 9 LOOP
            Clk <= '0';
            WAIT FOR Clk_period/2;
            Clk <= '1';
            WAIT FOR Clk_period/2;
        END LOOP;
        Clk <= '0';
        WAIT;

    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        WAIT FOR Clk_period;
        M025 <= '1';
        WAIT FOR Clk_period;
        M025 <= '0';
        M050 <= '1';
        WAIT FOR Clk_period;
        M050 <= '0';
        M100 <= '1';
        WAIT FOR Clk_period;
        M100 <= '0';

        WAIT;

    END PROCESS;

END TbMaq;