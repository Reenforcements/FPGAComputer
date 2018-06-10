# Control Lines

- registerRead
- registerWrite
- registerWriteMode
	- 1 = use rtAddress [4:0]
	- 0 = use rdAddress [4:0]
- funct [5:0]
- shamt [4:0]
- useImmediate
	- 1 = Use the immediate value provided
	- 0 = Use the register value of rt 
- readMode [1:0]
- writeMode[1:0]
- unalignedLeft
- unalignedRight
- jump/!branch
- jumpRegister
- registerWriteSource [1:0]
	- 0 = write all zero
	- 1 = write nextPCAddress (for branch/jump link)
	- 2 = write data output from memory
	- 3 = write result from ALU

# Program Counter (PC)

### Inputs

- branchTo [31:0]

### Outputs

- pcAddress [31:0]
- nextPCAddress [31:0]

# ALU

### Operations

- Add
- Add unsigned
- Subtract
- Subtract unsigned 
- Multiply
- Multiply unsigned
- Divide
- Divide unsigned

-

- AND
- NOR
- OR
- XOR

-

These use the 5 bit "shamt" value for the shift amount, or in the case of the variable ones, the value of a given register.

- Shift left logical
- Shift left logical variable
- Shift right arithmetic
- Shift right arithmetic variable
- Shift right logical
- Shift right logical variable

-

Implement using a bit shift of 16 left?

- Load upper immediate

-

- Set less than
- Set less than unsigned
	- Will do these with a big 32 bit OR gate and the result of subtraction 

-

The "hi" and "lo" registers are special registers that hold the results of some of the multiply and divide instructions. It makes sense to put them in the ALU for this reason.

- Move from hi
- Move from lo
- Move to hi
- Move to lo

25 functions, need 5 bits

### Features

- Overflow / no overflow?
	- There's probably a designated way to handle this, but maybe I'll just build it into my interrupt controller when I add interrupts.
- Signed / unsigned

### Not Important

Immediate vs register value (This will be handled outside the ALU.)

### Inputs

- dataIn0 [31:0]
- dataIn1 [31:0]
- shamt [4:0]
- funct [5:0]

### Outputs

- result [31:0]
- outputZero
- outputNegative
- outputPositive

# Branching/Jumping

Ignore coprocessor stuff for right now.

Relative branching is the number of instructions to jump back minus one more because the PC gets incremented automatically.

Can handle greater than, less than, and equal using the zero, positive, and negative outputs from the ALU and a couple boolean gates.

I'm going to put a simple adder/subtractor in this thing instead of trying to route things through the ALU.

Don't need to hard code 31 for return address. I think that's done by the assembler using the immediate if you don't specify a value.

Linking is accomplished by setting registerWrite=1 and setting registerWriteSource to use the next PC address.

- Branch on coprocessor true
- Branch on coprocessor false
- Branch on equal
- Branch on greater than equal zero
- Branch on greater than equal zero and link
- Branch on greater than zero
- Branch on less than equal zero
- Branch on less than zero and link
- Branch on less than zero
- Branch on not equal
- Jump
- Jump and link
- Jump register
- Jump and link register

### Inputs

- jump/!branch 
	- 1 if should jump (uses 26 bits)
	- 0 if should branch by adding immediate to current PC
- jumpRegister
	- 1 if jump using result from ALU (the register value)
	- This will be from a 26 bit jump address or the result of adding the PC inside the ALU.
- branchAddressOffset [15:0]
- pcAddress [31:0]
- jumpAddress [25:0]
- jumpRegisterAddress [31:0]

### Outputs

- branchTo [31:0] - `The address to branch to`

# Memory

- Load byte
- Load unsigned byte
- Load halfword
- Load unsigned halfword
- Load word
- Load word coprocessor
	- Load word left
	- Load word right
	- [I found this documentation on lwl, lwr, swl, and swr](https://www2.cs.duke.edu/courses/fall02/cps104/homework/lwswlr.html)
	- I think I can accomplish these using byte "shifts" inside the memory module.
- Store byte
- Store halfword
- Store word
- Store word coprocessor
- Store word left 
- Store word right

### Input

- address [31:0] - `Read/write address`
- data [31:0] - `Data to write if writing`
- writeMode [1:0] 
	- `0 = not writing`
	- `1 = write byte`
	- `2 = write half word`
	- `3 = write word`word`
- readMode [1:0] 
	- `0 = not reading`
	- `1 = read byte`
	- `2 = read half word`
	- `3 = read word`
- unalignedLeft
- unalignedRight
- pcAddress [31:0]
	- For fetching the next instruction

### Output

- dataOutput [31:0]
- pcDataOutput [31:0]

# Register File

### Input

- readAddress0 [4:0]
- readAddress1 [4:0]
- writeAddress [4:0]
- writeData [31:0]
- registerWrite
- registerRead

### Output

- read0Value [31:0]
- read1Value [31:0]

# Misc

- Move from coprocessor
- Move to coprocessor
- Return from exception -- Returns from an exception function call I'm guessing? Exceptions can occur if there's overflow with the non unsigned math operations.
- System call
- Break -- Used to transfer conrol to a debugger using kernel's exception handler. I won't have a kernel though so I'll probably just make this one a NOP or repurpose it for serial debugging somehow. I also can't find documentation on the different break codes.
- NOP

# Notes

- For R format, rd is the destination
- For I format, rt is the desitation (the **target**)

