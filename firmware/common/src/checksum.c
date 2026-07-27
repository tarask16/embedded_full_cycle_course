#include "efc/checksum.h"

uint32_t efc_checksum_u8(const uint8_t *data, size_t size)
{
    uint32_t sum = UINT32_C(0);

    for (size_t index = 0; index < size; ++index) {
        sum += (uint32_t)data[index];
    }

    return sum;
}