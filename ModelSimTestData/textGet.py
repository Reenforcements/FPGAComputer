# This program gets the .text section of an ELF file.
# Requires pyelftools
from elftools.elf.elffile import ELFFile
import string
import struct
from ctypes import c_int, c_uint
import sys
import os

if len(sys.argv) < 2:
	print("Usage: \"python textGet.py myElfFile\"")
	sys.exit(0)

filename = sys.argv[1]

if os.path.exists(filename) == False:
	print("Couldn't find file \"{}\"".format(filename))
	sys.exit(0)


os.system("mips-linux-gnu-as {} -o textGetOutput.elf".format(filename))

with open("textGetOutput.elf", "rb") as f:
	elf = ELFFile(f)
	textSection = elf.get_section_by_name(".text")
	textString = textSection.data()
	with open("./textGetOutput.txt", "w") as out:
		for i in range(0, len(textString) / 4):
			index = (i * 4)
			sub = textString[index:index+4]
			unpacked = struct.unpack_from(">i", sub)[0]
			val = c_uint(unpacked).value
			line = "{:08x}".format(val)
			print( line )
			out.write(line)
			out.write("\n")


