import sys
import serial
from argparse import *
import struct

commands = {
"NOP":0,
"INFO":1,
"UPLOAD":2,
"DOWNLOAD":3
}

parser = ArgumentParser(description="Communicate with the processor uploaded to the FPGA through RS232 serial.")
parser.add_argument("command", nargs=1, choices=commands.keys(), action='store')
parser.add_argument("-i", dest="input", nargs="?", default="input.txt", action='store')
parser.add_argument("-o", dest="output", nargs="?", default="output.txt", action='store')

args = parser.parse_args()
command = args.command[0]

s = serial.Serial("/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AH063CIS-if00-port0", baudrate=250000, parity=serial.PARITY_NONE, rtscts=False, bytesize=serial.EIGHTBITS, timeout=2, stopbits=1)

def sendInt(i):
	packed = struct.pack(">I", i)
	print("{:02x} {:02x}  {:02x} {:02x}".format(ord(packed[0]), ord(packed[1]), ord(packed[2]), ord(packed[3])) )
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
	commandLength = readLength()
	print("Length: {}".format(commandLength))
	info = s.read(commandLength)
	print("Received: {} bytes".format(len(info)))
	print(info)



print("Done.")
s.close()
sys.exit(0)



