.data

	# some strings we will be using for the user interaction
	ourMessage: .asciiz "Please Enter your String:\n"
	finalMessage: .asciiz "\nThe Processed String is:\n"
	
	# 100 bytes for unprocessed string in memory and another 100 for the processed one
	unprocessedString: .space 100
	processedString: .space 100
	
.text

	main:

		# calls Get_Input
		jal Get_Input
		
		# calls Process
		jal Process
		
		# calls Get_Output
		jal Get_Output
		
		# terminates program
		ori $v0, $0, 10
		syscall
	
	# asks for string, reads string and stores in memory
	Get_Input:
	
		# asks user to enter a string
		ori $v0, $0, 4
		la $a0, ourMessage
		syscall
	
		# reads user's string
		ori $v0, $0, 8
		la $a0, unprocessedString
		ori $a1, $0 100
		syscall
		
		jr $ra
	
	# processes the string by:
	# 1) getting rid of anything that isn't letter, space character or number
	# 2) capital letters to small
	# 3) small letters, numbers and space characters stay as they are
	# then proceeds to store the processed string in an other space in memory
	Process:
	
		# loads unprocessedString's address in $t1 register
		la $t1, unprocessedString
		
		# loads processedString's address in $t2 register
		la $t2, processedString
		
		# loop starts here
		processLoop:
			
				# loads byte from corresponding address
				lb $t3, 0($t1)
				
				# end of string
				beq $t3, '\n' exitProcessLoop
					
					# $t1 + 1
					addi $t1, 1
					
					# is the character the space character?
					beq $t3, ' ' skipAddition
					
					# is it to be ignored?
					slti $t7, $t3, '0'
					bne $t7, $0 processLoop
					
					# is it number?
					slti $t7, $t3, ':'
					bne $t7, $0 skipAddition
					
					# is it to be ignored?
					slti $t7, $t3, 'A'
					bne $t7, $0 processLoop					
					
					# is it capital letter?
					slti $t7, $t3, '['
					bne $t7, $0 addition
					
					# is it to be ignored?
					slti $t7, $t3, 'a'
					bne $t7, $0 processLoop
					
					# is it small letter?
					slti $t7, $t3, '{'
					bne $t7, $0 skipAddition
					
					j processLoop
					
			# helpful label/ used if character is capital letter and ought to be small (so we add 32) (reference to ascii code)
			addition:
			
				addi $t3, $t3, 32
			
			# helpful label/ used to store the final byte
			skipAddition:
			
				# stores byte to corresponding address
				sb $t3, 0($t2)
				
				# $t2 + 1
				addi $t2, $t2, 1

		j processLoop # jumps to label
		
		exitProcessLoop: # exit label
		
		jr $ra
	
	# prints processed string
	Get_Output:
		
		# prints message about output processed string
		ori $v0, $0, 4
		la $a0, finalMessage
		syscall
	
		# prints processed string
		ori $v0, $0, 4
		la $a0, processedString
		syscall
		
		jr $ra