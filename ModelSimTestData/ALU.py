# This program generates test data for verifying the ALU.
import sys
# Binary is super annoying to work with in Python because of its
#  "infinite" integer support, so we're going to use numpy
from numpy import binary_repr

ADD = 0x20
ADDU = 0x21
SUB = 0x22
SUBU = 0x23
MUL = 0x18
MULU = 0x19
DIV = 0x1a
DIVU = 0x1b

AND = 0x24
NOR = 0x27
OR = 0x25
XOR = 0x26

SLL = 0x0
SLLV = 0x4
SRA = 0x3
SRAV = 0x7
SRL = 0x2
SRLV = 0x6

SLT = 0x2a
SLTU = 0x2b

MFHI = 0x10
MFLO = 0x12
MTHI = 0x11
MTLO = 0x13

numbers = [
2, 3,
10, 20,
-20, -43,
40, -30
-40, 30,
0, 1234,
1000000000,1000000000,
43, 34,
0, 0
]

currentNumber = 0
def twosComplement(n):
	if(n < 0):
		return (~(n) + 1)
	return n	 
def writeOperation(
f, 
dataIn0, 
dataIn1,
shamt,
funct,
result):
	f.write("//dataIn0: {}\n//dataIn1: {}\n//shamt: {}\n//funct: {}\n//result: {}\n//outputZero: {}\n//outputNegative: {}\n//outputPositive: {}\n".format(
	dataIn0,
	dataIn1,
	shamt,
	funct,
	result,
	result == 0,
	result < 0,
	result > 0
	))
	f.write("{}_{}_{}_{}_{}_{}_{}_{}\n".format(
	binary_repr(dataIn0, width=32),
	binary_repr(dataIn1, width=32),
	binary_repr(shamt, width=5),
	binary_repr(funct, width=6),
	binary_repr(result, width=32),
	binary_repr(result == 0, width=1), #outputZero
	binary_repr(result < 0, width=1), #outputNegative
	binary_repr(result > 0, width=1), #outputPositive
))
	

with open("ALU.txt", "w") as f:
	while True:
		if(currentNumber >= (len(numbers)/2)):
			f.close();
			sys.exit(0);
			break

		num0 = numbers[currentNumber]
		num1 = numbers[currentNumber + 1]

	
		# ADD
		shamt = 0
		funct = ADD
		result = num0 + num1
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SUB
		shamt = 0
		funct = SUB
		result = num0 - num1
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		currentNumber += 1
		continue

		# MUL
		shamt = 0
		funct = MUL
		result = 0 # Result is specially zero because of 
					# lo and hi registers
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# MUL (check hi)
		shamt = 0
		funct = MFHI
		result = ((num0 * num1) & 0xFFFFFFFF00000000) >> 32
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# MUL (check lo)
		shamt = 0
		funct = MFLO
		result = (num0 * num1) & 0x00000000FFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# DIV
		shamt = 0
		funct = DIV
		result = 0 # Result is specially zero because of 
					# lo and hi registers
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# DIV (check hi)
		shamt = 0
		funct = MFHI
		result = ((num0 * num1) & 0xFFFFFFFF00000000) >> 32
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# DIV (check lo)
		shamt = 0
		funct = MFLO
		result = (num0 * num1) & 0x00000000FFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		currentNumber += 1


