import sys
import os
import re
from ctypes import c_int, c_uint
import collections


class Command:
	def __init__(self, asm, opcode, funct):
		self.asm = asm
		self.opcode = opcode
		self.funct = funct

	def __eq__(self, other):
		return self.asm == other.asm and self.opcode == other.opcode

	def __ne__(self, other):
		return not self.__eq__(other)

# Compile the assembly commands
#os.system("mips-linux-gnu-gcc commands.cpp -march=r2000 -g -mfp32 -mhard-float -mno-mad -mno-fused-madd -mno-mt -mno-micromips -mno-dsp -mno-dspr2 -mno-mdmx -mno-mips3d -fverbose-asm && mips-linux-gnu-objdump a.out -D -S > dump.txt");

# Read the dump.txt
m = re.compile("\s(?P<ml>\w{8})\s+(?P<asm>\w{1,7})\s+")
allCommands = collections.OrderedDict()
with file("./dump.txt", "r") as f:
	for line in f:
		result = m.search(line)
		if result == None:
			continue
		if result.group("ml") and result.group("asm"):
			ml = result.group("ml")
			asm = result.group("asm")
			opcode = hex(int(ml, 16) >> 26)
			funct = hex(int(ml, 16) & 0x0000003F)

			allCommands.setdefault(opcode, [])
			toInsert = Command(asm=asm, opcode=opcode, funct=funct)
			
			if toInsert not in allCommands[opcode]:
				allCommands[opcode].append(toInsert)
			
			#print("{}:{}, [{}, {}]".format(asm, ml, hex(opcode), opcode))



with file("results.txt", "w") as f:
	for g in sorted(allCommands.keys()):
		print(g)
		f.write(g + "\n");
		for i in sorted(allCommands[g], key=lambda com: com.funct):
			toWrite = "    {} (ALU funct = {})\n".format(i.asm, i.funct)
			print(toWrite)
			f.write(toWrite);


