import string
import sys

st = """
ZIPS - A MIPS I computer 
Version 1.0
Austyn Larkin
For United Summer Scholars program at Miami University.\0\0\0\0\0\0
"""
encodedString = st.encode('us-ascii')

sys.stdout.write("logic [31:0]INFO_STRING[0:{}] = '{{\n".format( ((len(encodedString))/4)-1)  );

everySoOften = 0
x = 0
while x < (len(encodedString)-4):

	sys.stdout.write("32\'h{:02x}{:02x}{:02x}{:02x}".format( ord(encodedString[x]), ord(encodedString[x+1]), ord(encodedString[x+2]), ord(encodedString[x+3]) ))
	everySoOften = everySoOften + 1
	
	x = x + 4
	if x < (len(encodedString)-4):
		sys.stdout.write(", ")
	if x % 16 == 0:
		sys.stdout.write("\n")
	

sys.stdout.write("};")
sys.stdout.write("\n")
