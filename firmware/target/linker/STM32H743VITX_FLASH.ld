ENTRY(Reset_Handler)

_Min_Stack_Size = 0x1000;

MEMORY
{
    FLASH   (rx)  : ORIGIN = 0x08000000, LENGTH = 2048K
    DTCMRAM (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
}

_estack = ORIGIN(DTCMRAM) + LENGTH(DTCMRAM);
_stack_limit = _estack - _Min_Stack_Size;

SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    .text :
    {
        . = ALIGN(4);

        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)

        . = ALIGN(4);
        _etext = .;
    } > FLASH

    .ARM.extab :
    {
        *(.ARM.extab*)
    } > FLASH

    .ARM.exidx :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } > FLASH

    .data :
    {
        . = ALIGN(4);
        _sdata = .;

        *(.data)
        *(.data*)

        . = ALIGN(4);
        _edata = .;
    } > DTCMRAM AT > FLASH

    _sidata = LOADADDR(.data);

    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;

        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        _ebss = .;
    } > DTCMRAM

    .ARM.attributes 0 :
    {
        *(.ARM.attributes)
    }

    /DISCARD/ :
    {
        *(.comment)
        *(.note*)
    }
}

ASSERT(
    _ebss <= _stack_limit,
    "DTCMRAM overflow: static data collides with reserved stack"
)