###6/10/18

I'm going to start with the RegisterFile. I made two new directories: HDL, for SystemVerilog code, and ModelSimTests, for all the testbenches. ModelSim and Quartus will share files in the HDL directory. I just made the RegisterFile.sv and RegisterFile_TB.sv files (TB stands for test bench.)

### 6/9/18

I finally figured out how to use `$display`. Its part of ModelSim. It also has to be used in a procedural block. This was such a mystery to me for a long time. I really wish I had known about this back in 287.

Trying to get ModelSim running on Ubuntu. The Quartus install manual says they support Red Hat Linux, but I'm trying anyways. Things are a little extra tricky because ModelSim is 32 bit and I installed a 64 bit version of Ubuntu. I'm currently trying to install all the 32-bit libraries I'll need to run ModelSim.

I went through and installed the most similar libraries I can find, and the application started!! I'll have to see if it crashes when I try to use it or if its pretty stable.

Okay, the text editor has like nano sized text.

Apparently changing the font size to negative fixes it. I don't know how people figured that out.

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