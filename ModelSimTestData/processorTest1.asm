
# _0_ nop (ALU funct = 0x0)
# _1_ mfhi (ALU funct = 0x10)
# _1_ mthi (ALU funct = 0x11)
# _1_ mflo (ALU funct = 0x12)
# _1_ mtlo (ALU funct = 0x13)
# _1_ mult (ALU funct = 0x18)
# _0_ multu (ALU funct = 0x19)
# _1_ div (ALU funct = 0x1a)
# _0_ divu (ALU funct = 0x1b)
# _1_ add (ALU funct = 0x20)
# _1_ addu (ALU funct = 0x21)
# _1_ sub (ALU funct = 0x22)
# _1_ subu (ALU funct = 0x23)
# _1_ and (ALU funct = 0x24)
# _0_ move (ALU funct = 0x25)
# _1_ or (ALU funct = 0x25)
# _1_ xor (ALU funct = 0x26)
# _1_ nor (ALU funct = 0x27)
# _1_ slt (ALU funct = 0x2a)
# _1_ sltu (ALU funct = 0x2b)
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
# _1_ li (ALU funct = 0x3f)
# _1_ slti (ALU funct = 0x24)
# _1_ sltiu (ALU funct = 0x24)
# _1_ andi (ALU funct = 0x24)
# _1_ ori (ALU funct = 0x24)
# _1_ xori (ALU funct = 0x24)
# _1_ lui (ALU funct = 0x0)

.data
  namePrompt: .asciiz "Please enter your name: "
  nameStorage: .space 40

.text
	j first
	first:

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
	li $t0, 0xFFFF # -1
	li $t1, 0x00FF # 255
	li $t2, 0xFF00 # -256
	addu $s0, $t1, $t2
	subu $s1, $t0, $t1
	addiu $s2, $t1, 0x7F00
	addiu $s3, $t0, 0x7FFF
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
	li $t3, 0x7FFF
	li $t4, 0xFFFF # 65535
	li $t5, 0x8000 # Largest negative 16 bit number
	li $t6, 0x8001 # Almost largest negative 16 bit number

	# $t7 = -1
	lui $t7, 0xFFFF
	ori $t7, $t7, 0xFFFF

	mult $t0, $t1
	mflo $s0
	mult $t2, $t3
	mflo $s1
	mult $t7, $t1 # 0xFFFFFFFF_FFFFFFFD
	mflo $s2
	mfhi $s3
	mult $t5, $t3 # 0x3FFF8000
	mflo $s4
	mult $t6, $t4 # 0x80007FFF
	mflo $s5

	
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

	# Division
	li $t0, 100
	li $t1, 3
	li $t2, 10
	li $t3, 128
	li $t4, 2
	addi $t5, $0, -3

	div  $t0, $t2 # 10
	mflo $s0
	mfhi $s1
	li $t0, 100
	div $t0, $t1 # 33
	mflo $s2
	mfhi $s3
	li $t0, 100
	div $t0, $t5 # -33
	mflo $s4
	mfhi $s5

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

	# Bitwise (and, or, xor, andi, ori, xori)

	li $t0, 0xCCCC
	li $t1, 0x3333
	li $t2, 0xFFFF

	and $s0, $t0, $t1
	and $s1, $t1, $t2
	or  $s2, $t0, $t1
	xor $s3, $t2, $t1
	andi $s4, $t0, 0xFFFF
	ori $s5, $t1, 0x4444
	xori $s6, $t2, 0x1111
	nor $s7, $t0, $t1
	

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

	# LO and HI

	lui $t0, 0xABCD
	ori $t0, $t0, 0xEF12
	
	lui $t1, 0xFFFF
	ori $t1, $t1, 0xFFFF

	mthi $t1
	mtlo $t0

	mfhi $s1
	mflo $s0

	sw $s0, 0($a0)
		addi $a0, $a0, 4
	sw $s1, 0($a0)
		addi $a0, $a0, 4


	# SLT
	
	li $t0, -1
	li $t1, 1
	li $t2, 2
	
	slt $s0, $t0, $t1
	slt $s1, $0, $t0
	slt $s2, $0, $t1
	sltu $s3, $t1, $t0
	slti $s4, $t2, 3 
	slti $s5, $t2, -1 
	sltiu $s6, $t2, -1

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
	

	# Loop forever so things don't break.
	section1:
	b section1



