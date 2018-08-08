from PIL import Image
testImage = Image.open("testImage1.png")
width, height = testImage.size
currentLine = ""
with open("./testImage.txt", "w") as f:

	for y in range(0, height):
		for x in range(0, width):
			pixel = testImage.getpixel((x,y))
			toBeHex = 0b00010000 if pixel[0] > 128 else 0
			toBeHex |= 0b00000100 if pixel[1] > 128 else 0
			toBeHex |= 0b00000001 if pixel[2] > 128 else 0
			addition = "{:02x}".format(toBeHex)
			currentLine = addition + currentLine
			if len(currentLine) == 8:
				f.write(currentLine)
				f.write("\n")
				currentLine = ""


