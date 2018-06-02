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