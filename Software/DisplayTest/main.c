/*
Program description:

Tests the LED Matrix display.

*/
void main() {
	// This is the video buffer.
	// It starts at address 65536
	//  and ends at address 66560
	//  giving us 1024 words of space
	//  (or 4096 bytes.)
	char *vram = (char*) 65536;

	// Write a "1" to bit "0" to make graphics changes take effect.
	int *matrix_settings = (int*) 275;
	
	// 256 is the address of the 7 segment display register.
	int *segmentedDisplay = (int *)255;

	// The locations of the keys we're charerested in.
	char *upArrow = (char*) 0xC1;
	char *downArrow = (char*) 0xC2;
	char *rightArrow = (char*) 0xC3;
	char *leftArrow = (char*) 0xB4;
	char *rKey = (char*) 0x72;
	char *shift = (char*) 0xCB;

	// Hardware counters
	int *milliCounter = (int*) 267;
	int *microCounter = (int*) 271;

	unsigned int counter = 0;
	unsigned char currentColor = 0;
	unsigned int lastSecond = 0;
	while(1) {
		if (*shift) {
			*segmentedDisplay = *microCounter;
		}
		else {
			*segmentedDisplay = (*milliCounter);
		}
	
		if (currentColor == 0) {
			currentColor = 0b00100000;
		} else {
			if ( (*milliCounter / 1000) > lastSecond) {
				lastSecond = (*milliCounter / 1000);
				currentColor = currentColor >> 1;
			}
		}
		for (int i = 0; i < 4096; i++) {
			*(vram + i) = currentColor;
		}
		*matrix_settings = 1;
	}
}
