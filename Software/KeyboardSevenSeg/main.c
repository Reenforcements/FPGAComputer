/*
Program description:

Increment a counter once when the up arrow is pressed.
Decrement a counter once when the down arrow is press.
If either shift is held, increment or decrement the counter as long as
  either up/down key is held.

Display the counter on the seven segment displays.

*/
void delay(unsigned int amount) {
	for(unsigned int i = 0; i < amount; i++)  {
		// Prevents GCC from optimizing this for loop away.
		asm("");
	}
}
void main() {
	int *readback = (int*)20000;
	*(readback) = 1234;

	// 256 is the address of the 7 segment display register.
	int *segmentedDisplay = (int *)255;

	// The locations of the keys we're interested in.
	int *upArrow = (int*) 0xC1;
	char *downArrow = (char*) 0xC2;
	char *shift = (char*) 0xCB;

	*segmentedDisplay = 0x27777777;

	unsigned int counter = 0;
	while(1) {
		*segmentedDisplay = counter;
		counter+=3;
		
		asm("li $t0, 10000 \n"
			"sw $s8, 0($t0)\n"
			"sw $sp, 4($t0)\n"
			"sw $gp, 8($t0)\n"
			);
		/*
		if ((*upArrow) == 1) {
			*segmentedDisplay = counter;
			counter++;
		}*/
	}
}
