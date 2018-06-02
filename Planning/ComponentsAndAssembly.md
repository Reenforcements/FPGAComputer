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

- AND
- NOR
- OR
- XOR

- Shift left logical
- Shift right arithmetic
- Shift right logical

- Load upper immediate

- Set less than
- Set less than unsigned

### Features

- Overflow / no overflow?
- Signed / unsigned

### Not Important

Immediate vs register value, Shift left shamt vs register value, 

### Inputs

- dataIn0 [31:0]
- dataIn1 [31:0]

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
	- (Not a lot of documentation on lwl and lwr)
- Store byte
- Store halfword
- Store word
- Store word coprocessor
	- Store word left
	- Store word right
- 

### Input

- addressInput0 [31:0]
- dataInput [31:0]
- writeEnable
- readEnable
- pcAddress

### Output

- dataOutput [31:0]
- pcDataOutput [31:0]