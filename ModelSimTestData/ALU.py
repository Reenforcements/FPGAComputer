# This program generates test data for verifying the ALU.
import sys
# Binary is super annoying to work with in Python because of its
#  "infinite" integer support, so we're going to use numpy
from numpy import binary_repr
# Apparently division is weird too...
from numpy import true_divide
# I really hate numbers in Python...
from ctypes import c_int, c_uint

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
0xFFFFFFFF, 32,
0xFFFFFFFF, 33,
0xFFFFFFFF, 31,
0, 1234,
1000000000,1000000000,
43, 34,
0, 0
]

currentNumber = 0


def srl(num, amount):
	num = c_int(num).value
	amount = c_uint(amount).value
	if (amount >= 32):
		return 0
	mask = 0x00000000
	for x in range(0, amount):
		mask |= (0x80000000 >> x)
	mask = ~(mask & 0xFFFFFFFF)
	#print(binary_repr(c_int(mask).value, width=32))
	return ((num >> amount) & 0xFFFFFFFF) & (mask & 0xFFFFFFFF)

def writeOperation(
f, 
dataIn0, 
dataIn1,
shamt,
funct,
result):

	# Ensure the result is within range
	result = c_int(result & 0xFFFFFFFF).value

	f.write("//dataIn0: {}\n//dataIn1: {}\n//shamt: {}\n//funct: {}\n//result: {}\n//outputZero: {}\n//outputNegative: {}\n//outputPositive: {}\n".format(
	dataIn0,
	dataIn1,
	shamt,
	hex(funct),
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

		num0 = c_int(numbers[currentNumber]).value
		num1 = c_int(numbers[currentNumber + 1]).value

	
		# ADD
		shamt = 0
		funct = ADD
		result = (num0 + num1) & 0xFFFFFFFF
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

		# Uncomment for simple math only
		#currentNumber += 1
		#continue

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
		result = c_int(((num0 * num1) & 0xFFFFFFFF00000000) >> 32).value
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
		result = c_int((num0 * num1) & 0x00000000FFFFFFFF).value
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
		result = ( int(true_divide(num0 , num1)) & 0xFFFFFFFF00000000) >> 32
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
		result = ( int(true_divide(num0 , num1)) & 0x00000000FFFFFFFF)
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# AND
		shamt = 0
		funct = AND
		result = num0 & num1
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# NOR
		shamt = 0
		funct = NOR
		result = ~(num0 | num1)
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)
	
		# OR
		shamt = 0
		funct = OR
		result = num0 | num1
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# XOR
		shamt = 0
		funct = XOR
		result = num0 ^ num1
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SLL
		shamt = 1
		funct = SLL
		result = (num0 << shamt) & 0xFFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SLLV
		shamt = 0
		funct = SLLV
		# Doing "& 0xFFFFFFFF" makes it unsigned
		# Don't bother shifting if the shift is >= 32 bits
		if ((num1 & 0xFFFFFFFF) >= 32):
			result = 0
		else:
			result = (num0 << (num1 & 0xFFFFFFFF)) & 0xFFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SRA
		shamt = 1
		funct = SRA
		# Shifts in Python are arithmetic.
		result = (num0 >> shamt) & 0xFFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SRAV
		shamt = 0
		funct = SRAV
		# Shifts in Python are arithmetic.
		if ((num1 & 0xFFFFFFFF) >= 32):
			if ((num0) < 0):
				result = -1
			else:	
				result = 0
		else:
			result = (num0 >> (num1 & 0xFFFFFFFF)) & 0xFFFFFFFF
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SRL
		shamt = 1
		funct = SRL
		result = srl(num0, shamt);
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		# SRLV
		shamt = 0
		funct = SRLV
		result = srl(num0, num1);
		writeOperation(
			f,
			num0,
			num1,
			shamt,
			funct,
			result
			)

		currentNumber += 1


