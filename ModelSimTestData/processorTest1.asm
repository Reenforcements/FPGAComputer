
# _0_ nop (ALU funct = 0x0)
# _0_ mfhi (ALU funct = 0x10)
# _0_ mthi (ALU funct = 0x11)
# _0_ mflo (ALU funct = 0x12)
# _0_ mtlo (ALU funct = 0x13)
# _1_ mult (ALU funct = 0x18)
# _0_ multu (ALU funct = 0x19)
# _1_ div (ALU funct = 0x1a)
# _0_ divu (ALU funct = 0x1b)
# _1_ add (ALU funct = 0x20)
# _1_ addu (ALU funct = 0x21)
# _1_ sub (ALU funct = 0x22)
# _1_ subu (ALU funct = 0x23)
# _0_ and (ALU funct = 0x24)
# _0_ move (ALU funct = 0x25)
# _0_ or (ALU funct = 0x25)
# _0_ xor (ALU funct = 0x26)
# _0_ nor (ALU funct = 0x27)
# _0_ slt (ALU funct = 0x2a)
# _0_ sltu (ALU funct = 0x2b)
# _0_ sllv (ALU funct = 0x4)
# _0_ srlv (ALU funct = 0x6)
# _0_ srav (ALU funct = 0x7)
# _0_ jr (ALU funct = 0x8)
# _0_ jalr (ALU funct = 0x9)
# _0_ break (ALU funct = 0xd)
# _0_ bgez (ALU funct = 0x1)
# _0_ bltz (ALU funct = 0x3b)
# _0_ bltzal (ALU funct = 0x3d)
# _0_ bgezal (ALU funct = 0x3f)
# _0_ mfc1 (ALU funct = 0x0)
# _0_ mtc1 (ALU funct = 0x0)
# _0_ bc1f (ALU funct = 0x8)
# _0_ bc1t (ALU funct = 0xa)
# _0_ lb (ALU funct = 0xc)
# _0_ lh (ALU funct = 0xc)
# _0_ lwl (ALU funct = 0xc)
# _0_ lw (ALU funct = 0xc)
# _0_ lbu (ALU funct = 0xc)
# _0_ lhu (ALU funct = 0xc)
# _0_ lwr (ALU funct = 0xc)
# _0_ sb (ALU funct = 0xc)
# _0_ sh (ALU funct = 0xc)
# _0_ swl (ALU funct = 0xc)
# _0_ sw (ALU funct = 0x4)
# _0_ swr (ALU funct = 0xc)
# _0_ lwc1 (ALU funct = 0xc)
# _0_ swc1 (ALU funct = 0xc)
# _0_ beq (ALU funct = 0x3)
# _0_ b (ALU funct = 0x33)
# _0_ bnez (ALU funct = 0x2)
# _0_ bne (ALU funct = 0x4)
# _0_ blez (ALU funct = 0x37)
# _0_ bgtz (ALU funct = 0x39)
# _1_ addi (ALU funct = 0x24)
# _1_ addiu (ALU funct = 0x38)
# _0_ li (ALU funct = 0x3f)
# _0_ slti (ALU funct = 0x24)
# _0_ sltiu (ALU funct = 0x24)
# _0_ andi (ALU funct = 0x24)
# _0_ ori (ALU funct = 0x24)
# _0_ xori (ALU funct = 0x24)
# _0_ lui (ALU funct = 0x0)

.text
	# Base address for saving results
	li $a0, 20000



	# Basic arithmetic 
	li $t0, 200
	li $t1, 7
	add $s0, $t1, $t0
	sub $s1, $t0, $t1
	addi $s2, $t0, 123
	addi $s3, $t0, -123
	# Save results
	sw $s0, 0($a0)
		addi $a0, $a0, 4
	sw $s1, 0($a0)
		addi $a0, $a0, 4
	sw $s2, 0($a0)
		addi $a0, $a0, 4
	sw $s3, 0($a0)
		addi $a0, $a0, 4

	# Basic arithmetic (unsigned)
	li $t0, 0xFFFF
	li $t1, 0x00FF
	li $t2, 0xFF00
	addu $s0, $t1, $t2
	subu $s1, $t0, $t1
	addiu $s2, $t1, 0xFF00
	addiu $s3, $t0, 0xFFFF
	# Save results
	sw $s0, 0($a0)
		addi $a0, $a0, 4
	sw $s1, 0($a0)
		addi $a0, $a0, 4
	sw $s2, 0($a0)
		addi $a0, $a0, 4
	sw $s3, 0($a0)
		addi $a0, $a0, 4

	# Multiplication
	li $t0, 20
	li $t1, 3
	li $t2, 1
	li $t3, 0x7FFF # Largest positive 16 bit number
	li $t4, 0xFFFF # -1
	li $t5, 0x8000 # Largest negative 16 bit number
	li $t6, 0x8001 # Almost largest negative 16 bit number
	mult $t0, $t1
	mflo $s0
	mult $t2, $t3
	mflo $s1
	mult $t3, $t1 # 0x0001_7FFD
	mflo $s2
	mfhi $s3
	mult $t5, $t3 # 0x3FFF8000
	mflo $s4
	mfhi $s5
	mult $t6, $t4 # 0x80007FFF
	mflo $s6
	mfhi $s7
	
	sw $s0, 0($a0)
		addi $a0, $a0, 4
	sw $s1, 0($a0)
		addi $a0, $a0, 4
	sw $s2, 0($a0)
		addi $a0, $a0, 4
	sw $s3, 0($a0)
		addi $a0, $a0, 4
	sw $s4, 0($a0)
		addi $a0, $a0, 4
	sw $s5, 0($a0)
		addi $a0, $a0, 4
	sw $s6, 0($a0)
		addi $a0, $a0, 4
	sw $s7, 0($a0)
		addi $a0, $a0, 4

	# Division
	li $t0, 100
	li $t1, 3
	li $t2, 10
	li $t3, 128
	li $t4, 2
	li $t4, -3

	div $t0, $t2 # 10
	mflo $s0
	div $t0, $t1 # 33
	mflo $s1
	div $t0, $t4 # -33
	mflo $s2

	sw $s0, 0($a0)
		addi $a0, $a0, 4
	sw $s1, 0($a0)
		addi $a0, $a0, 4
	sw $s2, 0($a0)
		addi $a0, $a0, 4




