/*
Program description:

Tests the GPIO.

*/
void main() {
	
	// This is the video buffer.
	// It starts at address 65536
	//  and ends at address 66560
	//  giving us 1024 words of space
	//  (or 4096 bytes.)
	char *vram = (char*) 65536;

	// 256 is the address of the 7 segment display register.
	int *segmentedDisplay = (int *)255;

	// Write a "1" to bit "0" to make graphics changes take effect.
	int *matrix_settings = (int*) 275;


	// The locations of the keys we're charerested in.
	char *upArrow = (char*) 0xC1;
	char *downArrow = (char*) 0xC2;
	char *rightArrow = (char*) 0xC3;
	char *leftArrow = (char*) 0xB4;
	char *rKey = (char*) 0x72;
	char *shift = (char*) 0xCB;
	char *hKey = (char*) 0x68;
	char *enterKey = (char*) 0xA;

	// Hardware counters
	int *milliCounter = (int*) 267;
	int *microCounter = (int*) 271;

	unsigned int counter = 0;
	unsigned char currentColor = 0;
	unsigned int lastSecond = 0;
	
	int *gpio_modes = (int*) 279;
	int *gpio_outputs = (int*) 283;
	int *gpio_inputs = (int*) 287;

	*gpio_modes = 0b11110000;

	while (1) {
		*gpio_outputs = ((*milliCounter / 1000) % 2) == 0 ? 0b11110000 : 0;
		*segmentedDisplay = ((*gpio_inputs) & 0b00001000 ? 0x1000 : 0) | ((*gpio_inputs) & 0b00000100 ? 0x0100 : 0) | ((*gpio_inputs) & 0b00000010 ? 0x0010 : 0) | ((*gpio_inputs) & 0b00000001 ? 0x0001 : 0);

		if ((*rKey) == 1)
			break;
	}
	
	// Work in progress
	/*
	int currentPixel = 0;
	int currentBit = 11;
	int lockLocation = 0;
	while (1) {

		if ((*rKey) == 1) {
			// Clear screen and reset
			for (int i = 0; i < 4096; i++) {
				*(vram + i) = 0b00000000;
			}
			currentPixel = 0;
			currentBit = 11;
			lockLocation = 0;
		}

		int c = (1 << currentBit);
		int u = (c << 1);
		int previous = (c << 1);

		// Erase previous
		for (int i = 0; i < previous; i++) {
			*(vram + i) = 0;
		}

		// Try LSb
		for (int i = lockLocation; i < c; i++) {
			*(vram + i) = 0b00110000;
		}
		// Put it on the display.
		*matrix_settings = 1;

		// Wait two render cycles.
		while ((*matrix_settings & 1) != 0) { asm("nop"); }
		*matrix_settings = 1;
		while ((*matrix_settings & 1) != 0) { asm("nop"); }

		if (  ((*gpio_inputs) & 0b00000010) != 0  ) {
			//lockLocation += 0;
			currentBit--;
			continue;
		}

		// Erase previous
		for (int i = 0; i < previous; i++) {
			*(vram + i) = 0;
		}

		// Try MSb
		for (int i = c + lockLocation; i < u; i++) {
			*(vram + i) = 0b00110000;
		}
		// Put it on the display.
		*matrix_settings = 1;

		// Wait two render cycles.
		while ((*matrix_settings & 1) != 0) { asm("nop"); }
		*matrix_settings = 1;
		while ((*matrix_settings & 1) != 0) { asm("nop"); }

		if (  ((*gpio_inputs) & 0b00000010) != 0  ) {
			lockLocation += c;
			currentBit--;
			continue;
		}

		*segmentedDisplay = currentBit;
	}
	*/
}




