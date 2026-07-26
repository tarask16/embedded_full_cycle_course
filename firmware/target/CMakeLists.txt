set(TARGET_NAME firmware)
set(ARTIFACT_DIR "${CMAKE_BINARY_DIR}/artifacts")
set(LINKER_SCRIPT
    "${CMAKE_CURRENT_SOURCE_DIR}/linker/STM32H743VITX_FLASH.ld"
)

file(MAKE_DIRECTORY "${ARTIFACT_DIR}")

add_executable(
    ${TARGET_NAME}
    src/main.c
    startup/startup_stm32h743xx.s
)

set_target_properties(
    ${TARGET_NAME}
    PROPERTIES
        OUTPUT_NAME "firmware"
        SUFFIX ".elf"
        RUNTIME_OUTPUT_DIRECTORY "${ARTIFACT_DIR}"
)

target_compile_definitions(
    ${TARGET_NAME}
    PRIVATE
        STM32H743xx
)

target_compile_options(
    ${TARGET_NAME}
    PRIVATE
        -mcpu=cortex-m7
        -mthumb
        -mfpu=fpv5-d16
        -mfloat-abi=hard

        -ffreestanding
        -ffunction-sections
        -fdata-sections
        -fstack-usage
        -fno-common
        -fno-builtin
        -fno-unwind-tables
        -fno-asynchronous-unwind-tables

        $<$<COMPILE_LANGUAGE:C>:
            -std=c11
            -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wsign-conversion
        >

        $<$<CONFIG:Debug>:
            -Og
            -g3
        >

        $<$<CONFIG:Release>:
            -O2
            -g1
        >
)

target_link_options(
    ${TARGET_NAME}
    PRIVATE
        -mcpu=cortex-m7
        -mthumb
        -mfpu=fpv5-d16
        -mfloat-abi=hard

        -nostdlib
        -nostartfiles

        "-T${LINKER_SCRIPT}"

        -Wl,--gc-sections
        -Wl,--cref
        -Wl,--fatal-warnings
        -Wl,--print-memory-usage
        "-Wl,-Map=${ARTIFACT_DIR}/firmware.map"
)

add_custom_command(
    TARGET ${TARGET_NAME}
    POST_BUILD

    COMMAND
        ${CMAKE_OBJCOPY}
        -O ihex
        $<TARGET_FILE:${TARGET_NAME}>
        "${ARTIFACT_DIR}/firmware.hex"

    COMMAND
        ${CMAKE_OBJCOPY}
        -O binary
        $<TARGET_FILE:${TARGET_NAME}>
        "${ARTIFACT_DIR}/firmware.bin"

    COMMAND
        ${CMAKE_SIZE}
        --format=berkeley
        $<TARGET_FILE:${TARGET_NAME}>

    COMMENT
        "Generating HEX/BIN and printing firmware size"
)