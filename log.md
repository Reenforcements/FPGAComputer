### 8/6/18

I got a basic controller set up. I don't know if it works, but the waveforms look good in ModelSim. I ran into a problem though. The LED matrix looks like it doesn't actually have enough lines to control all these pixels. The decoder should have 5 lines but it only has 4. My guess is there's twice as many shift registers as normal to accomodate this. I think I'm going to experiment with an Arduino first before continuing my FPGA code. I need to know how this works first.

I have it somewhat working with the Arduino. That was fast! I think one of the ground pins is mislabeled and that's the 5th decoder adress pin.

It WAS mislabeled. I have the whole screen being driven now. For fun, I'm changing all the digitalWrites to register writes to make it run quickly.

It runs so much faster there's no comparison. Its updating the screen about 230 times a second.

It turns out those buffers invert the output, so I had to invert all my LED matrix outputs for it to work.

LEDDriver on FPGA working! There are some bugs to work out though. It doesn't change as instantly as it should. It looks like it "scans across".

I'm not sure using the Pi breakout was such a good idea. I think the board makes a lot of assumptions about how things should be connected because it's supposed to be connected to a Pi (tying "GND"s together, etc.) I've had to move around a lot of connectors to different spots.

Ok, I finished rearranging all I needed to and it works great!

Fixed the matrix code so it displays the LSb less brightly than the MSb.

I'm adding generic millisecond and microsecond counters just like the Arduino has. This will help when writing timing sensitive code like games use.

I think I'm going to make the Memory module generic and then instantiate two small ones for video ram. That way, I can keep all the different reading/writing functionality as the main RAM has. I won't get to doing this until tomorrow though.

### 8/5/18

Still trying to figure out why C doesn't run so well. I changed the stack pointer to have the initial value of 65531 and all other registers to start at zero. When it decrements the stack pointer initially to make room for variables, it seems to go twice as far as it should. I wonder if that's related. I'm going to try to figure out why its doing that and fix it anyways.

I think I introduced a bug where the memory write address is actually being written to the memory location. If I add nop's in between the sw, addiu, and sw commands, the bug goes away.

Ok, NOW C seems to be working. Starting work on the LED display.

### 8/4/18

*Not so sure about this anymore:*
Ok, its nothing to do with branching. Apparently changing my variables from char's to int's fixes things. That means my processor isn't properly handling single bytes somewhere. I'm going to go check the ModelSim tests for the memory module.

I don't use address_d0 like I should in the Memory module when reading I use address. I don't think that fixed the bug though.

Ok, I think it has to do with the stack pointer and memory locations. I tried using variables that are allocated at specific memory addresses and it works great (sometimes). Now I just have to figure out how to get the compiler to spit out code that works naturally.

### 8/3/18

Demo went well. Dr. Rajasekhar was very happy with progress.

I'm exploring how to get compiled C to run on the processor.

I think I might need to initialize the global pointer and stack pointer in my SystemVerilog. The compiler doesn't seem to use the frame pointer. This makes sense, as I don't rely on gp and sp in my assembly programs.

The global poitner is used to point to global variables.

There's apparently a file called ctr0.s which stands for CRunTime and it initializes a bunch of stuff. I think I may need to modify that because my MIPS isn't a regular MIPS. I at least want to look at it to maybe see where it's drawing its data from. I found compiled object files that look similar to a ctr0 file but no source files.

Changing the entry symbol to "main" in the linkerscript and adding these flags to GCC seemed to produce plain, compiled C with no startup stuff "-nodefaultlibs -nostdlib".

Really basic C is working now!

The shift key doesn't seem to be working correctly. None of the modifier keys are working properly.

Shift keys are working now. I discovered a problem with bnez it seems. I have two different conditionals written in C, and the one with bnez isn't working. I don't think its a logic error in the code. I don't even know if the bnez instruction is faulty.

### 8/2/18

Got the keyboard module working again with the new clock speed. It should work with any clock speed now. I tried reading from memory where the ascii key values are stored and it works! I'm also going to add a register that can be written to so the default PC address can be changed. I think this will be easier than trying to get the entry point of the program to be exact when I compile.

I made a register that you can write to using the communicate.py program so you can effectively change the start PC address of the computer. I also added the ability to upload ELF files directly and it takes out the entry point and changes the PC address. I also fixed reading and writing to memory externally and within the processor so the other registers take a cycle to write just like the main memory. The keyboard is working from an assembly program now! I have a counter than I can increment/decrement/reset.

### 8/1/18

Finished PS2KeyboardMemory and accompanying testbench modules.

I'm working on integrating the PS2Keyboard/PS2KeyboardMemory modules into the processor so you can read if keys are pressed.

