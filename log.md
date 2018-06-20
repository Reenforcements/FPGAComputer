### 6/21/18

It seems like this MIPS compiler doesn't recognize the 26-bit jump command. I think it treats it as BEQ with two zeros. All the other instruction OPCodes seem to be correct.

### 6/20/18

The documentation for j says its 0x2. The compiler turns J into b and has an OPCode of 0x4. BEQ has an opcode of 0x4 too.

### 6/19/18

I think the "Weird instructions" may just be random data that objdump tried to interpret as instructions. Its unclear to me though.

### 6/18/18

Branch testbench done. Starting on PC module. After that, I'll do the PC testbench. Following that, I'll do the control lines module and accompanying testbench. Then I can create the main file to tie everything together and pipeline it. After all that's done, I'll try running some code!

PC + PC testbench done. Starting on the control line module.

Interesting. All the ALU operations that don't use immediates all have the OP code of 0. The immediate instructions all have to have different OP codes because there's no room for funct or shamt.

swc1 comes out to be 0x39=57
The document says its 0x21=33

lwc1 comes out to be 0x31=49
The document says its 0x31=49

I think SWC1 is a typo. I wonder what else is a typo in that document... I might need to go through and verify all the codes in the document with compiler output. I'm going to write a python program that uses all the assembly commands so I can get the machine language output and verify all the OP codes.

Python program is going well.

The Python program works. I'm noticing a bunch of weird instructions that must be from extensions. I'm trying to figure out how to get the compiler to stop producing them in the code. There's a lot of flag options for the MIPS GCC.


### 6/17/18

The diagram is updated and I implemented the Branch module. I'm currently writing the testbench.

### 6/15/18

Had a meeting with Dr. Rajasekhar and Dr. Majumder this morning. Progress is more than satisfactory. I'm actually ahead of the planned schedule.

I finished the memory module with accompanying tests. I just created the files for the Branch module. I realized earlier I forgot to add control lines for what condition(s) to branch on. I'll update the ComponentsAndAssembly.md and online diagram.

### 6/14/18

I found a possible way of running arbitrary machine code from a C/C++ program. It involves making a pointer to data and then calling it like a function. If I can trick the compiler in this way, I can make my own assembly instructions for graphics or even GPIO. More info [here.](https://cboard.cprogramming.com/c-programming/135212-inline-asm-machine-code-non-mnemonic-input.html)

I finished version 1 of the memory module. I'm thinking about the best way to test it.

I'm just going to do some basic reads/writes using the different commands. Also, I had to move the enums for the Memory and ALU modules to packages so they could be imported.

### 6/13/18

Finished the ALU + unit tests in ModelSim. I made a Python program to generate test data and results for a number of inputs. Integers in Python can be really tricky. I used a number of modules to help me.

I started on the memory module.

I finally understand the lwl, lwr, swl, and swr commands I think.

I needed to add "unsignedLoad" to the memory to sign extend bytes and halfwords that are being loaded.

### 6/12/18
Working on the ALU. 

The ALU seems to be mostly done if not done. I've been working on a test module and an accompanying Python program to generate test data for the ALU. It will be read in to ModelSim using `$memreadb`. Working with bits in Python is super annoying because of the "infinite" integers. If you use numpy, things are a little better because you can convert to binary with a set width and it will do proper 2's complement.

### 6/11/18

Register file is done! I even have tests. I created the file for the ALU.

### 6/10/18

I'm going to start with the RegisterFile. I made two new directories: HDL, for SystemVerilog code, and ModelSimTests, for all the testbenches. ModelSim and Quartus will share files in the HDL directory. I just made the RegisterFile.sv and RegisterFile_TB.sv files (TB stands for test bench.)

### 6/9/18

I finally figured out how to use `$display`. Its part of ModelSim. It also has to be used in a procedural block. This was such a mystery to me for a long time. I really wish I had known about this back in 287.

Trying to get ModelSim running on Ubuntu. The Quartus install manual says they support Red Hat Linux, but I'm trying anyways. Things are a little extra tricky because ModelSim is 32 bit and I installed a 64 bit version of Ubuntu. I'm currently trying to install all the 32-bit libraries I'll need to run ModelSim.

I went through and installed the most similar libraries I can find, and the application started!! I'll have to see if it crashes when I try to use it or if its pretty stable.

Okay, the text editor has like nano sized text.

Apparently changing the font size to negative fixes it. I don't know how people figured that out. Here's how to do it:

```
nano ~/.modelsim
Find "textFontV2"
Change "12" to "-12"
```

I believe I have the basics of ModelSim down.

### 6/7/18

I can't find documentation on the different codes used in BREAK. I think I'll just make that a NOP for now in the processor.

The diagram looks good. Lets start in SystemVerilog. I'm going to create a project in Ubuntu and start making one of the simpler modules like the register file.

I finished taking notes on SystemVerilog. Now I'm trying to learn what testing is available. There seems to be some Verilog based testing that I can use but I'm having trouble finding documentation on it.

### 6/6/18

So apparently the SRAM can only work with 16 bits at most at a time, which is kind of useless. I'm adding the program counter to my "ComponentsAndAssenbly.md" and my diagram. This is a lot more involved than I thought, which is good because I didn't want it to be too easy. I'm going to change control lines to be just single arrows instead of having wires everywhere because I'll be changing things a lot and there's too many wires.

### 6/5/18

I think I'm just going to add some hardware in the memory unit and some extra control lines for loading/saving left and right. I'm ready to create the diagram! I think my diagram is going to end up nearly the same, but I really understand the different parts very well now.

### 6/4/18

Pretty much done with the control line planning. I neglected load word left, load word right, store word left, and store word right. I heard they weren't popular instructions so they were removed in the following version of MIPS I think. I should probably still implement them though. I think I can accomplish this with bit shifting and some extra hardware to mess with the address being read from/written to in the memory. I'm probably going to save it until I finish the processor diagram or maybe until I get the processor working. It will be easier to implement this once I get used to the pieces that I'm working with.

### 6/2/18

Working with the instruction set and planning out each module and how each instruction could be implemented seems to be working really well!

### 6/1/18

Continued working on the small cpp and python programs to get the machine language code for all assembly instructions. I found a guide to "MIPS R2000 Assembly Language" online, which is just MIPS I. Plus, maybe I can use the resulting data to sanitize compiled programs to make sure I implemented all the commands in the processor that it needs to run it.

Realized I should probably just use the assembly guide and save time. Now I want to go through all the instructions and group them logically based on what parts of the processor they'll use.

I think I need to iterate over the instruction set and figure out what things are common to different types of instructions. From there, I can figure out what control lines I'll need. Sure, I could just look at a diagram of a MIPS I processor, but that would be **cheating**. I'm kind of trying to forget the diagram that we learned in class because I want to do it from scratch as much as possible.

### 5/31/18

Switched to draw.io for diagramming as it seems to be better than yEd.

Due to wanting a processor that can run compiled MIPS I code, I'm going to model my processor off what I learned in class and the R2000 processor that ran MIPS I.

### 5/30/18

Quartus Lite 18 running on Linux Ubuntu, the same system as the MIPS cross compiler.

Continued taking notes on Verilog/SystemVerilog.

Created a yEd project to map out the entire computer as a giant hierarchy of block diagrams.