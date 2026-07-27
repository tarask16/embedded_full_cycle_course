#ifndef EFC_CHECKSUM_H
#define EFC_CHECKSUM_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Calculates an unsigned byte sum modulo 2^32.
 *
 * data may be NULL only when size is zero.
 */
uint32_t efc_checksum_u8(const uint8_t *data, size_t size);

#ifdef __cplusplus
}
#endif

#endif