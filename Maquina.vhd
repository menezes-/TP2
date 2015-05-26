
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
        stts : OUT std_logic_vector(2 DOWNTO 0);
        --abaixo portas de teste remover
        st025 : OUT unsigned(7 DOWNTO 0);
        st050 : OUT unsigned(7 DOWNTO 0);
        st100 : OUT unsigned(7 DOWNTO 0)
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
        VARIABLE status : std_logic_vector(2 DOWNTO 0);
        BEGIN
            IF reset = '1' THEN
                estado <= R000;
                status := "000";
                --reseta as moeda
                vmr025 := (OTHERS => '0'); -- guarda as quantidades de moeda nessa "seção"
                vmr050 := (OTHERS => '0');
                vmr100 := (OTHERS => '0');
                t025 := ir025; -- guarda o total de moedas desde o reset
                t050 := ir050;
                t100 := ir100;
					 mr025 <= t025;
                mr050 <= t050;
                mr100 <= t100;

            ELSIF clk'EVENT AND clk = '1' THEN
                CASE estado IS
                    WHEN R000 => 
                        L_AGUA <= '0';
                        L_SUCO <= '0';
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
                        IF agua = '1' THEN
                            -- entrega agua e termina a operacao
                            L_AGUA <= '1';
                            status := "001";
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
                                estado <= R100;
                                -- devolve 25c de troco

                            END IF;
                        END IF;
                    WHEN R125 => 
                        REPORT "estado r125";
                        IF M025 = '1' THEN
                            estado <= R150;
                            vmr025 := vmr025 + 1;
                        ELSIF M050 = '1' THEN
                            estado <= R175;
                            vmr050 := vmr050 + 1;
                        ELSIF M100 = '1' THEN
                            estado <= R125;
                            -- devolve 50c de troco
                        END IF;

                    WHEN R150 => 
                        REPORT "estado r150";
                        IF M025 = '1' THEN
                            estado <= R175;
                            vmr025 := vmr025 + 1;
                        ELSIF M050 = '1' THEN
                            estado <= R150;
                            -- devolve 50c de troco
                        ELSIF M100 = '1' THEN
                            -- devolve 75c de troco
                            estado <= R150;
                        END IF;
                    WHEN R175 => 
                        REPORT "estado r175";
                        IF M025 = '1' THEN
                            estado <= R175;
                            -- devolve 25 de troco
                        ELSIF M050 = '1' THEN
                            estado <= R175;
                            -- devolve 50 de troco
                        ELSIF M100 = '1' THEN
                            -- devolve 1 de troco
                            estado <= R175;
                        END IF;
                END CASE;
                -- escreve a quantidade de moedas nos sinais de saida
                st025 <= vmr025;
                st050 <= vmr050;
                st100 <= vmr100;
                -- atualiza total de variaveis
                IF status = "001" THEN

                    t025 := t025 + vmr025;
						  t050 := t050 + vmr050;
						  t100 := t100 + vmr100;
                    mr025 <= t025;
                    mr050 <= t050;
                    mr100 <= t100;
                    vmr025 := (OTHERS => '0'); -- guarda as quantidades de moeda nessa "seção"
                    vmr050 := (OTHERS => '0');
                    vmr100 := (OTHERS => '0');
                    
                    estado <= R000;
                END IF;
                stts <= status;
            END IF;
        END PROCESS;
    END Behavioral;