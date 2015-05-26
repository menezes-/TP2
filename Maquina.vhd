
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY Maquina IS
    PORT (

        reset : IN std_logic;
        D025 : OUT STD_LOGIC;
        D050 : OUT STD_LOGIC;
        D100 : OUT STD_LOGIC;
        L_AGUA : OUT STD_LOGIC;
        L_SUCO : OUT STD_LOGIC;
        agua : IN STD_LOGIC;
        suco : IN STD_LOGIC;
        M100 : IN STD_LOGIC;
        M050 : IN STD_LOGIC;
        M025 : IN STD_LOGIC;
        clk : IN std_logic;
        mr025 : OUT unsigned(7 DOWNTO 0) := (OTHERS => '0');
        mr050 : OUT unsigned(7 DOWNTO 0) := (OTHERS => '0');
        mr100 : OUT unsigned(7 DOWNTO 0) := (OTHERS => '0');
        ir025 : IN unsigned(7 DOWNTO 0);
        ir050 : IN unsigned(7 DOWNTO 0);
        ir100 : IN unsigned(7 DOWNTO 0);
        iAgua : IN unsigned(7 DOWNTO 0);
        iSuco : IN unsigned(7 DOWNTO 0);
        mAgua : OUT unsigned(7 DOWNTO 0);
        mSuco : OUT unsigned(7 DOWNTO 0);
        stts : OUT std_logic_vector(2 DOWNTO 0);
        DEV : IN std_logic;
        L_DISP : OUT std_logic;
        --abaixo portas de teste remover
        --st025 : OUT unsigned(7 DOWNTO 0);
        --st050 : OUT unsigned(7 DOWNTO 0);
        --st100 : OUT unsigned(7 DOWNTO 0);
        u025 : OUT std_logic := '0';
        u050 : OUT std_logic := '0';
        u100 : OUT std_logic := '0'
        );

    END Maquina;

    ARCHITECTURE Behavioral OF Maquina IS
        TYPE STATE_TYPE IS (R000, R025, R050, R075, R100, R125, R150, R175);
        SIGNAL estado : STATE_TYPE := R000;
    BEGIN
        PROCESS (clk, reset)
        VARIABLE vmr025 : unsigned(7 DOWNTO 0) := (OTHERS => '0'); -- guarda as quantidades de moeda nessa "seção"
        VARIABLE vmr050 : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE vmr100 : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE t025 : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE t050 : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE t100 : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE count_agua : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE count_suco : unsigned(7 DOWNTO 0) := (OTHERS => '0');
        VARIABLE status : std_logic_vector(2 DOWNTO 0);
        BEGIN
            IF reset = '1' THEN
                estado <= R000;
                status := "000";
                --reseta as moeda
                vmr025 := (OTHERS => '0'); -- guarda as quantidades de moeda nessa "seção"
                vmr050 := (OTHERS => '0');
                vmr100 := (OTHERS => '0');

                --inicializa as moedas
                t025 := ir025;
                t050 := ir050;
                t100 := ir100;
                mr025 <= t025;
                mr050 <= t050;
                mr100 <= t100;

                --inicializa agua e suco
                count_agua := iAgua;
                count_suco := iSuco;
                mAgua <= count_agua;
                mSuco <= count_suco;

            ELSIF clk'EVENT AND clk = '1' THEN
                L_DISP <= '0';
                IF DEV = '1' THEN -- se foi pedido a devolucao
                    u025 <= '0';
                    u050 <= '0';
                    u100 <= '0';
						  if vmr025 > 0 or vmr050 >0 or vmr100 > 0 then
							  vmr025 := (OTHERS => '0');
							  vmr050 := (OTHERS => '0');
							  vmr100 := (OTHERS => '0');
							  L_DISP <= '1';
							end if;
                    estado <= R000;
						  status := "010";
                ELSE
                    CASE estado IS
                        WHEN R000 => 
                            L_AGUA <= '0'; -- para de liberar agua
                            L_SUCO <= '0'; -- para de liberar suco
                            u025 <= '0';
                            u050 <= '0';
                            u100 <= '0';
                            status := "000";
                            REPORT "estado r000";
                            IF agua = '1' OR suco = '1' THEN
                                status := "011";
                            END IF;
                            IF M025 = '1' THEN
                                estado <= R025;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                estado <= R050;
                                vmr050 := vmr050 + 1;
                            ELSIF M100 = '1' THEN
                                estado <= R100;
                                vmr100 := vmr100 + 1;

                            END IF;
                        WHEN R025 => 
                            REPORT "estado r025";
                            u050 <= '0';
                            u100 <= '0';
                            u025 <= '1'; --seta visor de 25
                            IF agua = '1' OR suco = '1' THEN
                                status := "011";
                            END IF;
                            IF M025 = '1' THEN
                                estado <= R050;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                estado <= R075;
                                vmr050 := vmr050 + 1;
                            ELSIF M100 = '1' THEN
                                estado <= R125;
                                vmr100 := vmr100 + 1;

                            END IF;

                        WHEN R050 => 
                            u025 <= '0';
                            u050 <= '1'; --seta visor de 50
                            u100 <= '0';
                            REPORT "estado r050";
                            IF agua = '1' OR suco = '1' THEN
                                status := "011";
                            END IF;
                            IF M025 = '1' THEN
                                estado <= R075;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                estado <= R100;
                                vmr050 := vmr050 + 1;
                            ELSIF M100 = '1' THEN
                                estado <= R150;
                                vmr100 := vmr100 + 1;

                            END IF;

                        WHEN R075 => 
                            REPORT "estado r075";
                            u025 <= '1';
                            u050 <= '1';
                            u100 <= '0';
                            IF agua = '1' OR suco = '1' THEN
                                status := "011";
                            END IF;
                            IF M025 = '1' THEN
                                estado <= R100;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                estado <= R125;
                                vmr050 := vmr050 + 1;
                            ELSIF M100 = '1' THEN
                                estado <= R175;
                                vmr100 := vmr100 + 1;

                            END IF;
                        WHEN R100 => 
                            REPORT "estado r100";
                            -- caso eu tenha devolvido a moeda inserida
                            -- pois passou de 175 para de dar moeda de um real
                            D100 <= '0';

                            u025 <= '0';
                            u050 <= '0';
                            u100 <= '1';
                            IF agua = '1' THEN
                                -- entrega agua e termina a operacao
                                IF count_agua > 0 THEN
                                    L_AGUA <= '1';
                                    count_agua := count_agua - 1;
                                    status := "001";
                                ELSE
                                    status := "100";
                                END IF;
                            ELSE -- se nao continua processamento normal
                                IF suco = '1' THEN
                                    status := "011";
                                END IF;
                                IF M025 = '1' THEN
                                    estado <= R125;
                                    vmr025 := vmr025 + 1;
                                ELSIF M050 = '1' THEN
                                    estado <= R150;
                                    vmr050 := vmr050 + 1;
                                ELSIF M100 = '1' THEN
                                    IF t025 > 0 THEN
                                        -- se eu tiver troco de 25 cents
                                        D025 <= '1';
                                        t025 := t025 - 1; -- diminuo uma moeda de 25
                                        vmr100 := vmr100 + 1;
                                        estado <= R175;
                                    ELSE
                                        D100 <= '1';
                                        status := "011";
                                        estado <= R100;
                                    END IF;

                                END IF;
                            END IF;
                        WHEN R125 => 
                            REPORT "estado r125";
                            D100 <= '0'; -- evita dar um monte de moeda

                            u025 <= '1';
                            u050 <= '0';
                            u100 <= '1';
                            IF M025 = '1' THEN
                                estado <= R150;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                estado <= R175;
                                vmr050 := vmr050 + 1;
                            ELSIF M100 = '1' THEN
                                IF t050 > 0 THEN
                                    -- se eu tiver troco de 50 cents
                                    D050 <= '1';
                                    t050 := t050 - 1; -- diminuo uma moeda de 50
                                    vmr100 := vmr100 + 1;
                                    estado <= R175;
                                ELSE
                                    D100 <= '1';
                                    status := "011";
                                    estado <= R125;
                                END IF;
                            END IF;

                        WHEN R150 => 
                            REPORT "estado r150";
                            D100 <= '0'; -- evita dar um monte de moeda
                            D050 <= '0'; -- evita dar um monte de moeda

                            u025 <= '0';
                            u050 <= '1';
                            u100 <= '1';
                            IF M025 = '1' THEN
                                estado <= R175;
                                vmr025 := vmr025 + 1;
                            ELSIF M050 = '1' THEN
                                IF t025 > 0 THEN
                                    -- se eu tiver troco de 25 cents
                                    D025 <= '1';
                                    t025 := t025 - 1; -- diminuo uma moeda de 25
                                    vmr050 := vmr050 + 1;
                                    estado <= R175;
                                ELSE
                                    D050 <= '1';
                                    status := "011";
                                    estado <= R150;
                                END IF;
                            ELSIF M100 = '1' THEN
                                IF t025 = 0 OR t050 = 0 THEN
                                    D100 <= '1';
                                    status := "011";
                                    estado <= R150;

                                ELSE
                                    D050 <= '1';
                                    t050 := t050 - 1;
                                    D025 <= '1';
                                    t025 := t025 - 1;
                                    estado <= R175;
                                    vmr100 := vmr100 + 1;
                                END IF;
                            END IF;
                        WHEN R175 => 
                            REPORT "estado r175";
                            -- se eu cheguei nesse estado por excesso de dinheiro
                            -- (passou de 1,75) então reseta os sinais de moeda
                            -- para não ficar dando dinheiro pra galere
                            D025 <= '0';
                            D050 <= '0';
                            D100 <= '0';

                            u025 <= '1';
                            u050 <= '1';
                            u100 <= '1';
                            IF M025 = '1' THEN
                                D025 <= '1';
                                estado <= R175;
                            ELSIF M050 = '1' THEN
                                D050 <= '1';
                                estado <= R175;
                            ELSIF M100 = '1' THEN
                                D100 <= '1';
                                estado <= R175;
                            END IF;
                    END CASE;
                END IF;
                -- escreve a quantidade de moedas nos sinais de saida
                --st025 <= vmr025;
                --st050 <= vmr050;
                --st100 <= vmr100;

                -- atualiza total de variaveis
                IF status = "001" THEN
                    -- atualiza moedas
                    t025 := t025 + vmr025;
                    t050 := t050 + vmr050;
                    t100 := t100 + vmr100;
                    mr025 <= t025;
                    mr050 <= t050;
                    mr100 <= t100;

                    --atualiza os produtos
                    mAgua <= count_agua;
                    mSuco <= count_suco;

                    vmr025 := (OTHERS => '0'); -- guarda as quantidades de moeda nessa "seção"
                    vmr050 := (OTHERS => '0');
                    vmr100 := (OTHERS => '0');

                    estado <= R000;
                END IF;
                stts <= status;
            END IF;
        END PROCESS;
    END Behavioral;