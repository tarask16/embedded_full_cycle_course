.syntax unified
.cpu cortex-m7
.fpu fpv5-d16
.thumb

.global g_pfnVectors
.global Reset_Handler
.global Default_Handler

.extern main
.extern _sidata
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss
.extern _estack

.section .isr_vector, "a", %progbits
.align 2
.type g_pfnVectors, %object

g_pfnVectors:
    .word _estack
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word MemManage_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word DebugMon_Handler
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler

.size g_pfnVectors, . - g_pfnVectors


.section .text.Reset_Handler, "ax", %progbits
.align 2
.type Reset_Handler, %function
.thumb_func

Reset_Handler:
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata

copy_data:
    cmp r1, r2
    bcs zero_bss

    ldr r3, [r0], #4
    str r3, [r1], #4
    b copy_data

zero_bss:
    ldr r0, =_sbss
    ldr r1, =_ebss
    movs r2, #0

zero_bss_loop:
    cmp r0, r1
    bcs call_main

    str r2, [r0], #4
    b zero_bss_loop

call_main:
    bl main

hang:
    b hang

.size Reset_Handler, . - Reset_Handler


.section .text.Default_Handler, "ax", %progbits
.align 2
.type Default_Handler, %function
.thumb_func

Default_Handler:
    b Default_Handler

.size Default_Handler, . - Default_Handler


.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler, Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler, Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler, Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler

.weak DebugMon_Handler
.thumb_set DebugMon_Handler, Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler
