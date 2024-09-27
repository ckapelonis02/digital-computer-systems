.data

	# For this program we will be using registers $t0-$t4 and $t6-$t7 directly:
	# $t0 will hold the address of the memory in which we will store user's character (used in first loop)
	# $t1 will hold the value of endCharacter 
	# $t2 will hold the address of userString
	# $t3 will be the iterator (used in first loop)
	# $t4 will hold temporarily a character before we store it in memory (used in first loop)
	# $t6 will be the iterator (used in second loop)
	# $t7 will hold the address of the memory from which we will load user's character saved in memory (used in second loop)


	# some strings we will be using for the user interaction
	ourMessage: .asciiz "\nPlease Enter your character:\n"
	finalMessage: .asciiz "\nYour string:\n"
	
	# character which, when given by the user, program ends/ can change this to any character you want
	endCharacter: .byte '@'
	
	# we need 2^0 = 1 align because we will be storing bytes
	.align 0
	
	# 100 bytes for user's character in memory
	userString: .space 100
	
	
.text

	main:
	
	# loads endCharacter in register $t1
	lb $t1, endCharacter
	
	# loads userString's address in register $t2
	la $t2, userString
	
	# clears registers $t3 and $t0
	move $t3, $0
	move $t0, $0

	# loop starts here
	# when we exit this loop we will have stored every character the user gave us in memory
	userInteractionLoop:
	
		# asks user to enter a character
		li $v0, 4
		la $a0, ourMessage
		syscall
				
		# reads user's character
		li $v0, 12
		syscall
		
		# uses $t4 register to temporarily hold user's character
		move $t4, $v0 
		
	beq $t4, $t1, exitUserLoop # checks if userCharacter == '@'
		# stores byte in (&userString + i*1) address
		add $t0, $t2, $t3
		sb $t4, 0($t0)
		
		# i++
		addi $t3, $t3, 1

		j userInteractionLoop # jump to label so that the program asks for a character again
		
	exitUserLoop: # exit label
	
	
	# displays message before printing user's characters
	li $v0, 4
	la $a0, finalMessage
	syscall

	# prepares system to print character
	li $v0, 11
	
	# clears registers $t6 and $t7
	move $t6, $0
	move $t7, $0
	
	# loop starts here
	# when we exit this loop we will have printed every user's character
	printCharacterLoop:

	beq $t6, $t3, exitPrintLoop # checks if i == j
		# loads byte from (&userString + j*1) address
		add $t7, $t2, $t6
		lb $a0, 0($t7)
		
		# calls system so that it prints a character
		syscall
		
		# j++
		addi $t6, $t6, 1
		
		j printCharacterLoop # jump to label so that the program prints a character again
		
	exitPrintLoop: # exit label
	
	# terminates program
	li $v0, 10
	syscall