int main() {
    asm (	
"label1: \n"
"NOP \n"
"ADD $t0, $t1, $t2 \n"
"ADDU $t0, $t1, $t2 \n"
"AND $t0, $t1, $t2 \n"
"DIV $t0, $t1 \n"
"DIVU $t0, $t1 \n"
"MULT $t0, $t1 \n"
"MULTU $t0, $t1 \n"
"NOR $t0, $t1, $t2 \n"
"OR $t0, $t1, $t2 \n"
"SLL $t0, $t1, $t2 \n"
"SLLV $t0, $t1, $t2 \n"
"SRA $t0, $t1, $t2 \n"
"SRAV $t0, $t1, $t2 \n"
"SRL $t0, $t1, $t2 \n"
"SRLV $t0, $t1, $t2 \n"
"SUB $t0, $t1, $t2 \n"
"SUBU $t0, $t1, $t2 \n"
"XOR $t0, $t1, $t2 \n"
"SLT $t0, $t1, $t2 \n"
"SLTU $t0, $t1, $t2 \n"
"JR $t0 \n"
"JALR $t0 \n"
"MFHI $t0 \n"
"MFLO $t0 \n"
"MTHI $t0 \n"
"MTLO $t0 \n"

"ADDI $t0, $t1, 100 \n"
"ADDIU $t0, $t1, 100 \n"
"ANDI $t0, $t1, 100 \n"
"ORI $t0, $t1, 100 \n"
"XORI $t0, $t1, 100 \n"
"LUI $t0, 100 \n"
"SLTI $t0, $t1, 100 \n"
"SLTIU $t0, $t1, 100 \n"
"BC1T label1 \n"
"BC1F label1 \n"
"MFC1 $t0, $f1 \n"
"MTC1 $t0, $f1\n"
"BEQ $t0, $t1, label1 \n"

"BGEZ $t0, label1 \n"
"BGEZAL $t0, label1 \n"
"BLTZAL $t0, label1 \n"
"BLTZ $t0, label1 \n"

"BGTZ $t0, label1 \n"
"BLEZ $t0, label1 \n"
"BNE $t0, $t1, label1 \n"

"J label1 \n"
"J 0x00FFFF0\n"
"JR $t1 \n"

"LB $t0, 12($t1) \n"
"LBU $t0, 12($t1) \n"
"LH $t0, 12($t1) \n"
"LHU $t0, 12($t1) \n"
"LW $t0, 12($t1) \n"
"LWC1 $f0, 12($t1) \n"
"LWL $t0, 12($t1) \n"
"LWR $t0, 12($t1) \n"

"SB $t0, 12($t1) \n"
"SH $t0, 12($t1) \n"
"SW $t0, 12($t1) \n"
"SWC1 $f1, 12($t1) \n"
"SWL $t0, 12($t1) \n"
"SWR $t0, 12($t1) \n"
	);
    return 0;
}
