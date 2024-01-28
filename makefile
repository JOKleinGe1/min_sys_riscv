CC := /opt/riscv32i/bin/riscv32-unknown-elf-gcc
NM:=/opt/riscv32i/bin/riscv32-unknown-elf-nm
OBJCOPY:=/opt/riscv32i/bin/riscv32-unknown-elf-objcopy 
OBJDUMP:=/opt/riscv32i/bin/riscv32-unknown-elf-objdump

all : test.asm  test.map  test.mem32  tb_sys_picorv32.vcd

test.hex: 	jumpstart.s test.c	
	$(CC) -o $@  $^     -T linker.lds -nostartfiles
test.map : test.hex
	$(NM) $^  > $@
test.mem : test.hex
	$(OBJCOPY)  -O verilog  $^ $@
test.mem32 : test.mem VlogMem8to32
	./VlogMem8to32 <test.mem > test.mem32
VlogMem8to32 : VlogMem8to32.c
	cc -o $@ $^
test.sec : test.hex
	$(OBJDUMP) $^  > $@
test.asm : test.hex
	$(OBJDUMP) $^  -d > $@
tb_sys_picorv32.vvp  :  picorv32.v  system_picorv32.v  tb_sys_picorv32.v
	iverilog  -o $@  $^
 tb_sys_picorv32.vcd :tb_sys_picorv32.vvp
	vvp   $^
clean : 
	/bin/rm -f test.hex  *.mem *.map *.elf *.hex  tb_picorv32  rm *.vcd *.asm *.mem32 VlogMem8to32 *.vvp
