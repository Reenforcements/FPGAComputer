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
	char *hKey = (char*) 0x68;

	// Hardware counters
	int *milliCounter = (int*) 267;
	int *microCounter = (int*) 271;

	unsigned int counter = 0;
	unsigned char currentColor = 0;
	unsigned int lastSecond = 0;

	// Render some test images until an arrow keypress is detected.
	unsigned int currentTime = 0xFFFFFFFF;
	unsigned int render1 = 0;
	unsigned int render2 = 0;
	unsigned int reset1 = 0;
	while (1) {
		currentTime = *milliCounter;

		if ((*matrix_settings & 1) != 0)
			continue;

		if (currentTime < render1) {
			// Render an all red screen
			for (int i = 0; i < 4096; i++) {
				*(vram + i) = 0b00010000;
			}
			*matrix_settings = 1;
		}
		else if (currentTime >= render1 && currentTime < render2) {
			// Render an all light blue screen
			for (int i = 0; i < 4096; i++) {
				*(vram + i) = 0b00000111;
			}
			*matrix_settings = 1;
		}
		else if (currentTime >= render2 && currentTime < reset1) {
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
		}
		else if (currentTime >= reset1) {
			render1 = currentTime + 1000;
			render2 = currentTime + 2000;
			reset1 = currentTime + 3000;
		}

		// Show the number of seconds onscreen
		*segmentedDisplay = (*milliCounter / 1000);

		// Leave this loop if any arrow key is pressed.
		if (*upArrow != 0 || *downArrow != 0 || *leftArrow != 0 || *rightArrow != 0)
			break;
	}

	// Box position
	int b_x = 32;
	int b_y = 32;
	unsigned int lastDisplayTime = *milliCounter;
	unsigned int lastMoveTime = *milliCounter;
	while(1) {
		// Get the arrow keys.
		int xMod = (*leftArrow != 0 ? -1 : 0) + (*rightArrow != 0 ? 1 : 0);
		int yMod = (*downArrow != 0 ? 1 : 0) + (*upArrow != 0 ? -1 : 0);

		// Only move the box if a little time has passed.
		if ((*milliCounter) > lastMoveTime + 33) {
			lastMoveTime = *milliCounter;
			b_x += xMod;
			b_y += yMod;
		}

		// Don't write anything until the buffers actually switch
		if ((*matrix_settings & 1) == 0) {
			if ((*hKey) != 1) {
				// Clear the display.
				for (int i = 0; i < 4096; i++) {
					*(vram + i) = 0b00000001;
				}	
			}
	
			// Draw an 8x8 box.
			for (int x = -1; x <= 1; x++) {
				for (int y = -1; y <= 1; y++) {
					int currentX = b_x + x;
					int currentY = b_y + y;
					if (currentX >= 0 && currentX < 64 && currentY >= 0 && currentY < 64) {
						*(vram + currentX + (64 * currentY)) = (((*milliCounter / 1000)) % 2 != 0) ? 0b00001100 : 0b00010000;
					}
				}
			}
			
			*matrix_settings = 1;
		}


		// Show the number of seconds onscreen
		*segmentedDisplay = (*milliCounter);
	}
}




