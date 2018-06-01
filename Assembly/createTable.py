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

{'name':'div', 'type':'r'},
{'name':'divu', 'type':'r'},

{'name':'mul', 'type':'r'},
{'name':'mulo', 'type':'r'},
{'name':'mulou', 'type':'r'},

{'name':'mult', 'type':'r', 'argcount':2},
{'name':'multu', 'type':'r', 'argcount':2},

{'name':'neg', 'type':'r', 'argcount':2},
{'name':'negu', 'type':'r', 'argcount':2},

{'name':'nor', 'type':'r'},

{'name':'not', 'type':'r', 'argcount':2},

{'name':'or', 'type':'r'},
{'name':'ori', 'type':'i'},

{'name':'rem', 'type':'r'},
{'name':'remu', 'type':'r'},

{'name':'rol', 'type':'r'},
{'name':'ror', 'type':'r'},

{'name':'sll', 'type':'r'},
{'name':'sllv', 'type':'r'},
{'name':'sra', 'type':'r'},
{'name':'srav', 'type':'r'},
{'name':'srl', 'type':'r'},
{'name':'srlv', 'type':'r'},

{'name':'sub', 'type':'r'},
{'name':'subu', 'type':'r'},

{'name':'xor', 'type':'r'},
{'name':'xori', 'type':'i'},


{'name':'li', 'type':'i'},
{'name':'lui', 'type':'i'},


{'name':'seq', 'type':'r'},

{'name':'sge', 'type':'r'},
{'name':'sgeu', 'type':'r'},

{'name':'sgt', 'type':'r'},
{'name':'sgtu', 'type':'r'},

{'name':'sle', 'type':'r'},
{'name':'sleu', 'type':'r'},

{'name':'slt', 'type':'r'},
{'name':'slti', 'type':'i'},
{'name':'sltu', 'type':'r'},
{'name':'sltiu', 'type':'i'},

{'name':'sne', 'type':'r'},


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
