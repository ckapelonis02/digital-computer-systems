LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Moore_FSM IS
	PORT (
    	CLK: IN STD_LOGIC;
    	RST: IN STD_LOGIC;
    	A: IN STD_LOGIC;
    	B: IN STD_LOGIC;
		Control: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
END Moore_FSM;

ARCHITECTURE behavior OF Moore_FSM IS
	TYPE state_type IS (S0, S1, S2, S3, S4);
	SIGNAL Moore_state: state_type;
	BEGIN
    
	U_MOORE: PROCESS
    BEGIN
    	WAIT UNTIL CLK'EVENT AND CLK = '1';
        	IF RST = '1' THEN
				Moore_state <= S0;
			ELSE
            	CASE Moore_state IS
            		WHEN S0 =>
                    	IF A = '0' AND B = '0' THEN
                        	Moore_state <= S0;
              			ELSIF A = '0' AND B = '1' THEN
							Moore_state <= S4;
              			ELSIF A = '1' AND B = '0' THEN
							Moore_state <= S1;
              			ELSE
							Moore_state <= S0;
                        END IF;
					WHEN S1 =>
                    	IF A = '0' AND B = '0' THEN
                        	Moore_state <= S1;
              			ELSIF A = '0' AND B = '1' THEN
							Moore_state <= S0;
              			ELSIF A = '1' AND B = '0' THEN
							Moore_state <= S2;
              			ELSE
							Moore_state <= S1;
                        END IF;
            		WHEN S2 =>
                    	IF A = '0' AND B = '0' THEN
                        	Moore_state <= S2;
              			ELSIF A = '0' AND B = '1' THEN
							Moore_state <= S1;
              			ELSIF A = '1' AND B = '0' THEN
							Moore_state <= S3;
              			ELSE
							Moore_state <= S2;
                        END IF;
            		WHEN S3 =>
                    	IF A = '0' AND B = '0' THEN
                        	Moore_state <= S3;
              			ELSIF A = '0' AND B = '1' THEN
							Moore_state <= S2;
              			ELSIF A = '1' AND B = '0' THEN
							Moore_state <= S4;
              			ELSE
							Moore_state <= S3;
                        END IF;
					WHEN S4 =>
                    	IF A = '0' AND B = '0' THEN
                        	Moore_state <= S4;
              			ELSIF A = '0' AND B = '1' THEN
							Moore_state <= S3;
              			ELSIF A = '1' AND B = '0' THEN
							Moore_state <= S0;
              			ELSE
							Moore_state <= S4;
                        END IF;
				END CASE;    	
			END IF;     
    END PROCESS;
    
    Control <= 
						"110" when Moore_state = S0 else
						"101" when Moore_state = S1 else
						"000" when Moore_state = S2 else
						"010" when Moore_state = S3 else
						"110" when Moore_state = S4;

END behavior;
