.data

	## some strings we will be using for the user interaction
	mainInquireCase1: .asciiz "\nPlease enter the entry number you wish to retrieve:\n"
	mainInquireCase2: .asciiz "\nThere is no such entry in the phonebook.\n"
	promptUserString: .asciiz "\nPlease determine operation, entry (E), inquiry (I) or quit (Q):\n"
	getEntryString: .asciiz "\nThank you, the new entry is the following:\n"
	lNameString: .asciiz "\nEnter last name:\n"
	fNameString: .asciiz "\nEnter first name:\n"
	numberString: .asciiz "\nEnter number:\n"
	


	## we need 2^5 = 32 align because we will be storing registrations fields
	.align 5
		
	## 10 registrations x 3 fields x 10 bytes = 600 bytes
	catalogue: .space  600
	
.text
	
	## REGISTERS used in main function:
	## $gp always will hold the address of the catalogue, space in memory for registrations
	## $s0 will be used this function as a counter referring to the amount of registrations
	## $s1 will be used to store the return value of promptUser function call - in essence it's the choice of the user in each loop
	## some temp registers like $t0 will also be used for temporary values - never crossed with function call 
	## 		which risks the value of the register to change
	main: 
	## catalogue pointer
	la $gp, catalogue
	
	## clears register $s0 which will be used as a counter
	move $s0, $0
	
	## random character initialization
	li $s1, ' '
	
	askingLoop:
		beq $s1, 'q', exitAskingLoop
		beq $s1, 'Q', exitAskingLoop
		
		## calls promptUser and moves return character to $s1
		jal promptUser
		move $s1, $v0
		
		## SWITCH - CASE referring to user's choice
		## entry case 
		beq $s1, 'E', entryCase
		beq $s1, 'e', entryCase
		j nextCase
		entryCase:
			move $a0, $s0
			jal getEntry
			addi $s0, $s0, 1
			j askingLoop
			
		## inquiry case
		nextCase:
		beq $s1, 'I', inqCase
		beq $s1, 'i', inqCase
		j quitCase
		inqCase:
			## asks user to enter a number
			li $v0, 4
			la $a0, mainInquireCase1
			syscall
			
			## reads user's number
			li $v0, 5
			syscall
			
			## inquire loop
			slti $t0, $v0, 1
			bne $t0, $0 exitInqLoop
			slt $t0 $s0, $v0
			bne $t0, $0 exitInqLoop
			
				move $a0, $v0
				
				jal printEntry
				
				j askingLoop
				
			exitInqLoop:
				## no such entry string
				li $v0, 4
				la $a0, mainInquireCase2
				syscall
				j askingLoop
				
		## case quit
		quitCase:
		beq $s1, 'Q', exitAskingLoop
		beq $s1, 'q', exitAskingLoop
		j askingLoop
		
	exitAskingLoop:
		## terminates program
		ori $v0, $0, 10
		syscall
	
		
	## USEFUL FUNCTIONS
	
	## REGISTERS used in promptUser function:
	## no callee save registers will be used in this function
	## only temp regs for syscall etc.
	## user prompt
	promptUser:
		## asks user to enter a character
		li $v0, 4
		la $a0, promptUserString
		syscall
				
		## reads user's character
		li $v0, 12
		syscall
		
		jr $ra
		
	## REGISTERS used in getEntry function:
	## $s0 will be used to store the value of the $a0 argument, that is the index of the catalogue
	## temp regs for syscall, temp values etc.
	## getEntry function
	getEntry:
		addiu $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s0, 4($sp) 
		
		move $s0, $a0
		
		## calls getLastName
		jal getLastName
		
		## calls getFirstName
		move $a0, $s0
		jal getFirstName
		
		## calls getNumber
		move $a0, $s0		
		jal getNumber
		
		## prints message
		li $v0, 4
		la $a0, getEntryString
		syscall
		
		## calls printEntry
		addi $a0, $s0, 1
		jal printEntry
		
		lw $s0, 4($sp) 
		lw $ra, 0($sp)
		addiu $sp, $sp, 8
		jr $ra
	
	## REGISTERS used in getLastName function:
	## $s0 will be used to hold the index of the catalogue
	## temp regs for temp values etc.
	## gets last name
	getLastName:
		addiu $sp, $sp, -4
		sw $s0, 0($sp)
		
		move $s0, $a0
		
		li $v0, 4
		la $a0, lNameString
		syscall
		
		sll $t0, $s0, 5
		add $a0, $gp, $t0
		
		ori $v0, $0, 8
		ori $a1, $0 20
		syscall
		
		
		lw $s0, 0($sp)  
		addiu $sp, $sp, 4
		
		jr $ra
		
	## same logic as getLastName
	## gets first name
	getFirstName:
		addiu $sp, $sp, -4
		sw $s0, 0($sp)
		
		move $s0, $a0
		
		li $v0, 4
		la $a0, fNameString
		syscall
		
		#addi $t0, $0, 1
		#mul $t0, $t0, $s0
		
		sll $t0, $s0, 5
		add $a0, $gp, $t0
		addi $a0, $a0, 20
		
		ori $v0, $0, 8
		ori $a1, $0 20
		syscall
		
		
		lw $s0, 0($sp)  
		addiu $sp, $sp, 4
		
		jr $ra	
		
	## same logic as getLastName
	## gets number
	getNumber:
		addiu $sp, $sp, -4
		sw $s0, 0($sp)
		
		move $s0, $a0
		
		li $v0, 4
		la $a0, numberString
		syscall
		
		sll $t0, $s0, 5
		add $a0, $gp, $t0
		addi $a0, $a0, 40
		
		ori $v0, $0, 8
		ori $a1, $0 20
		syscall
		
		
		lw $s0, 0($sp)  
		addiu $sp, $sp, 4
		
		jr $ra
		
	## REGISTERS used in printEntry function:
	## $s0 will hold the index of the catalogue, then will be used as a pointer to the address of the corresponding registration
	## $s1 is a copy of $s0 for safety reasons
	## also temp regs for temp values, syscall etc.
	## prints a registration
	printEntry:
		addiu $sp, $sp, -8
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		
		addi $s0, $a0, -1
		
		## prints index 
		li $v0, 1
		syscall
		
		## prints dot
		li $v0, 11
		li $a0, '.'
		syscall	
		
		## prints space
		li $v0, 11
		li $a0, ' '
		syscall
	
		## finds address of last name
		sll $s0, $s0, 5
		add $s0, $gp, $s0	
		
		## prints last name until it finds \n
		move $s1, $s0
		myLoop1:
			li $v0, 11
			lbu $a0, 0($s1)
			beq $a0, 10, exitMyLoop1
			syscall
			addi $s1, $s1, 1
			j myLoop1
		exitMyLoop1:

		## prints space
		li $v0, 11
		li $a0, ' '
		syscall
		
		## prints first name until it finds \n		
		move $s1, $s0
		myLoop2:
			li $v0, 11
			lbu $a0, 20($s1)
			beq $a0, 10, exitMyLoop2
			syscall
			addi $s1, $s1, 1
			j myLoop2
		exitMyLoop2:
		
		## prints space
		li $v0, 11
		li $a0, ' '
		syscall
		
		## prints number until it finds \n
		move $s1, $s0
		myLoop3:
			li $v0, 11
			lbu $a0, 40($s1)
			beq $a0, 10, exitMyLoop3
			syscall
			addi $s1, $s1, 1
			j myLoop3
		exitMyLoop3:
				
		
		lw $s0, 0($sp)
		lw $s1, 4($sp) 		
		addiu $sp, $sp, 8
		
		jr $ra
