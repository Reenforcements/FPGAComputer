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

- shouldLink
- shouldBranch
- branchAddress [25:0]
	- This will be from a 26 bit jump address or the result of adding the PC inside the ALU.

### Outputs



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
	- I think I can accomplish these using byte "shifts" either inside the memory unit.
- Store byte
- Store halfword
- Store word
- Store word coprocessor
- Store word left 
- Store word right

### Input

- addressInput0 [31:0]
- dataInput [31:0]
- writeEnable
- readEnable
- unalignedLeft
- unalignedRight


- pcAddress
	- For fetching the next instruction

### Output

- dataOutput [31:0]
- pcDataOutput [31:0]

# Register File

### Input

- registerReadAddress0 [4:0]
- registerReadAddress1 [4:0]
- registerWriteAddress0 [4:0]
- registerWrite

### Output

- readData0 [31:0]
- readData1 [31:0]

# Misc

- Move from coprocessor
- Move to coprocessor

- Return from exception -- Returns from an exception function call I'm guessing? Exceptions can occur if there's overflow with the non unsigned math operations.
- System call
- Break -- Used to transfer conrol to a debugger using kernel's exception handler. I won't have a kernel though so I'll probably just make this one a NOP or repurpose it for serial debugging somehow.
- NOP