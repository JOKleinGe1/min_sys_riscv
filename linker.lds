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
    .text :
    {
	*(.text._start)
        *(.text)
    } > ram

    .rodata :
    {
        *(.rodata)
    } > ram

    .data :
    {
        *(.data)
    } > ram

    .bss :
    {
        *(.bss)
    } > ram
}
