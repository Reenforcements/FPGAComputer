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

### Links:

# MIPS I Assembly

The R2000 was the first processor to run MIPS I, the first version of MIPS. The R2000's instruction set is what my processor will be designed to run. Any of the newer MIPS seem too complex to implement (at least for a beginner.)

Some MIPS commands really get assembled down into multiple instructions. These are called **pseudoinstructions**.

##### Assembly instruction field names

- rs = register source
- rt = register target
- rd = register destination


### Links:

[MIPS R2000 Assembly Language](https://fenix.tecnico.ulisboa.pt/downloadFile/3779576281986/MIPS)


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

### Links

Apparently you can change a section's start address using the linker. [Here's the link I found this info on](https://gcc.gnu.org/ml/gcc-help/2010-02/msg00213.html)
[Linker scripts](https://www.math.utah.edu/docs/info/ld_3.html#SEC14)

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

### Links:
[A nice diagram giving the rundown of an ELF file.](https://i.stack.imgur.com/xkGtg.jpg)
<br>
[ELF File format reference.](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
<br>
[Great Stackoverflow answer explaining the difference between an ELF and BIN file.](https://stackoverflow.com/questions/2427011/what-is-the-difference-between-elf-files-and-bin-files)
<br>
[Python library for working with ELF files. Will be useful to make an uploader.](https://github.com/eliben/pyelftools)

# SystemVerilog
###### Notes and things heavily taken from Altera's "SystemVerilog with the Quartus II Software" online course found [here](https://www.altera.com/support/training/course/ohdl1125.html). Array info from [here](http://www.verilogpro.com/systemverilog-arrays-synthesizable/).

So it seems like there's three versions of Verilog floating around. There's Verilog, Verilog HDL, and SystemVerilog. This is really confusing, because HDL stands for hardware description language, but it also seems to be a version of Verilog itself. This nomenclature makes talking about and distinguishing these two versions of Verilog very confusing. One was created and maintained by the US military, and the other was created and maintained by other people. SystemVerilog seems to be the newest standard, and even supports classes. I'm not sure Quartus actually supports classes yet though. I don't think they have a full implementation of SystemVerilog yet. SystemVerilog seems to be Verilog with extra features, so I'll probably use it for my project in case I want to take advantage of some of its new and useful features. If not, its a superset of Verilog, so I could always just fall back to the basics.

### Data Types Summary

SystemVerilog has standard data types that you can take advantage of. Initially, you might think this would make things harder for the programmer, but using SystemVerilog's data types where applicable can actually reduce errors and make writing code easier. You can also make typedefs of your own data types so you don't have to guess what that 5 bit signal you made last week was for.

All variables in plain Verilog may have one of four state values: **0, 1, x, and z**. This isn't always the case with SystemVerilog types.

| 2 State Data Types | (0, 1) |
| --- | ---- |
| bit | User defined vector size; defaults to unsigned |
| byte | 8 bit **signed** integer or ASCII character |
| shortint | 16 bit signed integer |
| int | 32 bit signed integer |
| longint | 64 bit signed integer |
| **4 State Data Types** | (0, 1, x, z) |
| logic | User defined vector size; defaults to unsigned |
| reg | User defined vector size; defaults to unsigned |
| integer | 32 bit signed integer |
| time | 32 bit unsigned integer |

### Logic

Removes confusion between `reg` and `wire`. Using `reg` doesn't mean you're creating a register in hardware. The context determines what a `reg` becomes. Use `logic` instead of `reg`. Use `net` or `wire` where multiple drivers are required, and `logic` everywhere else.

### Casting

SystemVerilog is more strict about type conversions and thus has casting.

```
// Casting size change to 10 bits
10' (x - 2)
// Casting to type int
int' (2.0 * 3.0)
// Casting to signed
signed' (x)
// Casting to enum type
fruit'(0)
```

### User Defined Types ( `typedef` and `enum` )

Enum without a datatype defaults to `int` in SystemVerilog.

Enums with each value defined will be ignored unless the settings are changed from auto to user encoded.

```
typedef int unsigned uint;
typedef logic [15:0] main_bus;

typedef enum bit {TRUE, FALSE} boolean;
boolean ready;
assign eq_two = (datain == 2'b10) ? TRUE : FALSE;

typedef struct {
	logic         even;
	logic [7:0] parity;
} par_struct;

par_struct p1, p2;
assign p1  = '{0, 8'h80};
assign p2.parity = 8'hA2;
```

### Arrays

Arrays have lots of different parameters. Here's a breakdown:

`type [A]arrayName[B][C]`<br>
A = packed dimensions<br>
B, C = unpacked dimensions<br>

A one dimensional packed array is also called a **vector**.

```
logic [7:0]m;  
logic [8]g;
```

An array of vectors or something like `int` can be done like this. Notice the order of the numbers can be different. Single values can also be used, but this seems less clear.

```
int arr[0:15][0:31];
int arr[15:0][31:0];
int arr3[16][32];
```

In SystemVerilog, you can access more than one element of an array by 'slicing' it.

```
bit [8:0]myArray1[15:0];
bit [8:0]array2[1:0];
array2 = myArray1[8:7];
// OR this equivalent expression
array2 = myArray1[7+:2]; 

// Can also do this in the opposite direction.
```
Arrays can also be multidimensional.

```
bit [3:0][15:0] multi1 [0:7]; // 8 elements of 4, 16 bit variables.

typedef bit [4:0] bsix;   // multiple packed dimensions with typedef
bsix [9:0] v5;            // equivalent to bit[4:0][9:0] v5
 
typedef bsix mem_type [0:3]; // array of four unpacked 'bsix' elements
mem_type ba [0:7];           // array of eight unpacked 'mem_type' elements
                             // equivalent to bit[4:0] ba [0:3][0:7] - thanks Dennis!

```

###### More on arrays [here](http://www.verilogpro.com/systemverilog-arrays-synthesizable/).

### Unsized Integer Literals

```
logic [7:0] data_reg;

assign data_reg = '1; // Fills with ALL ONES.
```

### Packages

Packages allow these things to be shared across modules:

- parameters
- types
- tasks
- functions

```
package global_defs;
enum { IDLE, SOP, DATA_PAYLOAD, CRC } packet_state;
typedef int unsigned uint;
typedef logic [15:0] main_bus;
endpackage
```

#### Importing packages

`module main_control(input global_defs::main_bus in_bus, ...);`

`import global_defs::*;`

### Procedural Blocks

##### always_ff - Sequential logic

Designer intends to model sequential logic. The "ff" means "flip flop". Specify sensitivity list. Outputs cannot be assigned in another block.

```
always_ff @(posedge clk, posedge rst) begin
	if (rst)
		pckt_state <= IDLE;
	else
		pckt_state <= next_packet_state;
end
```

##### always_comb - Combitorial logic

Designer's intent to model combinatorial logic. Sensitivity list is inferred. Outputs cannot be assigned in another block. Evaluated at time zero.

```
always_comb begin
	unique case (packet_state)
		IDLE:
			...
		CRC:
			...
		etc..
	endcase
end
```

##### always_latch - Latched logic

Designer's intent is to model latch based logic. Sensitivity list is inferred. Outputs cannot be assigned in another block. Evaluated at time zero. Not really sure what the purpose of this block is yet.

```
always_latch
	if(data_enable)
		data_out_latch <= data_in;
end
```

### Procedural Statements

These are what go into the various types of procedural blocks.

##### Increment/Decrement Operators

These should be used in combitorial blocks. If used in sequential blocks, they might create race conditions where another sequential block reading the value might get the old value or the new one.

##### Other Operators

```
+=
-=
*=
/=
%=
&=
|=
^=
<<= // Logic shift
>>=
<<<= // Arith shift
>>>=
```
##### Wild Equality and Inequality Operators

`==?` and `!=?` treat X and Z bits as don't cares in the right operand.

##### Jump Statements

break, continue, and return

### Block Names

Name your blocks to avoid errors and make things easier to follow.

```
always_comb begin : write_registers
	if(something == otherThing) begin : special1
		...
	end : special1


end : write_registers
```

### Enhanced Case Statements

unique case (...) - Only one case matches when evaluated, so it can be done in parallel

priority case (...) - Should be evaluated in order like a big if-else

### State Machine Guidelines

- Assign detault values to outputs derived from the state machine.
- Separate the state machine logic from:
	- Arithmetic functions
	- Data paths
	- Output values
- Define common operations outside of the state machine and then reuse that functionality across the state machine where needed.

### Enhanced Port Connections

Don't even bother with ordered port connections. Named is the way to go. Its more clear and less error prone. Its also easier to update stamped out modules with named ports compared to ordered ports.

Use `.internalName(nameInCurrentScope)` for named connections.

Use `.name` to connect something from the current scope to an internal thing of the same name.

Use `.*` to auto connect all from the current scope to internal names.

### Interfaces

Bundle signals into single connections.

```
interface my_cool_bus;
	logic writeEnabled;
	logic readEnabled;
	logic [5:0] opCode;
	logic [31:0] data0;
	
	modport master (input writeEnabled, readEnabled,
						output opCode, data0);
	modport slave (input opCode, data0,
					output writeEnabled, readEnabled);
endinterface

module fabric(
			input logic clk,
			my_cool_bus.master inputBus,
			my_cool_bus.slave  device0,
			my_cool_bus.slave device1);
			
			...
			
endmodule	

```

You can then instantiate my_cool_bus and hook them up to the source and destination and then use the instance to make connections in between.

### Links

[SystemVerilog reference guide](http://svref.renerta.com)
<br>
[Verilog Online Help](http://verilog.renerta.com/source/vrg00013.htm)


# DE2-115 FPGA


### Links

[DE2-115 Specifications](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163&No=502&PartNo=2)
<br>
[University IP Cores](https://www.altera.com/support/training/university/materials-ip-cores.html)


# Verification/Validation/Testing
###### Notes taken from "SOC Verification using SystemVerilog" online course (link at bottom.)

Verification is different from validation and testing. Verification demonstrates functional correctness of a design. Verification helps ensure that the specification is preserved in the implementation. Validation ensures that the product/design fits the application's needs. Testing ensures that the product/design is manufactured correctly.

If you don't verify, you can introduce these fun issues:

- Incorrect/insufficient specifications
- Misinterpretation of specifications
- Misunderstanding between designers
- Missed cases
- Protocol non-conformance

**70% of design effort goes into verification.**

Verify functionally, timing, and performance.

You can apparently call C functions from SystemVerilog and vice versa.

# ModelSim

ModelSim can be used to verify the logic of your designs without uploading them to an FPGA and testing them manually.

`restart -f` - Will reload compiled files so you don't have to create a new simulation each time you edit a file.

`assert` must go in a clocked block.


You can print messages with your asserts.
```
assert (A == B) $display ("OK. A equals B");
    else $error("It's gone wrong");
```

Use `#time` to wait for a certain amount of time in an `always` block that uses `<=`.

Use `wait (signalName)` to wait for that signal to change before proceeding. Super useful to put these before asserts.

You can put a giant wait at the end of your always block to let the simulation run and have it never repeat.

`$readmemb` can be used to read lines of binary from a file for use with testing. [More help.](http://verilog.renerta.com/mobile/source/vrg00016.htm)

### Links

[SOC Verification using SystemVerilog](https://www.slideshare.net/RamdasMozhikunnath/soc-verificationsystemverilog)
<br>
[Generating a TestBench](https://www.youtube.com/watch?v=qZNL1C0TwY8)
<br>
[How to Simulate and Test SystemVerilog with ModelSim (SystemVerilog Tutorial #2)](https://www.youtube.com/watch?v=-o3RBvTh4Hw)

# RGB LED Matrix

[Here's a really good explaination on how the RGB Matrix is wired.](https://bikerglen.com/projects/lighting/led-panel-1up/)

# Hex/Decimal/Octal/Binary

Dealing with different number formats can make things tricky. If you're on a Mac, there's a special mode on the calculator app called **programmer mode**. Its under the "view" menu item. If you enable it, you can switch between octal, decimal, and hex modes. Additionally, the calcualtor will display the current number on the calculator's display in binary.

### Links
[HEX to float](https://babbage.cs.qc.cuny.edu/IEEE-754.old/32bit.html)
<br>
[Great Two's Complement Converter](http://www.exploringbinary.com/twos-complement-converter/)
<br>
