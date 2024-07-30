/* OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv") */
OUTPUT_ARCH(riscv)

ENTRY (_start)

stack = 0x400 ;

MEMORY
{
    ram (rwx) : ORIGIN = 0x0, LENGTH = 10K
}

SECTIONS
{
    .text : ALIGN(4)
    {
	*(.text._start)
        *(.text)
	_etext =  . ;
    } > ram

    .rodata :  ALIGN(4)
    {	
	_srodata = . ;
        *(.rodata)
	_erodata = . ;
    } > ram

    .data :  ALIGN(4)
    {
	_sdata = . ;
        *(.data)
	_edata = . ;
    } > ram

    .bss :  ALIGN(4)
    {
  	_sbss = . ;
      *(.bss)
  	_ebss = . ;
    } > ram
}
