.data 
	String: .asciiz "()[]{}{{{()}[]}()}"
	string: .asciiz "String: \n\n"
	Valido: .asciiz "\n\nParentesis validos.\n"
	Invalido: .asciiz "\n\nParentesis invalidos.\n"
	
.text
	main:
		# 	Parentheses codes:
		# (: 40; ): 41; [: 91; ]: 93; {: 123; }: 125.
		
		# Save Opening parentheses:
		addi $s1 $0 40
		addi $s2 $0 91
		addi $s3 $0 123
		# Save Closing parentheses:
		addi $s4 $0 41
		addi $s5 $0 93
		addi $s6 $0 125
		
		# Save current stack pointer.
		la $s0 0($sp)
		
		# Print string.
		li $v0 4
		la $a0 string
		syscall
		la $a0 String
		syscall
		
		# Call function.
		jal Parentheses
		
		# Save $v0 in $s7	
		add $s7 $v0 0 
		
		# If $v0 = 0, jump to Invalid
		beq $s7 $0 Invalid 
		
		Valid: # else, print Valid.
		li $v0 4
		la $a0 Valido
		syscall
		j Final
		
		Invalid: # print Invalid.
		li $v0 4
		la $a0 Invalido
		syscall
		
		Final: # Terminate program
		li $v0 10
		syscall 
		
	Parentheses:
		lbu $t0 0($a0) # $t0 = current character
		beq $t0 $0 end # if $t0 = 0, jump to end
		
		# is $t0 an Opening parentheses? Which?
		beq $t0 $s1 Open1
		beq $t0 $s2 Open2
		beq $t0 $s3 Open3
		# is $t0 a Closing parentheses? Which?
		beq $t0 $s4 Close1
		beq $t0 $s5 Close2
		beq $t0 $s6 Close3
		# is $t0 None?
		addi $a0 $a0 1
		j Parentheses # Call function with next character.
		
		# If $t0 is Open, push to stack its opposite pair, then jump to Open.
		Open1: # $t0 = ( ?
			addi $sp $sp -1
			sb $s4 0($sp) 
			j Open
		Open2: # $t0 = [ ?
			addi $sp $sp -1
			sb $s5 0($sp) 
			j Open
		Open3: # $t0 = { ?
			addi $sp $sp -1
			sb $s6 0($sp) 
			j Open
		
		Open: # After pushing to stack, (re)set $v0 to 0 and call function again with next character.
			addi $v0 $0 0
			addi $a0 $a0 1
			j Parentheses
		
		# If $t0 is Close, pop stack and check if they are the same character.
		Close1: # $t0 = ) ?
			lb $t1 0($sp)
			addi $sp $sp 1
			beq $t1 $s4 Same
			j Different
		Close2: # $t0 = ] ?
			lb $t1 0($sp)
			addi $sp $sp 1
			beq $t1 $s5 Same
			j Different
		Close3: # $t0 = } ?
			lb $t1 0($sp)
			addi $sp $sp 1
			beq $t1 $s6 Same
			j Different
			
		# If last item in stack and current char are the same, check if stack is empty.
		Same: 
			beq $sp $s0 EmptyStack # If stack is not empty, call function again with next char.
			addi $a0 $a0 1
			j Parentheses	
		# If last item in stack and current char are NOT the same, exit function and return 0.		
		Different:
			addi $v0 $0 0
			jr $ra
		# If they are the same and stack is empty, all parentheses to this point have been correctly closed.
		EmptyStack:
			addi $a0 $a0 1
			j Parentheses # Continue iterating through string to look for more parentheses.
		
		end: # When finished iterating through string:
			bne $sp $s0 End # if string terminated with stack NOT empty, return 0.
			addi $v0 $0 1 # else, return 1.	
			End:
				jr $ra








