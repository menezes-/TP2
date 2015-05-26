
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity Maquina is
    Port ( agua : in  STD_LOGIC := '0';
           suco : in  STD_LOGIC := '0';
           M100 : in  STD_LOGIC;
           M050 : in  STD_LOGIC;
           M025 : in  STD_LOGIC;
			  clk: in std_logic;
			  reset: in std_logic;
			  D025: out STD_LOGIC;
			  D050: out STD_LOGIC;
			  D100: out STD_LOGIC;
			  L_AGUA: out STD_LOGIC;
			  L_SUCO: out STD_LOGIC;
			  mr025: out unsigned(7 downto 0):= (others=>'0');
			  mr050: out unsigned(7 downto 0):= (others=>'0');
			  mr100: out unsigned(7 downto 0):= (others=>'0');
			  ir025: in unsigned(7 downto 0);
			  ir050: in unsigned(7 downto 0);
			  ir100: in unsigned(7 downto 0);
			  stts : out std_logic_vector(2 downto 0);
			  --abaixo portas de teste remover 
			  st025: out unsigned(7 downto 0);
	        st050: out unsigned(7 downto 0);
	        st100: out unsigned(7 downto 0)
			  );
			  
end Maquina;

architecture Behavioral of Maquina is
   type STATE_TYPE is (R000,R025,R050,R075,R100,R125,R150,R175);
   

begin


   process(clk, reset)
	variable vmr025: unsigned(7 downto 0) := (others=>'0'); -- guarda as quantidades de moeda nessa "seção"
	variable vmr050: unsigned(7 downto 0) := (others=>'0');
	variable vmr100: unsigned(7 downto 0) := (others=>'0');
	variable t025: unsigned(7 downto 0) := ir025;
	variable t050: unsigned(7 downto 0) := ir050;
	variable t100: unsigned(7 downto 0) := ir100;
	variable status: std_logic_vector(2 downto 0);
	variable  estado: STATE_TYPE := R000;
	
	begin
	 if reset = '1' then 
	  estado :=R000;
		status := "000";
		--reseta as moeda
		 vmr025 := (others=>'0'); -- guarda as quantidades de moeda nessa "seção"
		 vmr050 := (others=>'0');
		 vmr100 := (others=>'0');
		 t025 := (others=>'0'); -- guarda as quantidades de moeda nessa "seção"
		 t050 := (others=>'0');
		 t100 := (others=>'0');
			
	elsif clk'event and clk = '1' then 
	 case estado is
	   when R000 =>
		
		when R025 =>
		report "estado r025";

		when R050 =>
		report "estado r050";

		when R075 =>
		report "estado r075";

		   
		when R100 =>
		report "estado r100";
		  
		when R125 =>
		report "estado r125";
		       
			
		when R150 =>
		report "estado r150";

		when R175 =>
		report "estado r175";
	 end case;
	 -- escreve a quantidade de moedas nos sinais de saida
    st025 <= vmr025;
	 st050 <= vmr050;
	 st100 <= vmr100;
	 -- atualiza total de variaveis
	 if status = "001" then
	    t025 := t025 + vmr025;
		 t050 := t050 + vmr050;
		 t100 := t100 + vmr100;






       mr025 <= t025;
	    mr050 <= t050;
	    mr100 <= t100;
		 vmr025 := (others=>'0'); -- guarda as quantidades de moeda nessa "seção"
	    vmr050 := (others=>'0');
	    vmr100 := (others=>'0');
		 status := "000";
		estado :=R000;
		 
	 end if;
	 stts <= status;
	 

	end if;
	end process;
			  
	


end Behavioral;

