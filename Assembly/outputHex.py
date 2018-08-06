# This program converts a compiled binary into a text file with each 4-byte instruction on a new line.

# Requires pyelftools
from elftools.elf.elffile import ELFFile
from elftools.elf import enums
import string
import struct
from ctypes import c_int, c_uint
from argparse import *
import sys



parser = ArgumentParser(description="Outputs the important sections of an ELF file to a file of hex values separated by newline characters. The output format is what we need to get our program into ModelSim for texting.")
parser.add_argument("inputELF", nargs=1, action='store')
parser.add_argument("outputHex", nargs=1, action='store')
parser.add_argument("-d", dest="debugInfo", action='store_const', const=1, default=0)

# Parse argv
args = parser.parse_args()

with open(args.inputELF[0], "rb") as f:
	# Get the elf file
	elf = ELFFile(f)
	# Get the entry point of the program.
	entryPoint = elf["e_entry"]
	print("Entry point of program is {:08x} ({} in decimal.)".format(entryPoint, entryPoint))
	# Ensure this is an executable
	assert(elf["e_type"] == "ET_EXEC"), "ELF is not executable."

	# Open the output file for writing.
	with open(args.outputHex[0], "w") as out:

		currentPC = 1024
		# Iterate over the sections
		for section in elf.iter_sections():
			print("{}, {}, {}".format(section.name, section.header.sh_offset, section.header.sh_size))
			# Seek to where we should read
			seekTo = section.header.sh_offset
			if seekTo <= 0:
				continue
			section.stream.seek(seekTo)
			
			# Iterate over the bytes of the section and print four at a time in hex format.
			current = 0
			for current in range(0, section.header.sh_size/4):
				four = section.stream.read(4)
				assert (len(four) == 4), "Didn't get four bytes! Got {}.".format(len(four))
				unpacked = struct.unpack_from(">i", four)[0]
				val = c_uint(unpacked).value
				line = "{:08x}".format(val)
				if args.debugInfo == 1:
					line = " /*{} ({})*/    {}".format(currentPC, hex(currentPC), line)
				else:
					line = line
				print( line )
				out.write(line)
				out.write("\n")
				currentPC += 4
				





