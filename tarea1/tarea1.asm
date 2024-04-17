
.data 

    Array: .word -5,-4,-3,-2,-1,1,2,3,4,5,0

    array: .asciiz "Arreglo: \n"
    separator: .asciiz ","
    newLine: .asciiz "\n\n"


.text

    main:

        la $a0 Array
        jal printArray


        la $a0 Array
        jal ReLU


        jal printArray

        li $v0 10
        syscall



    ReLU:

        addi $t0 $0 0       # i = 0 -> $t0 


        loop1:
            sll $t2 $t0 2       # i*4 -> $t2
            add $t2 $a0 $t2     # A + i*4 -> $t2
            lw $t1 0($t2)
            beq $t1 $0 end

            slt $t8 $t1 $0      # $t8 = 1 if A[i] < 0
            bne $t8 $0 Zero

            addi $t0 $t0 1
            j loop1

            Zero:
                addi $t6 $0 0xF
                sw $t6 0($t2)        # A[i] = 0    
                j loop1

            end:
                jr $ra


    printArray:

		add $t0 $0 $0 # i = 0
		add $t1 $a0 $0 # $t1 = $a0
		
		addi $v0 $0 4 # cod.4 -> ptrint string
		la $a0 array
		syscall
		
		loop:
			sll $t2 $t0 2 # $t2 = i*4
			addu $t2 $t2 $t1 # $t2 = A + (i*4)
			
			addi $v0 $0 1 # cod.1 -> print int

			lw $a0 0($t2) # $a0 = A[i]
			syscall
				
			addi $t0 $t0 1 # i++
			beq $a0 $0 printEnd # if A[i]=0, jump to printEnd
				
			addi $v0 $0 4 # cod.4 -> print string
			la $a0 separator # print ","
			syscall 
			
			j loop
			
		printEnd:
			addi $v0 $0 4 # cod.4 -> print string
			la $a0 newLine # print "\n"
			syscall
			
			jr $ra