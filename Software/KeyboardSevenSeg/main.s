# This is a stub for an assembly program.

.data

.text
	li $t0, 0
	nop
	j first
	nop
	nop
	nop
	nop
	first:
	

	# Load the test data onto the 7 segment display.
	li $s8, 255
	lui $t2, 0xABCD
	ori $t2, $t2, 4660 # 1234 in base 10
	sw $t2, 0($s8)

	# Wait for keyboard presses
	# Don't enter the loop until up is pressed
	li $t0, 0
	waitForUp:
		lw $t0, 0xC1($0)
		nop
		beq $0, $t0, waitForUp

	# ascii_up = 8'hC1
	# ascii_down = 8'hC2
	# ascii_right = 8'hC3
	# ascii_left = 8'hB4
	li $s0, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	loop1:
		# Put the counter ($s0) in the display
		sw $s0, 0($s8)		
		
		# Get the arrow keys
		lw $t3, 0xC1($0)
		lw $t4, 0xC2($0)
		lw $t5, 0xC3($0)
		lw $t6, 0xB4($0)
		# The compiler rearranges my commands so I put an extra nop.
		nop
		nop
		
		# Check if the key changed vs the flag
		bne $s3, $t3, newUpKey
		nop
		# Key is in same state
		li $t0, 0
		j continue1
		nop
		nop
		
		newUpKey:
		# Save the current state of the up key
		move $s3, $t3
		# Only count if the key changed to a 1
		andi $t0, $t3, 1
		j continue1
		nop
		nop

		continue1:
		add $s0, $t0, $s0




		# Check if the key changed vs the flag
		bne $s4, $t4, newUpKey2
		nop
		# Key is in same state
		li $t0, 0
		j continue2
		nop
		nop
		
		newUpKey2:
		# Save the current state of the up key
		move $s4, $t4
		# Only count if the key changed to a 1
		andi $t0, $t4, 1
		j continue2
		nop
		nop

		continue2:
		sub $s0, $s0, $t0
		


		# Right arrow key adds as long as its held.		
		add $s0, $t5, $s0
		# Left arrow decrements
		sub $s0, $s0, $t6

		# Reset? (r key)
		lw $t3, 0x72($0)
		nop
		nop
		beq $t3, $0, continue3
		nop
		li $s0, 0				

		continue3:
		j loop1
		

	# Loop forever
	last:
	j last
	nop
