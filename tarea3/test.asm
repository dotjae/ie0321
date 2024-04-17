

.data

    insert_M: .asciiz "Ingrese el numero M: "
    insert_N: .asciiz "Ingrese el numero N: "
    Error: .asciiz " \n\n       ERROR: El número ingresado debe ser mayor que 0. \n"
    newLine: .asciiz "\n\n"

    epsilon: .float 1e-3
    half: .float 0.5
    


.text
    main:
        # Ask for first number.
		li $v0, 4
		la $a0, insert_M
		syscall
		li $v0, 5
		syscall
		addi $s0, $v0, 0
		
		# Check if number is greater than 0.
		slti $t0, $s0, 1 # if $s0 < 1, $t0 = 1; else $t0 = 0
		bne $t0, $0, error # if $t0 != 0 ($s0 < 1), jump to 'error'

         # Ask for first number.
		# li $v0, 4
		# la $a0, insert_N
		# syscall
		# li $v0, 5
		# syscall
		# addi $s1, $v0, 0
		
		# # Check if number is greater than 0.
		# slti $t0, $s1, 1 # if $s0 < 1, $t0 = 1; else $t0 = 0
		# bne $t0, $0, error # if $t0 != 0 ($s0 < 1), jump to 'error'

        add $a0, $s0, $0
        # add $a1 $s1 $0

        jal sqrt

        # add $a0 $a1 $0

        # jal prime

        addi $a0 $v0 0
        li $v0 1
        syscall
       



        j end

        error:
            la $a0, Error
            li $v0, 4
            syscall

        end:    
            li $v0, 10
            syscall



    tortoise_pair:

        addi $t0 $a0 0
        addi $t1 $a1 0

        addi $sp $sp -4
        sw $ra 0($sp)

        addi $a0 $t0 0 
        jal is_prime # is M prime?
        addi $t8 $v0 0 

        lw $ra 0($sp)
        addi $sp $sp 4

        addi $sp $sp -4
        sw $ra 0($sp)

        add $a0 $t0 $t1
        jal is_prime # is M + N prime?
        addi $t9 $v0 0

        lw $ra 0($sp)
        addi $sp $sp 4

        beq $t8 $0 not_tortoise
        beq $t9 $0 not_tortoise

        addi $v0 $0 1 # M,N are a tortoise pair
        jr $ra

        not_tortoise:
            addi $v0 $0 0
            jr $ra


    is_prime:
    
        addi $t0 $a0 0 # N -> $t0
        addi $t1 $0 2 # i = 2 -> $t1

        addi $sp $sp -4
        sw $ra 0($sp)

        jal sqrt

        lw $ra 0($sp)
        addi $sp $sp 4

        addi $t8 $v0 0 # sqrt(N) -> $t8

        prime_loop:

            slt $t7 $t1 $t8 # if i < sqrt(N), $t7 = 1
            beq $t7 $0 prime # if i >= sqrt(N), jump to prime
            div $t0 $t1 # M / i
            mfhi $t2 # mod(M, i) -> $t2

            # addi $a0 $t2 0
            # li $v0 1
            # syscall

            beq $t2 $0 not_prime # if mod(M,i) == 0, jump to not_prime

            addi $t1 $t1 1 # i++
            j prime_loop


            prime:
                addi $v0 $0 1 # N is prime

                add $a0 $v0 $0 # is_prime(N) -> $a0
                # li $v0 1
                syscall
                jr $ra

            not_prime:
                addi $v0 $0 0 # N is not prime
                add $a0 $0 $0 # is_prime(N) -> $a0
                li $v0 1
                syscall

                addi $v0 $0 0
                jr $ra

    sqrt:  
        
        mtc1 $a0, $f0         
        mtc1 $a0, $f1        # hi = n -> $f1
        mtc1 $0, $f2         # lo = 0 -> $f2
        lwc1 $f3, epsilon    # epsilon = 1e-3 -> $f3

        cvt.s.w $f0, $f0
        cvt.s.w $f1, $f1
        cvt.s.w $f2, $f2

        loop:
            add.s $f4, $f1, $f2       # guess = hi + lo -> $f4
            lwc1 $f5, half
            mul.s $f4, $f4, $f5       # guess /= 2

            mul.s $f6, $f4, $f4       # guess_sqrd = guess * guess -> $f6

            c.lt.s $f0, $f6       # if $a0 < guess_sqrd, set
            bc1t isLessThan 
            
            # else:
            mov.s $f2, $f4       # lo = guess
            j Check

            j END
            
            isLessThan:
                mov.s $f1, $f4 # hi = guess
                j Check

            Check:
                sub.s $f7, $f1, $f2       # hi - lo -> $f7
                c.lt.s $f7, $f3          # if (hi-lo) < epsilon, break loop
                bc1t END

                j loop

            END:

            # mov.s $f12 $f4
            # add.s $f12, $f4, $f3
            # li $v0, 2 
            # syscall

            # la $a0, newLine
            # li $v0, 4
            # syscall
        
            # mov.s $f12, $f6
            # li $v0, 2 
            # syscall

            # addi $t0 $0 1
            # div $f4 $t0
            # mflo $t9


            cvt.w.s $f4, $f4      # Convert the number in $f1 to an integer
            mfc1 $t0, $f4  

            addi $v0 $t0 0 # guess -> $v0 

            jr $ra