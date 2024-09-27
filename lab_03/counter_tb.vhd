LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE behavioral OF counter_tb IS
	
	COMPONENT counter
	PORT (
    	Clk: IN STD_LOGIC;
    	RST: IN STD_LOGIC;
        Control: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Count: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Overflow: OUT STD_LOGIC;
        Underflow: OUT STD_LOGIC;
        Valid: OUT STD_LOGIC;
    	);
	END COMPONENT;
    
   	SIGNAL Clk: STD_LOGIC := '0';
    CONSTANT Clk_period : time := 2 ms;
    
    SIGNAL RST: STD_LOGIC;
    SIGNAL Control: STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Count: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Overflow: STD_LOGIC;
    SIGNAL Underflow: STD_LOGIC;
    SIGNAL Valid: STD_LOGIC;
    
    BEGIN
    
    	uut: counter PORT MAP (
        Clk => Clk,
        RST => RST,
        Control => Control,
        Count => Count,
        Overflow => Overflow,
        Underflow => Underflow,
        Valid => Valid
        );
        
        Clk_process: PROCESS
        BEGIN
        	Clk <= '0';
			wait for Clk_period/2;  
        	Clk <= '1';
        	wait for Clk_period/2; 
            
		END PROCESS Clk_process;
        
        Control_process: PROCESS
        BEGIN
        	--first case: we wait at least 20 clock cycles with reset = 1
        	RST <= '1'; 
            wait for 24 ms;
            
            --second case: illustrate case of underflow
        	RST <= '0'; 
        	Control <= "000";
			wait for 10 ms;
            
			--third case: illustrate case of overflow
            RST <= '1';
            wait for 2 ms;
        	RST <= '0'; 
        	Control <= "111";
			wait for 60 ms;
            
            --fourth case:
			RST <= '1';
            wait for 2 ms;
        	RST <= '0'; 
            
			Control <= "010";
			wait for 4 ms;
            
            Control <= "011";
			wait for 4 ms;
            
            Control <= "100";
			wait for 4 ms;
            
			Control <= "101";
			wait for 4 ms;
            
            Control <= "110";
			wait for 4 ms;
            
            Control <= "111";
			wait for 4 ms;
            
            wait;
            
		END PROCESS Control_process;
        
        
    END;
