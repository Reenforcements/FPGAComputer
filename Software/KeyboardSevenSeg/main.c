/*
Program description:

Increment a counter once when the up arrow is pressed.
Decrement a counter once when the down arrow is press.
Increment/decrement the counter as long as the right/left arrow key is held.
Press r to reset the counter.

Display the counter on the first four digits of the 7 segment display.
Display which keys are pressed on the last four digits. 
The letters A, B, C, D are assigned to each key.

*/
void main() {
	int *readback = (int*)20000;
	*(readback) = 1234;

	// 256 is the address of the 7 segment display register.
	int *segmentedDisplay = (int *)255;


	// The locations of the keys we're charerested in.
	// ascii_up = 8'hC1
	// ascii_down = 8'hC2
	// ascii_right = 8'hC3
	// ascii_left = 8'hB4
	char *upArrow = (char*) 0xC1;
	char *downArrow = (char*) 0xC2;
	char *rightArrow = (char*) 0xC3;
	char *leftArrow = (char*) 0xB4;
	char *rKey = (char*) 0x72;
	char *shift = (char*) 0xCB;

	*segmentedDisplay = 0xABCDEF12;

	unsigned int counter = 0;
	char upArrowPressed = 0;
	char downArrowPressed = 0;
	char *upArrowPressed_Specific = (char*) 64000;
	*upArrowPressed_Specific = 0;
	char *downArrowPressed_Specific = (char*) 64004;
	*downArrowPressed_Specific = 0;
	while(1) {
	
		if ((*upArrow) == 1) {
			if (upArrowPressed == 0) {
				counter += 1;
			}
			upArrowPressed = 1;
		} else {
			upArrowPressed = 0;
		}

		
		if ((*downArrow) == 1) {
			if (!downArrowPressed) {
				counter += -1;
			}
			downArrowPressed = 1;
		} else {
			downArrowPressed = 0;
		}

		counter += ((*rightArrow) == 1) ? 1 : 0;
		counter += ((*leftArrow) == 1) ? -1 : 0;

		*segmentedDisplay = ((((*upArrow == 1) ? 0xA000 : 0) + ((*downArrow == 1) ? 0x0B00 : 0) + ((*leftArrow == 1) ? 0x00C0 : 0) + ((*rightArrow == 1) ? 0x000D : 0)) << 16) | (0x0000FFFF & counter);

		if ((*rKey) == 1) {
			counter = 0;
		}
		asm("sw $sp, 30000($0)");
		asm("sw $s8, 30004($0)");
	}
}
