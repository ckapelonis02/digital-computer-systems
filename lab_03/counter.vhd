LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
	PORT (
    	Clk: IN STD_LOGIC;
    	RST: IN STD_LOGIC;
        Control: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Count: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Overflow: OUT STD_LOGIC;
        Underflow: OUT STD_LOGIC;
        Valid: OUT STD_LOGIC := '1';
    );
END counter;

ARCHITECTURE behavior OF counter IS
signal temp: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
BEGIN
	
	PROCESS
    BEGIN
    	WAIT UNTIL Clk'EVENT AND Clk = '1';
        	IF RST = '1' THEN
            	Count <= (OTHERS => '0');
                temp <= (OTHERS => '0');
                Overflow <= '0';
				Underflow <= '0';
				Valid <= '1';
			ELSE
            
            	IF Control = "000" THEN
                	IF temp < 5 AND temp >= 0 THEN
                    		Underflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp - 5;
                            Valid <= '1';
                            END IF;
                ELSIF Control = "001" THEN
                	IF temp < 2 AND temp >= 0 THEN
                    		Underflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp - 2;
                            Valid <= '1';
                            END IF;
				ELSIF Control = "010" THEN
                	temp <= temp + 0;
                    Valid <= '1';
           	    ELSIF Control = "011" THEN
                	IF temp = 255 THEN
                    		Overflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp + 1;
                            Valid <= '1';
                            END IF;
		        ELSIF Control = "100" THEN
                	IF temp < 256 AND temp > 253 THEN
                    		Overflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp + 2;
                            Valid <= '1';
                            END IF;
                ELSIF Control = "101" THEN
                	IF temp < 256 AND temp > 250 THEN
                    		Overflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp + 5;
                            Valid <= '1';
                            END IF;
                ELSIF Control = "110" THEN
                	IF temp < 256 AND temp > 249 THEN
                    		Overflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp + 6;
                            Valid <= '1';
                            END IF;
                ELSIF Control = "111" THEN
                	IF temp < 256 AND temp > 243 THEN
                    		Overflow <= '1';
                            Valid <= '0';
					ELSE
                			temp <= temp + 12;
                            Valid <= '1';
                    END IF;
        		END IF;
                
                Count <= temp;
                
			END IF;                
    END PROCESS;
END behavior;