Its integrated! I'm just waiting for the compilation so I can assign pins and then test it. I also added a special memory location that you can write a word to and it displays on the seven segment displays.

Now I'm going to write a program to test the keyboard and display by being able to increment/decrement a counter.

I don't think I can specify my own linker script for compiling C because it overwrites the default one and causes things to not compile correctly. I'm checking the default linkerscript using `mips-linux-gnu-ld --verbose > linkerscriptdefault.txt`.

I just edited the dumped script. I changed all the 40000's to 400's and used it. What a hack, but it seemed to help.

I have a ways to go before I can compile and run straight C programs, but I copied out the machine code for the main function and ran that and it works. The display is working too.

I think the debounce time needs adjustment.

I've been trying different values but nothing seems to be working. I'm wondering if my code doesn't work with a slower clock or something. I may have to try signaltap.

I'm using signaltap. I think the debounce just happened to fix my issue and nothing needs to be debounced.

### 7/31/18

Still having trouble with timing closure. I'm trying turning physical synthesis to "extra" to see if it can be more efficient.

Didn't seem to do anything. The slack is pretty bad too. I might just have to slow down the clock.

I might not be specifying the parameters properly to the lpm_divide instantiations.

I'm trying an LPM divide generated using the megafunction generator.

Didn't help. I think I'll have to slow the processor's clock. Because of how division works with the lo and hi registers though, I think I can get away with pipelining the division by 1 and speeding things up a little.

I slowed the clock down to be 10 Mhz. Now I just need to implement the pipelining for the division results.

Serial broke after I slowed down the clock. I don't know why. Maybe I did it incorrectly.

Ok its mostly working again but now I'm seeing problems in the upload verification. Its having trouble with 8's

I made the processor go a little faster and it seems like its all working now! I'm going to keep working on the keyboard memory module. I might speed up the clock later and just deal with division being super slow. I'm at 8.3 Mhz right now and I can't go any faster with plain clock division.

### 7/30/18

Working on the uploadProgram python script. It will upload, download again to verify, and then run the program.

Fixed the outputHex.py to have a "-d" flag to control debug output. This is because it did debug output by default but I needed clean hex strings to upload.

I think I made a mistake when switching to the RAM megafunction. I need to change the RAM size but also I might need to check the logic that reads from RAM. I was kinda treating the words in the RAM as bytes. I'm working on fixing the addressing scheme.

Ok, now the processor actually has 65536 bytes (or 16384 words) of memory.

Finished the communicate.py and uploadProgram.py programs. I tested the processor on the FPGA for the first time and it mostly worked! It seems to have trouble with division and then one of the branches. I think the division is taking too long for some reason. Its synthesizing an lpm_divide for the division. The timing analyzer seems to take issue with everything involving the divide. I'm not sure I can do a whole division with a 50 Mhz clock. I may try slowing down the clock and running it again to see if it changes anything.

