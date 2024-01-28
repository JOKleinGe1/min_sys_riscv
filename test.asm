
test.hex:     format de fichier elf32-littleriscv


Déassemblage de la section .text :

00000000 <_start>:
   0:	40000113          	li	sp,1024
   4:	0080006f          	j	c <main>
   8:	ff9ff06f          	j	0 <_start>

0000000c <main>:
   c:	fe010113          	addi	sp,sp,-32
  10:	00812e23          	sw	s0,28(sp)
  14:	02010413          	addi	s0,sp,32
  18:	00100793          	li	a5,1
  1c:	fef42623          	sw	a5,-20(s0)
  20:	fec42783          	lw	a5,-20(s0)
  24:	00178713          	addi	a4,a5,1
  28:	fee42623          	sw	a4,-20(s0)
  2c:	00008737          	lui	a4,0x8
  30:	0ff7f793          	andi	a5,a5,255
  34:	00f70023          	sb	a5,0(a4) # 8000 <stack+0x7c00>
  38:	00000013          	nop
  3c:	000087b7          	lui	a5,0x8
  40:	00478793          	addi	a5,a5,4 # 8004 <stack+0x7c04>
  44:	0007c783          	lbu	a5,0(a5)
  48:	0ff7f793          	andi	a5,a5,255
  4c:	0017f793          	andi	a5,a5,1
  50:	fe0796e3          	bnez	a5,3c <main+0x30>
  54:	fcdff06f          	j	20 <main+0x14>
