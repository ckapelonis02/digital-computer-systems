LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Moore_FSM_tb IS
END Moore_FSM_tb;

ARCHITECTURE behavioral OF Moore_FSM_tb IS
	
	COMPONENT Moore_FSM
	PORT (
    	CLK: IN STD_LOGIC;
    	RST: IN STD_LOGIC;
    	A: IN STD_LOGIC;
    	B: IN STD_LOGIC;
		Control: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    	);
	END COMPONENT;
    
   	SIGNAL CLK: STD_LOGIC := '0';
    CONSTANT CLK_period : time := 2 ms;
    
    SIGNAL RST: STD_LOGIC;
    SIGNAL Control: STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL A: STD_LOGIC;
    SIGNAL B: STD_LOGIC;

    BEGIN
    
    	uut: Moore_FSM PORT MAP (
        CLK => CLK,
        RST => RST,
        A => A, 
        B => B
        );
        
        CLK_process: PROCESS
        BEGIN
        --  CLK_loop: for k in 0 to 100 loop
for i in 0 to 100 loop
			CLK <= '0';
              wait for CLK_period/2;  
              CLK <= '1';
              wait for CLK_period/2;
              end loop;
              wait;
        --  end loop CLK_loop;
end process;
	
    sim_proc: process
    	begin
    -- RESET 1 for 10 clock cycles
			RST <= '1';
			wait for CLK_period*10;

			-- RESET 
			RST <= '1'; wait for CLK_period;

			-- testing the second column of state table
			RST <= '0';
			A <= '0'; B <= '1';
			wait for 5*CLK_period;
          
			-- testing the third column of state table and loops
			RST <= '0';
            --S0
			A <= '1'; B <= '0';
			wait for CLK_period;
            
            A <= '0'; B <= '0';
			wait for CLK_period;
            
            A <= '1'; B <= '1';
			wait for CLK_period;
            
            --S1
			A <= '1'; B <= '0';
			wait for CLK_period;
            
            A <= '0'; B <= '0';
			wait for CLK_period;
            
            A <= '1'; B <= '1';
			wait for CLK_period;
            
            --S2
			A <= '1'; B <= '0';
			wait for CLK_period;
            
            A <= '0'; B <= '0';
			wait for CLK_period;
            
            A <= '1'; B <= '1';
			wait for CLK_period;

            --S3
			A <= '1'; B <= '0';
			wait for CLK_period;
            
            A <= '0'; B <= '0';
			wait for CLK_period;
            
            A <= '1'; B <= '1';
			wait for CLK_period;
            
            --S4
			A <= '1'; B <= '0';
			wait for CLK_period;
            
            A <= '0'; B <= '0';
			wait for CLK_period;
            
            A <= '1'; B <= '1';
			wait for CLK_period;
            
			--back to S0
			wait;
            
		END PROCESS;        
END;
