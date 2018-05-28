************************************************************
************************************************************
#### PLEASE READ:
##### This file contains my own personal notes as I try to make sense of the software/hardware involved in completing this project. Some things in this file might be correct, other things might be wrong.
************************************************************
************************************************************

# MIPS - Microprocessor without Interlocked Pipeline Stages

There are many different verisons and standards when it comes to MIPS. In addition, there are also optional instruction set extensions for things such as MCU's or 3D graphics. The question is, which MIPS standard would be best to implement?

MIPS32r5 is the fifth revision of MIPS32. It has about 215 individual instructions. That's a lot to implement.

MIPS32r6 is the 6th and newest MIPS32 revision. It also has **way too many** instructions to implement.

MIPS32 is one of the active MIPS architectures that hasn't been depricated yet.

On the other hand, MIPS1 is a really old version of MIPS and has 45 regular instructions and 15 floating point instructions (30 if you count single and double precision separately.) This is much more feasible and will be the instruction set of choice for the processor of the computer.

## Links:


# Compiling for MIPS

It seems that cross compiling isn't as easy as I thought. Ultimately, I need a **toolchain** that will allow me to preprocess, compile, link, and then upload. I searched for a while and then happened upon a toolchain for Ubuntu 16 called **cpp-- mips-linux-gnu**. This includes a bunch of programs that let me compile C/C++ for all the diffferent MIPS architectures. It includes the following commands. The important ones are **bolded**.

- mips-linux-gnu-addr2line
- mips-linux-gnu-gcc-ar   
- mips-linux-gnu-ld
- mips-linux-gnu-ar       
- mips-linux-gnu-gcc-ar-5 
- mips-linux-gnu-ld.bfd
- mips-linux-gnu-as       
- mips-linux-gnu-gcc-nm   
- mips-linux-gnu-nm
- mips-linux-gnu-c++filt  
- mips-linux-gnu-gcc-nm-5 
- mips-linux-gnu-objcopy
- mips-linux-gnu-cpp      
- mips-linux-gnu-gcc-ranlib    
- **mips-linux-gnu-objdump**
	
	With the -D flag, it will treat the .data section as code and try to disassemble it.

- mips-linux-gnu-cpp-5    
- mips-linux-gnu-gcc-ranlib-5  
- mips-linux-gnu-ranlib
- mips-linux-gnu-elfedit  
- mips-linux-gnu-gcov     
- mips-linux-gnu-readelf

 Displays information about the contents of ELF format files. This will be helpful later if I need to understand the ELF format to create an uploader.

- **mips-linux-gnu-g++**      
- mips-linux-gnu-gcov-5   
- mips-linux-gnu-size
- mips-linux-gnu-g++-5    
- mips-linux-gnu-gcov-tool
- mips-linux-gnu-strings
- mips-linux-gnu-gcc      
- mips-linux-gnu-gcov-tool-5   
- mips-linux-gnu-strip
- mips-linux-gnu-gcc-5    
- mips-linux-gnu-gprof  

___

# ELF File - Executable and linkable format

Libraries are ELF files. So is the output from Arduino or GCC/G++.

#### An ELF file contains:

- Symbol look up tables
- Relocation table

 Allows the program to be loaded at any memory address, and everything can be adjusted. A binary file doesn't allow for this.
 
- Compiled code
- The system the code is meant to run on
- Data, text, bss sections (maybe more?)
	
 It is within these sections that the run time can dynamically adjust the memory locations/references.

## Links:
[A nice diagram giving the rundown of an ELF file.](https://i.stack.imgur.com/xkGtg.jpg)
<br>
[ELF File format reference.](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
<br>
[Great Stackoverflow answer explaining the difference between an ELF and BIN file.](https://stackoverflow.com/questions/2427011/what-is-the-difference-between-elf-files-and-bin-files)

# Hex/Decimal/Octal/Binary

Dealing with different number formats can make things tricky. If you're on a Mac, there's a special mode on the calculator app called **programmer mode**. Its under the "view" menu item. If you enable it, you can switch between octal, decimal, and hex modes. Additionally, the calcualtor will display the current number on the calculator's display in binary.

## Links
[HEX to float](https://babbage.cs.qc.cuny.edu/IEEE-754.old/32bit.html)
<br>
