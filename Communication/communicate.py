# This program sends/receives individual commands to/from the processor.

import sys
import serial
from argparse import *
import struct
import time

commands = {
"NOP":0,
"INFO":1,
"UPLOAD":2,
"DOWNLOAD":3,
"FORCE_RST_HIGH":4,
"FORCE_RST_LOW":5
}

parser = ArgumentParser(description="Communicate with the processor uploaded to the FPGA through RS232 serial.")
parser.add_argument("command", nargs=1, choices=commands.keys(), action='store')
parser.add_argument("-i", dest="input", nargs="?", default="input.txt", action='store')
parser.add_argument("-o", dest="output", nargs="?", default="output.txt", action='store')
parser.add_argument("-startAddress", type=int, dest="startAddress", nargs="?", default=1024, action='store')
parser.add_argument("-endAddress", type=int, dest="endAddress", nargs="?", default=65532, action='store')

args = parser.parse_args()
command = args.command[0]

s = serial.Serial("/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AH063CIS-if00-port0", baudrate=250000, parity=serial.PARITY_NONE, rtscts=False, bytesize=serial.EIGHTBITS, timeout=2, stopbits=1)

def sendInt(i):
	packed = struct.pack(">I", i)
	#print("{:02x} {:02x}  {:02x} {:02x}".format(ord(packed[0]), ord(packed[1]), ord(packed[2]), ord(packed[3])) )
	s.write(packed)

def readLength():
	lenBytes = s.read(4)
	if len(lenBytes) != 4:
		print("Problem reading length of command. Didn't get four bytes.")
		sys.exit(0)
	unpacked = struct.unpack(">I", lenBytes)[0]
	return unpacked

if s.is_open == False:
	print("Couldn't connect to processor.")
	sys.exit(0)

if command == "NOP":
	None
if command == "INFO":
	print("Getting device info...");
	# Pack the command length as a big endian unsigned int (4 bytes)
	sendInt(0x00000000)
	# Pack the command as a big endian unsigned int (4 bytes)
	sendInt(commands[command])
	# We don't send anything else. We just receive an info string and print it.
	commandLength = readLength() * 4
	print("({} characters)".format(commandLength))
	info = s.read(commandLength)
	#print("Received: {} bytes".format(len(info)))
	print(info)
if command == "UPLOAD":
	with open(args.input, "r") as f:
		lines = []
		for line in f:
			lines.append(line)

		# Command length / command
		sendInt(0x00000000)
		sendInt(commands[command])

		# start/end addresses
		startAddress = 1024
		endAddress = startAddress + (4*len(lines))
		print("Start and end addresses: {} to {}".format(startAddress, endAddress))
		sendInt(startAddress)
		sendInt(endAddress)

		# data
		totalSent = 0
		toSend = (endAddress - startAddress)/4
		print("Preparing to upload {} words of data...".format(toSend))
		while totalSent < toSend:
			sendInt( int(lines[totalSent], 16) )
			if s.out_waiting > 2000:
				time.sleep(0.02)
			totalSent += 1
			if totalSent % (toSend / 10) == 0:
				sys.stdout.write("|")
				sys.stdout.flush()
		print("")
		print("Done uploading.")

if command == "DOWNLOAD":
	# Command length / command
	sendInt(0x00000000)
	sendInt(commands[command])

	startAddress = args.startAddress
	endAddress = args.endAddress
	print(startAddress)
	print(endAddress)

	sendInt(startAddress)
	sendInt(endAddress)

	currentWord = 0
	total = endAddress - startAddress
	word = [0,0,0,0]
	while currentWord < total:
		curByte = 0
		while curByte < 4:
			word[curByte] = s.read(1)
			curByte += 1
		print("{:08x}".format( struct.unpack(">I", "".join(word))[0]  ))
		currentWord = currentWord + 4

s.close()
sys.exit(0)



