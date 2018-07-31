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

# Force the rst LOW
forceRstLow = subprocess.Popen(["python", "communicate.py", "FORCE_RST_LOW"], stdout=subprocess.PIPE)
forceRstLow.wait()
output, error = forceRstLow.communicate()

# Download and display info about the device.
infoProcess = subprocess.Popen(["python", "communicate.py", "INFO"], stdout=subprocess.PIPE)
infoProcess.wait()
output, error = infoProcess.communicate()
print(output)

# Upload the file
print("Uploading file: {}".format(args.inputFile))
uploadProcess = subprocess.Popen(["python", "communicate.py", "UPLOAD", "-i", args.inputFile])
uploadProcess.wait()
output, error = uploadProcess.communicate()

# Calculate the start and end address for downloading our file to verify.
# We also use the file contents to verify.
fileLines = []
with open(args.inputFile, "r") as f:
	for line in f:
		fileLines.append(line)

# start/end addresses
startAddress = "{}".format(1024)
endAddress = "{}".format( 1024 + (4*len(fileLines)) )

print("Downloading from {} to {} for verification...".format(startAddress, endAddress) )
downloadProcess = subprocess.Popen(["python", "communicate.py", "DOWNLOAD", "-startAddress", startAddress, "-endAddress", endAddress], stdout=subprocess.PIPE)
downloadProcess.wait()
output, error = downloadProcess.communicate()

# Verify
#fileLines = lines.strip().split("\n")
downloadedLines = output.strip().split("\n")

if len(fileLines) != len(downloadedLines):
	print("File and downloaded data have different lengths: {} vs {}".format(len(fileLines), len(downloadedLines)))
	sys.exit(0)

for x in range(0, len(downloadedLines)):
	first = fileLines[x].strip()
	second = downloadedLines[x].strip()
	if first != second:
		print("{} doesn't match {}".format(first, second) )
		sys.exit(0)
	#print("{} matches {}".format(first, second) )

print("Upload process complete.")
print("Running program...")

# Force the rst HIGH to run.
forceRstLow = subprocess.Popen(["python", "communicate.py", "FORCE_RST_HIGH"], stdout=subprocess.PIPE)
forceRstLow.wait()
output, error = forceRstLow.communicate()


