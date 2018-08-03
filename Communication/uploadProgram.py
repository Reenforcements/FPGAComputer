# This program uploads and runs a program on the processor.

# Requires pyelftools to be installed.
from elftools.elf.elffile import ELFFile
from elftools.elf import enums
import sys
from argparse import *
import subprocess
import struct
import string
from ctypes import c_int, c_uint

parser = ArgumentParser(description="Upload a program.")
formats = ["elf"]
parser.add_argument("format", nargs=1, choices=formats, action='store')
parser.add_argument("-i", dest="inputFile",type=str, nargs="?", action='store')
parser.add_argument("-d", dest="debugInfo", action='store_const', const=1, default=0)

args = parser.parse_args()
inputFormat = args.format[0]
inputFile = args.inputFile

if inputFile == None:
	print("Error: no input file. Please specify an input file with \"-i [file]\".")
	sys.exit(0)

# Process our elf file.

# Make a *very efficient* list that will act as our memory.
# Initialize all bytes to zero.
memoryMap = ["\0"] * 65536
entryPoint = None
with open(inputFile, "rb") as f:
	# Get the elf file
	elf = ELFFile(f)
	# Get the entry point of the program.
	entryPoint = elf["e_entry"]
	print("Entry point of program is {:08x} ({} in decimal.)".format(entryPoint, entryPoint))
	# Ensure this is an executable
	assert(elf["e_type"] == "ET_EXEC"), "ELF is not executable."

	# Iterate over the sections
	for section in elf.iter_sections():
		if args.debugInfo == 1:
			print("Current section: Name: {}, sh_offset: {}, sh_size: {}".format(section.name, section.header.sh_offset, section.header.sh_size))
		# Seek to where we should read
		seekTo = section.header.sh_offset
		if seekTo <= 0:
			continue
		section.stream.seek(seekTo)
		
		# Read all the bytes from the section into memory.
		print("Reading from {} to {}".format(seekTo,seekTo+section.header.sh_size))
		for x in range(seekTo, seekTo+section.header.sh_size):
			memoryMap[x] = section.stream.read(1)

# Write the memoryMap
with open("./memoryMap.bin", "w") as f:
	for byte in memoryMap:
		f.write((byte))

print("Wrote memoryMap.bin")

with open("./memoryHex.txt", "w") as f:
	for x in range(256, len(memoryMap)/4):
		index = x * 4
		memoryMapSlice = memoryMap[index:index+4]
		unpacked = struct.unpack(">I", "".join(memoryMapSlice))[0]
		line = "{:08x}\n".format(unpacked)
		f.write(line)

print("Wrote memoryHex.txt")

if entryPoint == None:
	print("Couldn't open the ELF to get a valid entry point (or there isn't an entry point?)")
	sys.exit(0)

# Get our present working directory.
presentWorkingDirectoryProcess = subprocess.Popen(["pwd"], stdout=subprocess.PIPE)
presentWorkingDirectoryProcess.wait()
pwd, error = presentWorkingDirectoryProcess.communicate()

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
uploadProcess = subprocess.Popen(["python", "communicate.py", "UPLOAD", "-i", "memoryHex.txt"])
uploadProcess.wait()
output, error = uploadProcess.communicate()

# Calculate the start and end address for downloading our file to verify.
# We also use the file contents to verify.
fileLines = []
with open("memoryHex.txt", "r") as f:
	for line in f:
		fileLines.append(line)

# start/end addresses
startAddress = "{}".format(1024)
endAddress = "{}".format( 1024 + (4*len(fileLines)) )

print("Downloading from {} to {} for verification...".format(startAddress, endAddress) )
downloadProcess = subprocess.Popen(["python", "communicate.py", "DOWNLOAD", "-startAddress", startAddress, "-endAddress", endAddress], stdout=subprocess.PIPE)
output, error = downloadProcess.communicate()
# Verify
downloadedLines = output.strip().split("\n")

if len(fileLines) != len(downloadedLines):
	print("File and downloaded data have different lengths: {} vs {}".format(len(fileLines), len(downloadedLines)))
	sys.exit(0)

print("Verifying...")
for x in range(0, len(downloadedLines)):
	first = fileLines[x].strip()
	second = downloadedLines[x].strip()
	if first != second:
		print("{} doesn't match {}".format(first, second) )
		sys.exit(0)
	#print("{} matches {}".format(first, second) )
print("Verification complete.")

# Set the PC address to be the entry point minus 4
print("Setting PC address to entry point {:08x} ({} in decimal.)".format(entryPoint, entryPoint))
pcAddressSet = subprocess.Popen(["python", "communicate.py", "UPLOAD", "-startAddress", "259", "-endAddress", "263", "-w", "{:08x}".format(entryPoint - 4)], stdout=subprocess.PIPE)
output, error = pcAddressSet.communicate()

print("Upload process complete.")
print("Running program...")

# Force the rst HIGH to run.
forceRst = subprocess.Popen(["python", "communicate.py", "FORCE_RST_HIGH"], stdout=subprocess.PIPE)
forceRst.wait()
output, error = forceRst.communicate()


