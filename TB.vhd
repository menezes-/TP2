library IEEE;
use IEEE.STD_LOGIC_1164.all;
use  ieee.numeric_std.all;

entity TbMaq is
end TbMaq;
architecture TbMaq of TbMaq is
signal agua: STD_LOGIC;
signal suco: STD_LOGIC;
signal M100: STD_LOGIC;
signal M050: STD_LOGIC;
signal M025: STD_LOGIC;
signal clk: std_logic;
signal reset: std_logic;
signal D025: STD_LOGIC;
signal D050: STD_LOGIC;
signal D100: STD_LOGIC;
signal L_AGUA: STD_LOGIC;
signal L_SUCO: STD_LOGIC;
signal mr025: unsigned(7 downto 0);
signal mr050: unsigned(7 downto 0);
signal mr100: unsigned(7 downto 0);
signal ir025: unsigned(7 downto 0) := "00000101";
signal ir050: unsigned(7 downto 0) := "00000101";
signal ir100: unsigned(7 downto 0) := "00000101";
signal stts: std_logic_vector(2 downto 0);
signal st025: unsigned(7 downto 0);
signal st050: unsigned(7 downto 0);
signal st100: unsigned(7 downto 0);

constant Clk_period : time := 10 ns;
begin
	 Maq:entity work.Maquina port map(agua=>agua,
										suco=>suco,
										M100=>M100,
										M050=>M050,
										M025=>M025,
										clk=>clk,
										reset=>reset,
										D025=>D025,
										D050=>D050,
										D100=>D100,
										L_AGUA=>L_AGUA,
										L_SUCO=>L_SUCO,
										mr025=>mr025,
										mr050=>mr050,
										mr100=>mr100,
										ir025=>ir025,
										ir050=>ir050,
										ir100=>ir100,
										stts=>stts,
										st025=>st025,
										st050=>st050,
										st100=>st100
);
	 
	Clk_process :process
   begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
   end process;
	
	stim_proc: process
   begin
    wait for Clk_period;
    M100 <= '1'; wait for Clk_period;
    agua <= '1'; wait for Clk_period;
    wait;

   end process;

end TbMaq;