
WRITE = "write"
READ = "read"

rxdtxdData1 = [
# FORCE_RST_LOW
(WRITE, 0x00000000),
(WRITE, 0x00000005),

# UPLOAD
(WRITE, 0x00000000),
(WRITE, 0x00000002),

# 1024 to 1056 (exclusive)
(WRITE, 0x00000400),
(WRITE, 0x00000420),
# Data
(WRITE, 0x00000011),
(WRITE, 0x00000022),
(WRITE, 0x00000033),
(WRITE, 0x00000044),

(WRITE, 0x00000055),
(WRITE, 0x00000066),
(WRITE, 0xAABBCCDD),
(WRITE, 0xEEFF0000),

# FORCE_RST_HIGH
#(WRITE, 0x00000000),
#(WRITE, 0x00000004),

# NOP
(WRITE, 0x00000000),
(WRITE, 0x00000000),

# DOWNLOAD
(WRITE, 0x00000000),
(WRITE, 0x00000003),

(WRITE, 0x00000400),
(WRITE, 0x00000420)
];

with open("rxdtxdOut.txt", "w") as f:
	for entry in rxdtxdData1:
		if entry[0] == WRITE:
			f.write("{}_{}_{:08x}".format(1, 0, entry[1]))
		elif entry[0] == READ:
			f.write("{}_{}_{}".format(0, 1, entry[1]))

		f.write("\n")

	
	f.close()