I might be able to speed up the division using the lpm module with certain parameters changed. See [this link](https://www.intel.com/content/dam/altera-www/global/zh_CN/pdfs/literature/ug/ug_lpm_alt_mfug.pdf) and the table within titled `LPM_DIVIDE Megafunction Parameters`.

LPM means library of parameterized modules.
<br>
EDA means electronic design automation
<br>
[(more info)](https://www.intel.com/content/dam/altera-www/global/en_US/pdfs/literature/catalogs/lpm.pdf)

### 7/29/18

Troubleshooting why the PS2 module is unreliable and seems to give bad data sometimes.

I added a debouncer to the PS2_CLK and it works perfectly!

Starting work on the PS2KeyboardMemory module which will keep track of what keys are pressed/released. It will read in the scan codes and assign 1's or 0's to addresses of memory equivalent to the ascii value of the key. This will be down in the reserved memory area.

### 7/28/18

Working on PS2Keyboard module and testbench.

Got the module and testbench done. I copied some 7 segment display code over from 287 so I could display the keyboard codes. I got it all ready to test but it doesn't work. I used signal tap to view all PS2 signals. I don't think the adapter I bought is working.

It turns out that I DO own a PS2 keyboard. The module appears to work fairly well! I think I may have some timing bugs to work out. I read about the adapter we bought, and I made a mistake:
**Note: This is a replacement adapter that can only be used with USB keyboards that are both USB and PS/2 compliant. 
If you keyboard shipped with a similar adapter than this adapter will work with your keyboard. 
If your keyboard did not ship with a similar adapter than this adapter will not work with your USB keyboard**



### 7/27/18

Working on finding out why I can't simulate megafunctions. I'm including the right libraries (or at least the libraries with the same names as the required ones.)

Ok, so I tried rerunning things with altera_mf_ver itself and it worked. altera_mf is VHDL and altera_mf_ver is **ver**ilog. I guess I needed that one?

I researched the PS/2 keyboard protocol a little bit more. [Info here.](http://pcbheaven.com/wikipages/The_PS2_protocol/) [This one too.](http://www.jkmicro.com/ps2keyboard_en.pdf)

Tested the serial communication on the board. It seems that reading from and writing to memory works. So does setting the reset high and low. Also the info.


### 7/26/18

Wrote the code for uploading and downloading. Also added a force_rst line so the reset signal can be controllled serially. The force_rst doesn't control the Memory module however, so we're still free to use that while the rest of the processor is in reset mode. Now I'm going to write ModelSim code to test everything.

I need to make a python program to convert data to a format that ModelSim can read to generate RXD/TXD signals. This is so I can test Main.sv.

Never mind. I decided to just instantiate another RS232 instance to generate the RX/TX signals. Neat.

Things were going great, but now ModelSim isn't simulating my RAM for some reason. It gives x's and z's as outputs for some reason. I don't know why.

I went back to an old commit when the memory worked and its not working there either. 

### 7/25/18

Not happy with how I'm coding the serial command module. I'm going to redo it with more proper state machines.

Going much better this time around! Code is much cleaner too.

Still going great. I'm compiling over and over to catch coding errors.

My SystemVerilog seems like its being evaluated incorrectly. I have a constant assignment in a combinatorial block that's not being overwritten by an assignment further down for some reason. Maybe SystemVerilog behaves differently.

Here's what I learned.
```
TXSource = 32'd0;
WordTX_word = TXSource;
...
TXSource = 32'd123;
// WordTX_word is still zero!
```
versus
```
WordTX_word = TXSource;
TXSource = 32'd0;
...
TXSource = 32'd123;
// WordTX_word is 123 like it should be!
```
[A related Stackoverflow answer](https://electronics.stackexchange.com/questions/343041/systemverilog-sensitivity-list-of-always-comb)


INFO command works again. Now to do the memory commands.


### 7/24/18

Struggling with the sending/receiving word code. I'm having a hard time thinking today.

I got the info command working.

### 7/23/18

Apparently what I want for being able to "pause" my processor is a gated clock. [This Altera document helped me.](https://www.altera.com.cn/zh_CN/pdfs/literature/hb/qts/qts_qii51006.pdf)

I implemented a gated clock. The design takes forever to compile now for some reason. I might try changing the settings to make it optimize less because I have plenty of FPGA space. I wonder if that will mess with timing and make the design fail timing requirements though.

There's an IP core for clock control that I might be able to use. Gating clocks can be sketchy and this would be a good alternative.

I replaced my clock gate with Altera's core.

### 7/22/18

I looked at data packing/unpacking in Python for working with raw data. I'm working on the module for serial commands and its going well.

Made a small Python program to turn a string into a Verilog byte array so I can have an info string.

Quartus is synthesizing away important aspects to my design. Some of my code must be wrong somewhere. Somewhere down the line Quartus must be deciding that the whole path is worthless. It doesn't know that I'm going to be reading and writing to this thing through serial I guess. Its even optimizing away either a huge chunk of my RAM or the whole thing. 

Assigning a single bit of RAM output to an IO pin seemed to stop the RAM from being synthesized away. It still thinks that the RS232 input has no purpose.

Now it thinks the received command is a clock for some reason. Something is really wrong here. Synthesis is a whole different world from ModelSim.

I'll probably do away with the pause line (at least in the processor) and just have two clocks that go to the processor: clk, and memory_clk.

### 7/21/18

Working on SystemVerilog module for serial commands including RAM reading/writing.

### 7/20/18

Removed giant Logic Tap file preventing me from uploading my changes to Github.

### 7/19/18

I synchonized the inputs, which is something that I think needed to be done. I saw a glitch in one of my graphs where a timer wasn't being reset. I don't know how else to explain it if not with a glitch.

I think the RX serial is slowly getting out of time with where it needs to be. I'm going to change the module to be more robust and automatically realign itself if it gets lost.

THAT WAS IT, IT WORKS!

Working on code to allow me to upload/download through serial. This includes SystemVerilog to tie the processor to the serial but also a python program with upload/download commands.

### 7/18/18

I've started troubleshooting the serial again.

Okay, so the data gets messed up when I connect it through the USB hub. I wonder if this is because it has to share power with the FPGA's JTAG USB port.

Nope, its just the hub. Now I have a reason to buy more USB 3 to USB 2 adapters. Now the text isn't nearly as corrupted, but its still breaking after a little while. I'm getting closer.

Using signal tap to figure out why this thing is breaking.

I've been trying all day but I can't figure out whyyyy.

### 7/16/18

The serial is unreliable. I suspect it has something to do with timing violations but I'm not sure. I figure I'll have to learn the timing analysis portion of Quartus eventually so I'm going to look up a tutorial now.

### 7/15/18

New adapter. Some fiddling. Changed rtscts to false. Serial is working :)

### 7/13/18

So, RS232 isn't working at all with the adapter I have. I hope I didn't accidentally buy the wrong adapter and break something. I'm going to keep fiddling with it and maybe try a new adapter. I don't think I have a machine with a native RS232 serial port that I can try unfortunately.
	I've also almost got my second BOM together. While I'm waiting on those parts, I think I'll work on the PS2 keyboard. I'll need some parts from the second BOM before I start on the display.
	
I found out there are two different kinds of RS232 cables: DCE and DTE. They have reversed TX/RX pins so I'm wondering if that's why my cable doesn't work. It is a female cable but it has hex nuts on it. The FPGA is male but also has hex nuts. I'm guessing the RX and TX are connected to each other and that's why its not working. I'll either need to break out this cable or buy a new one.

### 7/12/18

Working on a RS232 serial module so I can upload programs.

Finished version 1 of the RS232 serial module and testbench.

Almost have a writeback test program running so I can make sure the RS232 serial works. I'm running into issues when trying to upload to the board. I found an online article that says it might be permissions issues with the USB device. [Here's a goood looking article that should fix things.](http://www.fpga-dev.com/altera-usb-blaster-with-ubuntu/)


### 7/11/18

After much fiddling, the piplined processor works! I think most of the diagrams online are incorrect. 


### 7/9/18

I've been pipelining the whole processor.

Two problems:
PC is outputting initial data so it does the first instruction twice.

The branch is late causing the same instruction to be executed twice.

### 7/8/18

I'm starting to pipeline the whole thing. This should eliminate any incompatibilities with code compiled for the R2000.

I think the memory should initially output zero, so I don't need to worry about weird initial register timing things.

The pipelining is getting messy and daunting so I went back to the diagram and added boxes to show where things should be registered. I followed some diagrams that I found on Google because it needs to behave like an R2000. 

I think the Branch has to be in the same part of the pipeline as the ALU but none of the diagrams show this. None of the diagrams that I find make logical sense with having a branch delay slot. The way they have things registered it looks like there should be two branch delay slots which is wrong? I think Dr. Majumder covered this problem in his slides. I think the Branch has to be in the same spot as the ALU.

### 7/7/18

I redid the memory module to use a Memory megafunction. It compiles almost instantly now. I'm going through the unit test that I made and fixing bugs that I introduced when I redid the Memory module. Now that I'm using the megafunction though, I'll need to pipeline at least some things in my processor to get it to work. I might just go ahead and pipeline the whole thing at this point.


### 7/6/18

Had a meeting with my professors about the project. It went well.

Changed the Memory module to use a less convenient but compatible syntax that works with both Quartus and ModelSim. I'm now changing enums to be more compatible across files.

The Memory module takes about 19GB of RAM to synthesize. That's not right. Something is wrong in the way I implemented the RAM. If I change the size to be 100 bytes instead of 65535, the synthesis is instant. The FPGA has these things called M9K memory blocks. I think if I more skillfully utilize those, things will compile much faster. I'm going to try using one of Quartus's RAM Megafunctions. I bet those work really well. [This document describes the Cyclone's onboard memory.](https://www.altera.com/en_US/pdfs/literature/hb/cyclone-iv/cyiv-51003.pdf#page3)

If the Megafunction creator freezes when you try to use it, stretch out the window when it appears. Make it as big as you can. As long as no scroll bars appear on it at any time, the GUI shouldn't freeze. I found this solution [here.](https://alteraforum.com/forum/showthread.php?t=47561)

Apparently you can't make a RAM that outputs combinatorially. It has to be on some sort of clock. I'm going to have to pipeline things related to the memory. Maybe I should just go ahead and pipeline the whole processor. I wish SystemVerilog had a nice construct for pipelining things. I know there's a funky thing you can do with repeat. I'll have to look into it further.

### 7/5/18

jalr isn't working correctly because the compiler reorganizes the assembly to fill the delay slot of the jalr instruction. This means that when we jump back with `jr $ra`, we process the instruction in the delay slot again. This is because of my branch delay hack that I did instead of pipelining the whole processor. I just add 4 to the next PC address to fix this.

Basic processor tests are done! :) 

Apparently Quartus accepts very different syntax standards compared to ModelSim. I kind of expected this after Dr. Rajasekhar asked if I had tried synthesizing any of the SystemVerilog I'd written. I think I'm going to change the Memory module to use only unpacked values as I'm having problems converting between packed and unpacked values.

ModelSim and Quartus can't agree on what is valid syntax for unpacked arrays. Oh boy...

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