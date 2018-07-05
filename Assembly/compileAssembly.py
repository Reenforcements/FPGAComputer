# This program compiles given assembly files into a binary that can be uploaded to the processor on the FPGA or ModelSim.


from argparse import *
import sys
import os

parser = ArgumentParser(description="Compile a given assembly file and output a binary.")
parser.add_argument("assemblyFiles", nargs='?', action='store')
parser.add_argument("-o", nargs='?', dest="outputElfName", action='store', const='./a.out')

# Parse argv
args = parser.parse_args()

os.system("""
mips-linux-gnu-as {} -mips1 -g -mfp32 -mhard-float -o temp.out
mips-linux-gnu-ld -T ./linkerscript temp.out -o {}
mips-linux-gnu-objdump {} -D -S > ./compileAssemblyDump.txt
""".format(args.assemblyFiles, args.outputElfName, args.outputElfName))

# python compileAssembly.py -o ../ModelSimTestData/processorTest1.elf ../ModelSimTestData/processorTest1.asm
