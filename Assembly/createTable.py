# Make sure to install texttable
from texttable import Texttable

# How to format a number to output binary.
# "{0:b}".format(123).zfill(8);

allAssemblyInstructions = [
{'name':'abs', 'type':'r'},

{'name':'add', 'type':'r'},
{'name':'addi', 'type':'i'},
{'name':'addu', 'type':'r'},
{'name':'addiu', 'type':'i'},

{'name':'and', 'type':'r'},
{'name':'andi', 'type':'i'},

# These put results into the lo and hi registers
#  and thus only use two arguments
{'name':'div', 'type':'r', 'argcount':2},
{'name':'divu', 'type':'r', 'argcount':2},

# These support using an immediate instead of
#  another register.
{'name':'div', 'type':'r', 'supportsImmediate':true},
{'name':'divu', 'type':'r', 'supportsImmediate':true},

{'name':'mul', 'type':'r', 'supportsImmediate':true},
{'name':'mulo', 'type':'r', 'supportsImmediate':true},
{'name':'mulou', 'type':'r', 'supportsImmediate':true},

{'name':'mult', 'type':'r', 'argcount':2},
{'name':'multu', 'type':'r', 'argcount':2},

{'name':'neg', 'type':'r', 'argcount':2},
{'name':'negu', 'type':'r', 'argcount':2},

{'name':'nor', 'type':'r', 'supportsImmediate':true},

{'name':'not', 'type':'r', 'argcount':2},

{'name':'or', 'type':'r'},
{'name':'ori', 'type':'i'},

{'name':'rem', 'type':'r', 'supportsImmediate':true},
{'name':'remu', 'type':'r', 'supportsImmediate':true},

{'name':'rol', 'type':'r', 'supportsImmediate':true},
{'name':'ror', 'type':'r', 'supportsImmediate':true},

{'name':'sll', 'type':'r', 'supportsImmediate':true},
{'name':'sllv', 'type':'r'},
{'name':'sra', 'type':'r', 'supportsImmediate':true},
{'name':'srav', 'type':'r'},
{'name':'srl', 'type':'r', 'supportsImmediate':true},
{'name':'srlv', 'type':'r'},

{'name':'sub', 'type':'r', 'supportsImmediate':true},
{'name':'subu', 'type':'r', 'supportsImmediate':true},

{'name':'xor', 'type':'r'},
{'name':'xori', 'type':'i'},


{'name':'li', 'type':'i'},
{'name':'lui', 'type':'i'},


{'name':'seq', 'type':'r', 'supportsImmediate':true},

{'name':'sge', 'type':'r', 'supportsImmediate':true},
{'name':'sgeu', 'type':'r', 'supportsImmediate':true},

{'name':'sgt', 'type':'r', 'supportsImmediate':true},
{'name':'sgtu', 'type':'r', 'supportsImmediate':true},

{'name':'sle', 'type':'r', 'supportsImmediate':true},
{'name':'sleu', 'type':'r', 'supportsImmediate':true},

{'name':'slt', 'type':'r'},
{'name':'slti', 'type':'i'},
{'name':'sltu', 'type':'r'},
{'name':'sltiu', 'type':'i'},

{'name':'sne', 'type':'r', 'supportsImmediate':true},

# Both b and j seem to compile to an offset jump.
# I'm wondering if it just depends on the size of the jump
#  that needs to be made. In this case, they compile to branch
#  if equal, but both registers are $0, so its always true.
{'name':'b', 'type':'j'},

];


table = Texttable()
table.set_cols_align(["l", "r", "c"])
table.set_cols_valign(["t", "m", "b"])
table.add_rows([["Name", "Age", "Nickname"],
                        ["Mr\nXavier\nHuon", 32, "Xav'"],
                        ["Mr\nBaptiste\nClement", 1, "Baby"],
                        ["Mme\nLouise\nBourgeau", 28, "Lou\n\nLoue"]])
print table.draw() + "\n"
