### 7/5/18

jalr isn't working correctly because the compiler reorganizes the assembly to fill the delay slot of the jalr instruction. This means that when we jump back with `jr $ra`, we process the instruction in the delay slot again. This is because of my branch delay hack that I did instead of pipelining the whole processor. I just add 4 to the next PC address to fix this.

Basic processor tests are done! :) 

### 7/3/18

Continuing to write giant test program for processor.

Fixed a bug with sll where it used the wrong output value from the register file. I probably need to fix all the other bit shift commands too.

### 7/2/18

Fixed a bug with lui not working.

Division stores the result in LO and the remainder in HI. That needs to be fixed. The compiler also creates assembly for division that doesn't seem to make sense. It branches away from the division if the divisior isn't zero. Shouldn't it branch away if the divisior IS zero???

Okay, so I found a Stackoverflow answer on the subject. If the processor is properly pipelined, the code will work because the branch won't kick in right away. I might need to pipeline my processor to get compiled code to work properly then. I'd really prefer not to, as pipelining will make things messier and harder to debug, but I might not have a choice here. I'll need to pipeline it exactly like the R2000 to ensure the compiler output works. If I use mips-linux-gnu-gcc to compile code, I can provide a flag so it doesn't check for zero division, but who knows what else relies on pipelining in the compiler. If I can prevent the compiler from utilizing delay slots it might be OK though.

I delayed the branch module and the compiler's division works now :) Also, apparently loading -3 with `li dest, -3` doesn't seem to work but `addi dest, $0, -3` works. `li dest -3` works on the MARS simulator. addiu does sign extend the immediate after all.

The compiler is weird though because it automatically moves the lo of the result into one of the registers it used to divide automatically and I don't know why.

### 7/1/18

Apparently the sign extension of immediates works differently than I thought. Apparently not all instructions that use immediates sign extend the immediate. Some zero extend the immediate. I think I need to add a control line for this. It can't be done in the ALU because the ALU doesn't know the difference between addi and add

##### Sign extend with:
addi
slti
sltiu
addiu
##### Zero extend with:
andi
ori
xori
sltiu
addiu

### 6/30/18

Made a python script to compile run compilation commands. Fixed the Branch_TB to reflect a coding fix I made in the Branch module.

I think I have loadable hex from a compiled/linked assembly program! It even starts at the correct address: 32'd1024. Anything below 1024 is reserved.

### 6/27/18

I figured out how to change the start address of compiled code! This is really great.

### 6/26/18

Made a python program to output the .text section of a compiled assembly program. Now I can program in assembly, compile it, run my Python program, and feed the output into ModelSim to test the processor.

I'm now creating a giant test program that I can feed into ModelSim to test the processor.

Got progress on the test program. I'm not sure how to edit the start address that the assembler uses. This will be important for testing but eventually also running compiled programs on the processor.

I found an error with the Branch module where when it branches by offset it needs to multiply by 4 because branches go by number of instructions and not number of bytes. I need to update the Branch_TB to reflect this and make sure it works.

### 6/25/18

I've been wiring up the processor. Apparently using the assign keyword can create errors because it will create a variable if it doesn't already exist. I'm going to move to always_comb for all assignments instead of using the assign keyword.

Basic processor test with addi and sw working!

### 6/23/18

I've been connecting all the modules together in the Processor.sv file. Everything is going together so cleanly and beautifully.

### 6/22/18

Yeah I don't think the "count" line makes sense. I removed it.

### 6/21/18

I started a new BOM. I'll need things like a power supply, 3D printer filament, logic level converters, and maybe some other things like a breadboard.

Control lines module v1 is done. I'm getting close to running code on this thing.

I created the file for the Processor module. I also created a generic Register module for pipelining.

I'm going to add some extra stuff to the diagram for force loading things into Memory from an external source. This will be perfect for testing but also when I implement serial uploading.

I just realized with the "count" line on the PC, if the clock still runs, it won't truly pause things. I think I should just make the clock the pause line and that will encapsulate everything. I'm not sure there's ever a case where I want the PC to not increment but I want the clock to still run.


### 6/20/18

The documentation for j says its 0x2. The compiler turns J into b and has an OPCode of 0x4. BEQ has an opcode of 0x4 too.

It seems like this MIPS compiler doesn't recognize the 26-bit jump command. I think it treats it as BEQ with two zeros. All the other instruction OPCodes seem to be correct.

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

I think the opcode for SWC1 is a typo. I wonder what else is a typo in that document... I might need to go through and verify all the codes in the document with compiler output. I'm going to write a python program that uses all the assembly commands so I can get the machine language output and verify all the OP codes.

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