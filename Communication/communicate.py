import sys
import serial

s = serial.Serial("/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AH063CIS-if00-port0", baudrate=250000, parity=serial.PARITY_NONE, rtscts=False, bytesize=serial.EIGHTBITS, timeout=1, stopbits=1)

if s.is_open == False:
	print("Couldn't connect to processor.")
	sys.exit(0)


commands = {
0:"NOP",
1:"INFO",
2:"UPLOAD",
3:"DOWNLOAD"
}

print("Done.")
s.close()
