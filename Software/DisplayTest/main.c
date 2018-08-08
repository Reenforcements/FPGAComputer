/*
Program description:

Tests the LED Matrix display.

*/
void clearScreen() {
	// Working with the screen as words gives us
	//  less control but makes clearing it to black much faster.
	/*int *vramInt = (int *) 65536;
	for (int i = 0; i < 4096; i+=4) {
		*(vramInt + i) = 0;
	}*/
	char *vram = (char*) 65536;
	for (int i = 0; i < 4096; i++) {
		*(vram + i) = 0;
	}
}
void setPixel(int x, int y, unsigned char pixel) {
	// Shift by 6 is the same as multiplying by 64.
	*( (int*) (65536 + x + (y << 6)) ) = pixel;
}
void updateScreen() {
	// Write a "1" to bit "0" to make graphics changes take effect.
	int *matrix_settings = (int*) 275;
	*matrix_settings = 1;
}
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

	// Hardware counters
	int *milliCounter = (int*) 267;
	int *microCounter = (int*) 271;

	unsigned int counter = 0;
	unsigned char currentColor = 0;
	unsigned int lastSecond = 0;


	for (int i = 0; i < 4096; i++) {
		*(vram + i) = 0b00010000;
	}
	*matrix_settings = 1;

	for (int i = 0; i < 2048; i+=64) {
		for(int g = 0; g < 32; g++) {
			*(vram + i + g) = 0b00010000; //r
		}
		for(int g = 32; g < 64; g++) {
			*(vram + i + g) = 0b00000100; //g
		}
	}
	for (int i = 2048; i < 4096; i+=64) {
		for(int g = 0; g < 32; g++) {
			*(vram + i + g) = 0b00000001; //b
		}
		for(int g = 32; g < 64; g++) {
			*(vram + i + g) = 0b00010101; //white
		}
	}
	*matrix_settings = 1;

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
		//for (int i = 0; i < 4096; i++) {
		//	*(vram + i) = 0x00;
		//}
		//for (int i = 0; i < 4096; i++) {
		//	*(vram + i) = 0b00000001;
		//}
		//updateScreen();
		//*matrix_settings = 1;
	}
}
