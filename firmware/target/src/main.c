#include "efc/checksum.h"
#include <stdint.h>

#define DWT_CYCCNT_ADDRESS (0xE0001004UL)

static volatile uint32_t g_boot_counter;
static volatile uint32_t g_initialized_value = UINT32_C(0x12345678);
static volatile uint8_t g_work_buffer[256];
static volatile uint32_t g_reset_handler_to_main_cycles;

static const uint8_t g_signature[] = {
    'E', 'F', 'C', '-', 'B', 'A', 'S', 'E',
    'L', 'I', 'N', 'E', '-', '0', '1'
};

int main(void)
{
    g_reset_handler_to_main_cycles =
        *(volatile const uint32_t *)DWT_CYCCNT_ADDRESS;

    g_boot_counter = g_initialized_value ^ efc_checksum_u8(g_signature, sizeof(g_signature));

    g_work_buffer[0] =
        (uint8_t)(g_boot_counter & UINT32_C(0xFF));

    for (;;) {
        __asm volatile ("nop");
    }
}