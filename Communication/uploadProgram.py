# This program uploads and runs a program on the processor.
import sys
from argparse import *
import subprocess
import struct

parser = ArgumentParser(description="Upload a program.")
formats = ["raw", "hexString"]
parser.add_argument("format", nargs=1, choices=formats, action='store')
parser.add_argument("-i", dest="inputFile",type=str, nargs="?", action='store')

args = parser.parse_args()
inputFormat = args.format[0]
inputFile = args.inputFile

if inputFile == None:
	print("Error: no input file. Please specify an input file with \"-i [file]\".")
	sys.exit(0)

# Download and display info about the device.
infoProcess = subprocess.Popen(["python", "communicate.py", "INFO"], stdout=subprocess.PIPE)
infoProcess.wait()
output, error = infoProcess.communicate()
print(output)

# Upload the file
print("Uploading file: {}".format(args.inputFile))
uploadProcess = subprocess.Popen(["python", "communicate.py", "UPLOAD", "-i", args.inputFile], stdin=subprocess.PIPE, stdout=sys.stdin)
uploadProcess.wait()
output, error = uploadProcess.communicate()

# Calculate the start and end address for downloading our file to verify.
# We also use the file contents to verify.
lines = []
with open(args.input, "r") as f:
	for line in f:
		lines.append(line)

print("Downloading to verify...")
downloadProcess = subprocess.Popen(["python", "communicate.py", "DOWNLOAD", "-startAddress", startAddress, "-endAddress", endAddress], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
downloadProcess.wait()
output, error = uploadProcess.communicate()



