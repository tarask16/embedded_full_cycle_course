#include "efc/checksum.h"

#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static int expect_u32(
    const char *test_name,
    uint32_t actual,
    uint32_t expected)
{
    if (actual == expected) {
        printf(
            "[PASS] %s: %" PRIu32 "\n",
            test_name,
            actual
        );

        return 0;
    }

    fprintf(
        stderr,
        "[FAIL] %s: expected %" PRIu32 ", actual %" PRIu32 "\n",
        test_name,
        expected,
        actual
    );

    return 1;
}

int main(void)
{
    static const uint8_t signature[] = {
        'E', 'F', 'C', '-', 'B', 'A', 'S', 'E',
        'L', 'I', 'N', 'E', '-', '0', '1'
    };

    static const uint8_t binary_data[] = {
        UINT8_C(0),
        UINT8_C(1),
        UINT8_C(127),
        UINT8_C(128),
        UINT8_C(255)
    };

    static const uint8_t single_byte[] = {
    UINT8_C(255)
    };

    static const uint8_t data_with_zeroes[] = {
        UINT8_C(10),
        UINT8_C(0),
        UINT8_C(20),
        UINT8_C(0),
        UINT8_C(30)
    };

    int failures = 0;

    failures += expect_u32(
        "signature checksum",
        efc_checksum_u8(signature, sizeof(signature)),
        UINT32_C(972)
    );

    failures += expect_u32(
        "binary data checksum",
        efc_checksum_u8(binary_data, sizeof(binary_data)),
        UINT32_C(511)
    );

    failures += expect_u32(
        "empty checksum",
        efc_checksum_u8(NULL, 0U),
        UINT32_C(0)
    );

    failures += expect_u32(
    "single byte checksum",
    efc_checksum_u8(single_byte, sizeof(single_byte)),
    UINT32_C(255)
    );

    failures += expect_u32(
        "embedded zeroes checksum",
        efc_checksum_u8(
            data_with_zeroes,
            sizeof(data_with_zeroes)
        ),
        UINT32_C(60)
    );

    if (failures != 0) {
        fprintf(stderr, "%d checksum test(s) failed\n", failures);
        return EXIT_FAILURE;
    }

    printf("All checksum tests passed\n");
    return EXIT_SUCCESS;
}